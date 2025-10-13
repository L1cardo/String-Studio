//
//  SettingsView.swift
//  String Studio
//
//  Created by Licardo on 2025/10/12.
//

import Defaults
import SwiftUI

struct SettingsView: View {
    @Default(.aiTranslationSettings) var settings
    @State private var aiTranslationEnabled: Bool = false
    @State private var aiTranslationAPIURL: String = ""
    @State private var aiTranslationAPIKey: String = ""
    @State private var aiTranslationModel: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom)

            VStack(alignment: .leading, spacing: 15) {
                Text("AI assist traslation")
                    .font(.title2)
                    .fontWeight(.semibold)

                Toggle(isOn: $aiTranslationEnabled) {
                    Text("Enable")
                }
                .onChange(of: aiTranslationEnabled) { _, _ in
                    settings.isEnabled = aiTranslationEnabled
                }

                if settings.isEnabled {
                    // API URL输入框
                    VStack(alignment: .leading, spacing: 5) {
                        Text("API URL:")
                            .font(.headline)

                        TextField("Please enter API URL", text: $aiTranslationAPIURL)
                            .onChange(of: aiTranslationAPIURL) { _, _ in
                                settings.apiURL = aiTranslationAPIURL
                            }
                    }

                    // API Key输入框
                    VStack(alignment: .leading, spacing: 5) {
                        Text("API Key:")
                            .font(.headline)

                        SecureField("Please enter API Key", text: $aiTranslationAPIKey)
                            .onChange(of: aiTranslationAPIKey) { _, _ in
                                settings.apiKey = aiTranslationAPIKey
                            }
                    }

                    // Model输入框
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Model:")
                            .font(.headline)

                        TextField("Please enter model name", text: $aiTranslationModel)
                            .onChange(of: aiTranslationModel) { _, _ in
                                settings.model = aiTranslationModel
                            }
                    }

                    ConnectionStatusView()
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
        .padding()
        .frame(minWidth: 400, minHeight: 300)
        .onAppear {
            aiTranslationEnabled = settings.isEnabled
            aiTranslationAPIURL = settings.apiURL
            aiTranslationAPIKey = settings.apiKey
            aiTranslationModel = settings.model
        }
    }

    /// 检查配置是否完整
    private var isConfigured: Bool {
        return !aiTranslationAPIURL.isEmpty &&
            !aiTranslationAPIKey.isEmpty &&
            !aiTranslationModel.isEmpty
    }
}

#Preview {
    SettingsView()
}
