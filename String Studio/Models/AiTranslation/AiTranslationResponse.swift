//
//  AiTranslationResponse.swift
//  String Studio
//
//  Created by Licardo on 2025/10/13.
//

import Foundation

/// 翻译响应模型
struct AiTranslationResponse: Codable, Sendable {
    let choices: [Choice]
    let created: Int
    let id: String
    let model: String
    let request_id: String
    let usage: Usage

    struct Choice: Codable, Sendable {
        let finish_reason: String
        let index: Int
        let message: Message

        struct Message: Codable, Sendable {
            let content: String
            let role: String
        }
    }

    struct Usage: Codable, Sendable {
        let completion_tokens: Int
        let prompt_tokens: Int
        let prompt_tokens_details: PromptTokensDetails
        let total_tokens: Int

        struct PromptTokensDetails: Codable, Sendable {
            let cached_tokens: Int
        }
    }
}
