//
//  TranslationTableView.swift
//  String Studio
//
//  Created by Licardo on 2025/10/12.
//

import SwiftUI

/// 翻译表格视图
struct TranslationTableView: View {
    let entries: [TableEntry]
    @Binding var document: StringStudioDocument
    let selectedLanguage: String

    @State private var sortOrder: [KeyPathComparator<TableEntry>] = [
        KeyPathComparator(\.key, order: .forward)
    ]
    @State private var sortedEntries: [TableEntry] = []

    /// 检查是否为源语言
    private var isSourceLanguage: Bool {
        return selectedLanguage == document.xcstrings.sourceLanguage
    }

    var body: some View {
        Table(sortedEntries, sortOrder: $sortOrder) {
            TableColumn("Key", value: \.key) { entry in
                Text(entry.key)
                    .lineLimit(nil)
                    .font(.system(.body, design: .monospaced))
                    .textSelection(.enabled)
                    .multilineTextAlignment(.leading)
            }
            .width(min: 200, ideal: 200, max: 300)
            .alignment(.leading)

            TableColumn("Default Localization", value: \.defaultValue) { entry in
                Text(entry.defaultValue)
                    .lineLimit(nil)
                    .textSelection(.enabled)
                    .foregroundColor(.primary)
            }
            .width(min: 200, ideal: 200, max: 300)
            .alignment(.leading)

            TableColumn("\(LanguageExtractor.languageDisplayName(for: selectedLanguage))(\(selectedLanguage))", value: \.targetValue) { entry in
                TargetCellView(
                    entry: entry,
                    document: $document,
                    selectedLanguage: selectedLanguage
                )
            }
            .width(min: 200, ideal: 200, max: 300)
            .alignment(.leading)

            TableColumn("Comment", value: \.comment) { entry in
                Text(entry.comment.isEmpty ? "" : entry.comment)
                    .lineLimit(nil)
                    .textSelection(.enabled)
                    .foregroundColor(entry.comment.isEmpty ? .secondary : .primary)
            }
            .width(min: 200, ideal: 200, max: 300)
            .alignment(.leading)

            // 只有非源语言才显示State列
            if !isSourceLanguage {
                TableColumn("State", value: \.state) { entry in
                    StateLabelView(state: entry.state)
                }
                .width(min: 100, ideal: 100, max: 100)
                .alignment(.leading)
            }
        }
        .id(sortOrder)
        .onAppear {
            updateSortedEntries()
        }
        .onChange(of: sortOrder) { _, _ in
            updateSortedEntries()
        }
        .onChange(of: entries) { _, _ in
            updateSortedEntries()
        }
    }

    private func updateSortedEntries() {
        sortedEntries = entries.sorted(using: sortOrder)
    }
}
