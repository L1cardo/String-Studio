//
//  MainContentView.swift
//  String Studio
//
//  Created by Licardo on 2025/10/12.
//

import SwiftUI

/// 主内容视图
struct MainContentView: View {
    @Binding var document: StringStudioDocument
    @State private var selectedLanguage: String?
    @State private var searchText: String = ""

    var body: some View {
        NavigationSplitView {
            // 侧边栏
            LanguageSidebarView(
                document: $document,
                selectedLanguage: $selectedLanguage
            )
            .navigationSplitViewColumnWidth(min: 200, ideal: 200, max: 200)
        } detail: {
            // 主界面
            if let selectedLanguage = selectedLanguage {
                TranslationView(
                    document: $document,
                    selectedLanguage: selectedLanguage,
                    searchText: $searchText
                )
            } else {
                WelcomeView()
            }
        }
    }
}
