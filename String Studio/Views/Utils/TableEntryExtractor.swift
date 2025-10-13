//
//  TableEntryExtractor.swift
//  String Studio
//
//  Created by Licardo on 2025/10/12.
//

import Foundation

/// 表格条目提取工具
enum TableEntryExtractor {
    /// 从 XCStrings 文档中提取表格条目
    static func extractTableEntries(from xcstrings: XCStringsDocument, for language: String) -> [TableEntry] {
        var validEntries: [TableEntry] = []

        for (key, entry) in xcstrings.strings {
            // 处理键名
            let trimmedKey = key.trimmingCharacters(in: .whitespacesAndNewlines)
            let isEmptyKey = trimmedKey.isEmpty

            // 过滤掉过长的键名（可能导致内存问题）
            guard trimmedKey.count < 1000 else {
                continue
            }

            // 为空键名提供显示文本
            let displayKey = isEmptyKey ? " " : trimmedKey

            // 获取默认值（源语言）
            let defaultValue: String
            if let sourceLocalization = entry.localizations?[xcstrings.sourceLanguage],
               let sourceStringUnit = sourceLocalization.stringUnit
            {
                defaultValue = sourceStringUnit.value.isEmpty ? displayKey : sourceStringUnit.value
            } else {
                defaultValue = displayKey // 回退到键名
            }

            // 获取目标翻译值和状态
            let targetValue: String
            let state: TranslationState

            // 1. 首先判断 shouldTranslate
            if let shouldTranslate = entry.shouldTranslate, !shouldTranslate {
                // 如果 shouldTranslate 为 false，状态为 Don't translate
                targetValue = ""
                state = .dontTranslate
            } else {
                // 2. 如果没有 shouldTranslate 字段或为 true，继续判断
                if let localization = entry.localizations?[language],
                   let stringUnit = localization.stringUnit
                {
                    targetValue = stringUnit.value
                    state = stringUnit.state
                } else {
                    // 3. 如果没有 localizations 字段或为空，状态为 new
                    targetValue = ""
                    state = .new
                }
            }

            let comment = entry.comment ?? ""

            let tableEntry = TableEntry(
                key: displayKey,
                defaultValue: defaultValue,
                targetValue: targetValue,
                comment: comment,
                state: state,
                languageCode: language
            )

            validEntries.append(tableEntry)
        }

        return validEntries
    }
}
