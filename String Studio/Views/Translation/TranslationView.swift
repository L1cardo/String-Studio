//
//  TranslationView.swift
//  String Studio
//
//  Created by Licardo on 2025/10/12.
//

import SwiftUI
import Defaults

/// 翻译界面视图
struct TranslationView: View {
    @Binding var document: StringStudioDocument
    let selectedLanguage: String
    @Binding var searchText: String

    /// 最后保存时间状态
    @State private var lastSavedDate: Date = .init()

    /// 表格条目
    @State private var tableEntries: [TableEntry] = []

    var body: some View {
        VStack(spacing: 0) {
            // 搜索栏
            SearchBarView(
                text: $searchText,
                onBatchTranslate: {
                    await batchTranslateAll()
                }
            )
            .padding(.horizontal, 2)
            .padding(.vertical, 4)

            // 翻译表格
            TranslationTableView(
                entries: tableEntries,
                document: $document,
                selectedLanguage: selectedLanguage
            )
        }
        .onAppear {
            updateTableEntries()
        }
        .onChange(of: document.xcstrings) { oldValue, newValue in
            lastSavedDate = Date()
            updateTableEntriesSmartly(oldDocument: oldValue, newDocument: newValue)
        }
        .onChange(of: selectedLanguage) { _, _ in
            updateTableEntries()
        }
        .onChange(of: searchText) { _, _ in
            updateTableEntries()
        }
        .toolbar {
            ToolbarItem {
                Button {} label: {
                    Text(formatLastSavedDate(lastSavedDate))
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
                .padding()
            }
        }
    }

    /// 更新表格条目
    private func updateTableEntries() {
        let allEntries = TableEntryExtractor.extractTableEntries(
            from: document.xcstrings,
            for: selectedLanguage
        )

        tableEntries = allEntries.filter { entry in
            searchText.isEmpty ||
                entry.key.localizedCaseInsensitiveContains(searchText) ||
                entry.defaultValue.localizedCaseInsensitiveContains(searchText) ||
                entry.targetValue.localizedCaseInsensitiveContains(searchText) ||
                entry.comment.localizedCaseInsensitiveContains(searchText)
        }
    }

    /// 智能更新表格条目（仅更新已修改的条目，保持其他条目不变）
    private func updateTableEntriesSmartly(oldDocument: XCStringsDocument, newDocument: XCStringsDocument) {
        let allNewEntries = TableEntryExtractor.extractTableEntries(
            from: newDocument,
            for: selectedLanguage
        )

        let filteredNewEntries = allNewEntries.filter { entry in
            searchText.isEmpty ||
                entry.key.localizedCaseInsensitiveContains(searchText) ||
                entry.defaultValue.localizedCaseInsensitiveContains(searchText) ||
                entry.targetValue.localizedCaseInsensitiveContains(searchText) ||
                entry.comment.localizedCaseInsensitiveContains(searchText)
        }

        // 如果条目数量发生变化，直接替换所有条目
        guard tableEntries.count == filteredNewEntries.count else {
            tableEntries = filteredNewEntries
            return
        }

        // 逐个比较和更新条目，避免不必要的重新渲染
        for (index, newEntry) in filteredNewEntries.enumerated() {
            if index < tableEntries.count {
                let currentEntry = tableEntries[index]
                // 只有当关键数据发生变化时才更新
                if currentEntry.key != newEntry.key ||
                    currentEntry.defaultValue != newEntry.defaultValue ||
                    currentEntry.targetValue != newEntry.targetValue ||
                    currentEntry.comment != newEntry.comment ||
                    currentEntry.state != newEntry.state
                {
                    tableEntries[index] = newEntry
                }
            } else {
                tableEntries.append(newEntry)
            }
        }
    }

    /// 批量翻译所有未翻译的条目（除了状态为 dontTranslate 的）
    private func batchTranslateAll() async {
        let settings = Defaults[.aiTranslationSettings]
        guard settings.isEnabled else {
            print("AI translation is disabled")
            return
        }

        guard !settings.apiURL.isEmpty, !settings.apiKey.isEmpty, !settings.model.isEmpty else {
            print("Translation settings incomplete")
            return
        }

        guard selectedLanguage != document.xcstrings.sourceLanguage else {
            print("Cannot translate source language")
            return
        }

        // 获取所有需要翻译的条目（过滤掉状态为 dontTranslate 和不需要翻译的条目）
        let entriesToTranslate = tableEntries.filter { entry in
            let trimmedText = entry.defaultValue.trimmingCharacters(in: .whitespacesAndNewlines)
            return entry.state != .dontTranslate &&
                   entry.state != .translated &&
                   !trimmedText.isEmpty &&
                   entry.key.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
        }

        guard !entriesToTranslate.isEmpty else {
            print("No entries to translate")
            return
        }

        print("🚀 Starting batch translation for \(entriesToTranslate.count) entries")

        // 批量翻译
        for (index, entry) in entriesToTranslate.enumerated() {
            print("📝 Translating entry \(index + 1)/\(entriesToTranslate.count): \(entry.key)")

            do {
                let translatedText = try await AITranslationService.shared.translate(
                    source: document.xcstrings.sourceLanguage,
                    target: selectedLanguage,
                    text: entry.defaultValue.trimmingCharacters(in: .whitespacesAndNewlines)
                )

                await MainActor.run {
                    // 更新文档
                    var updatedStrings = document.xcstrings.strings

                    if var stringEntry = updatedStrings[entry.key] {
                        if stringEntry.localizations == nil {
                            stringEntry.localizations = [:]
                        }

                        stringEntry.localizations?[selectedLanguage] = Localization(
                            stringUnit: StringUnit(
                                state: .translated,
                                value: translatedText
                            )
                        )

                        updatedStrings[entry.key] = stringEntry
                    } else {
                        let newEntry = StringEntry(
                            localizations: [
                                selectedLanguage: Localization(
                                    stringUnit: StringUnit(
                                        state: .translated,
                                        value: translatedText
                                    )
                                )
                            ]
                        )
                        updatedStrings[entry.key] = newEntry
                    }

                    document.xcstrings.strings = updatedStrings

                    // 更新 tableEntries 中对应的条目
                    if let tableIndex = tableEntries.firstIndex(where: { $0.key == entry.key }) {
                        var updatedEntry = tableEntries[tableIndex]
                        updatedEntry = TableEntry(
                            key: entry.key,
                            defaultValue: entry.defaultValue,
                            targetValue: translatedText,
                            comment: entry.comment,
                            state: .translated,
                            languageCode: selectedLanguage
                        )
                        tableEntries[tableIndex] = updatedEntry
                    }

                    print("✅ Translated: \(entry.key) -> \(translatedText)")
                }

            } catch {
                await MainActor.run {
                    print("❌ Translation failed for \(entry.key): \(error.localizedDescription)")
                }
            }

            // 添加小延迟避免API限制
            do {
                try await Task.sleep(nanoseconds: 100_000_000) // 0.1秒
            } catch {
                break
            }
        }

        print("🎉 Batch translation completed")
    }

    /// 格式化最后保存时间
    private func formatLastSavedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss a"
        return String(localized: "Last saved: \(formatter.string(from: date))")
    }
}
