//
//  Defaults+Keys.swift
//  String Studio
//
//  Created by Licardo on 2025/10/12.
//

import Defaults
import Foundation

/// AI翻译设置
struct AITranslationSettings: Codable, Defaults.Serializable {
    /// 是否启用AI辅助翻译
    var isEnabled: Bool = false
    /// API URL
    var apiURL: String = ""
    /// API密钥
    var apiKey: String = ""
    /// 模型名称
    var model: String = ""
}

// MARK: - Defaults Extension

extension Defaults.Keys {
    static let aiTranslationSettings = Key<AITranslationSettings>("aiTranslationSettings", default: AITranslationSettings())
}
