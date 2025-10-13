//
//  TranslationRequest.swift
//  String Studio
//
//  Created by Licardo on 2025/10/13.
//

import Foundation

/// 翻译请求模型
struct AiTranslationRequest: Codable, Sendable {
    let messages: [Message]
    let model: String
    let thinking: Thinking
    let extra_body: ExtraBody

    struct Message: Codable, Sendable {
        let content: String
        let role: String
    }

    struct Thinking: Codable, Sendable {
        let type: String
    }

    struct ExtraBody: Codable, Sendable {
        let enable_thinking: Bool
    }
}
