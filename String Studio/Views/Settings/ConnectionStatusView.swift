//
//  ConnectionStatusView.swift
//  String Studio
//
//  Created by Licardo on 2025/10/12.
//

import Defaults
import SwiftUI

/// 连接状态显示视图
struct ConnectionStatusView: View {
    @State private var isTestingConnection: Bool = false
    @State private var hasConnectionToAIServer: Bool = false
    @Default(.aiTranslationSettings) var aiTranslationSettings

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button {
                testConnection()
            } label: {
                HStack {
                    if isTestingConnection {
                        ProgressView()
                            .controlSize(.small)
                    } else {
                        Text("Test connection")
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(isTestingConnection || !isConfigured)

            HStack {
                if isTestingConnection {
                    ProgressView()
                        .controlSize(.small)
                    Text("Testing connection...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    Image(systemName: hasConnectionToAIServer ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundStyle(hasConnectionToAIServer ? Color.green : Color.red)

                    Text(hasConnectionToAIServer ? "Connection successful" : "Connection failed")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(hasConnectionToAIServer ? Color.green : Color.red)
                }
            }
        }
    }

    /// 检查配置是否完整
    private var isConfigured: Bool {
        return !aiTranslationSettings.apiURL.isEmpty &&
            !aiTranslationSettings.apiKey.isEmpty &&
            !aiTranslationSettings.model.isEmpty
    }

    // MARK: - Connection Test

    private func testConnection() {
        isTestingConnection = true
        Task {
            hasConnectionToAIServer = await AITranslationService.shared.testConnection()

            DispatchQueue.main.async {
                self.isTestingConnection = false
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        ConnectionStatusView()
    }
    .padding()
}
