//
//  AITranslationService.swift
//  String Studio
//
//  Created by Licardo on 2025/10/12.
//

import Alamofire
import Defaults
import Foundation

/// AI翻译服务
class AITranslationService {
    static let shared = AITranslationService()

    // MARK: - Public Methods

    /// 测试AI服务器连接
    /// - Returns: AITranslationConnectionResult 包含连接状态和详细信息
    func testConnection() async -> Bool {
        do {
            return try await translate(source: "en", target: "zh", text: "hello") != ""
        } catch {
            return false
        }
    }

    /// 发送翻译请求（async/await版本）
    /// - Parameters:
    ///   - source: 源语言代码
    ///   - target: 目标语言代码
    ///   - text: 要翻译的文本
    /// - Returns: 翻译结果
    func translate(
        source: String,
        target: String,
        text: String
    ) async throws -> String {
        let settings = Defaults[.aiTranslationSettings]

        let requestHeaders: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(settings.apiKey)"
        ]

        let requestBody: [String: Any] = [
            "messages": [
                [
                    "content": "{source: \"\(source)\", target: \"\(target)\", text: \"\(text)\"}",
                    "role": "user"
                ],
                [
                    "content": """
                    你是一名 Apple 开发者，现在你要帮助我翻译输入的内容，一定要保证翻译的结果要符合Apple 设备的使用习惯。我将给你输入{source: \"en\", target: \"zh\", text: \"hello\"} 的格式，你直接给我输出目标语言的翻译即可，也就是把 source 语言的 text 翻译成 target 语言。不要说多余的废话，只需要翻译的结果。不要用思考模型，no reasoning
                    """,
                    "role": "system"
                ]
            ],
            "model": settings.model,
            "thinking": ["type": "disabled"],
            "extra_body": ["enable_thinking": false]
        ]

        let request = createTranslationRequest(
            url: settings.apiURL,
            apiKey: settings.apiKey,
            headers: requestHeaders,
            body: requestBody
        )

        let dataTask = request.serializingData()
        let data = try await dataTask.value

        let translationResponse = try JSONDecoder().decode(AiTranslationResponse.self, from: data)

        guard let choice = translationResponse.choices.first else {
            return ""
        }

        return choice.message.content.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: - Private Methods

    /// 创建翻译请求
    ///
    /// - Parameters:
    ///   - url: 请求的完整 URL
    ///   - body: 请求体
    ///   - apiKey: API 密钥
    /// - Returns: 配置好的 DataRequest 对象
    private func createTranslationRequest(
        url: String,
        apiKey _: String,
        headers: HTTPHeaders,
        body: [String: Any]
    ) -> DataRequest {
        return AF.request(
            url,
            method: .post,
            parameters: body,
            encoding: JSONEncoding.default,
            headers: headers
        )
    }

    /// 取消所有请求
    func cancelAllRequests() {
        AF.session.invalidateAndCancel()
    }
}
