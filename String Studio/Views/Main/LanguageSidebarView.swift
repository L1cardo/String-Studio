//
//  LanguageSidebarView.swift
//  String Studio
//
//  Created by Licardo on 2025/10/12.
//

import SwiftUI

/// 语言侧边栏视图
struct LanguageSidebarView: View {
    @Binding var document: StringStudioDocument
    @Binding var selectedLanguage: String?

    /// 提取的语言信息
    private var languages: [LanguageInfo] {
        LanguageExtractor.extractLanguages(from: document.xcstrings)
    }

    var body: some View {
        List(languages, id: \.code, selection: $selectedLanguage) { language in
            LanguageRowView(language: language, sourceLanguage: document.xcstrings.sourceLanguage)
        }
    }
}

/// 语言行视图
struct LanguageRowView: View {
    let language: LanguageInfo
    let sourceLanguage: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(language.name)
                    .font(.body)
                Text(language.code)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()

            // 源语言不显示进度统计
            if language.code != sourceLanguage {
                Text(language.progressPercentage)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.secondary.opacity(0.2))
                    .clipShape(Capsule())
            }
        }
    }
}

/// 语言提取工具
enum LanguageExtractor {
    /// 获取源语言代码
    static func getSourceLanguage(from xcstrings: XCStringsDocument) -> String {
        return xcstrings.sourceLanguage
    }

    /// 从 XCStrings 文档中提取语言信息
    static func extractLanguages(from xcstrings: XCStringsDocument) -> [LanguageInfo] {
        var languageSet: Set<String> = []
        var languageProgress: [String: (translated: Int, total: Int)] = [:]

        // 包含源语言
        languageSet.insert(xcstrings.sourceLanguage)
        languageProgress[xcstrings.sourceLanguage] = (0, 0)

        // 提取所有语言
        for (_, entry) in xcstrings.strings {
            if let localizations = entry.localizations {
                for languageCode in localizations.keys {
                    languageSet.insert(languageCode)
                }
            }
        }

        // 计算进度
        for language in languageSet {
            var translated = 0
            var total = 0

            for (_, entry) in xcstrings.strings {
                // 统计总条目数
                total += 1

                if language == xcstrings.sourceLanguage {
                    // 源语言：如果有源语言本地化且有值，就算翻译完成
                    if let sourceLocalization = entry.localizations?[language],
                       let stringUnit = sourceLocalization.stringUnit
                    {
                        if !stringUnit.value.isEmpty {
                            translated += 1
                        }
                    } else if let shouldTranslate = entry.shouldTranslate, !shouldTranslate {
                        // 如果设置了shouldTranslate=false，也算作已处理
                        translated += 1
                    }
                } else {
                    // 目标语言：首先检查shouldTranslate
                    if let shouldTranslate = entry.shouldTranslate, !shouldTranslate {
                        // 如果shouldTranslate为false，直接算作已处理
                        translated += 1
                    } else if let localization = entry.localizations?[language],
                              let stringUnit = localization.stringUnit
                    {
                        // 否则检查localization状态
                        if stringUnit.state == .translated || stringUnit.state == .dontTranslate {
                            translated += 1
                        }
                    }
                }
            }

            languageProgress[language] = (translated, total)
        }

        // 转换为 LanguageInfo 数组，确保源语言在最上面
        return languageSet.sorted { lhs, rhs in
            if lhs == xcstrings.sourceLanguage {
                return true
            } else if rhs == xcstrings.sourceLanguage {
                return false
            } else {
                return lhs < rhs
            }
        }.map { languageCode in
            let progress = languageProgress[languageCode]!
            let progressDouble = progress.total > 0 ? Double(progress.translated) / Double(progress.total) : 0.0
            return LanguageInfo(
                code: languageCode,
                name: languageDisplayName(for: languageCode),
                progress: progressDouble
            )
        }
    }

    /// 获取语言的显示名称
    static func languageDisplayName(for code: String) -> String {
        let currentLocale = Locale.current
        return currentLocale.localizedString(forIdentifier: code) ?? code
    }
}
