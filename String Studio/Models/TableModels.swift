//
//  TableModels.swift
//  String Studio
//
//  Created by Licardo on 2025/10/12.
//

import Foundation

/// 语言信息
struct LanguageInfo {
    /// 语言代码
    let code: String
    /// 语言名称
    let name: String
    /// 翻译进度
    let progress: Double

    /// 进度百分比字符串
    var progressPercentage: String {
        return String(format: "%.0f%%", progress * 100)
    }
}

/// 表格条目
struct TableEntry: Identifiable, Equatable {
    let id = UUID()
    /// 键名
    let key: String
    /// 默认值
    let defaultValue: String
    /// 目标翻译值
    let targetValue: String
    /// 注释
    let comment: String
    /// 状态
    let state: TranslationState
    /// 语言代码
    let languageCode: String

    init(key: String, defaultValue: String, targetValue: String, comment: String, state: TranslationState, languageCode: String) {
        self.key = key
        self.defaultValue = defaultValue
        self.targetValue = targetValue
        self.comment = comment
        self.state = state
        self.languageCode = languageCode
    }

    static func == (lhs: TableEntry, rhs: TableEntry) -> Bool {
        return lhs.key == rhs.key &&
            lhs.defaultValue == rhs.defaultValue &&
            lhs.targetValue == rhs.targetValue &&
            lhs.comment == rhs.comment &&
            lhs.state == rhs.state &&
            lhs.languageCode == rhs.languageCode
    }
}
