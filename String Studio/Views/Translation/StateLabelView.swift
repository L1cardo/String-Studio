//
//  StateLabelView.swift
//  String Studio
//
//  Created by Licardo on 2025/10/12.
//

import SwiftUI

/// 状态标签视图
struct StateLabelView: View {
    let state: TranslationState

    var body: some View {
        if state == .translated {
            Image(systemName: "checkmark.circle")
                .foregroundStyle(borderColor)
        } else {
            Text(state.displayName)
                .font(.system(size: 8, weight: .bold))
                .foregroundStyle(Color.primary)
                .padding(.vertical, 1)
                .padding(.horizontal, 2)
                .background(borderColor.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(borderColor, lineWidth: 1)
                )
        }
    }

    /// 边框颜色
    private var borderColor: Color {
        switch state {
        case .dontTranslate:
            return .gray
        case .new:
            return .blue
        case .translated:
            return .green
        case .needsReview:
            return .orange
        }
    }
}

#Preview {
    StateLabelView(state: .new)
        .padding()
}
