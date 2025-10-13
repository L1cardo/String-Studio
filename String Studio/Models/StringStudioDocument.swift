//
//  StringStudioDocument.swift
//  String Studio
//
//  Created by Licardo on 2025/10/12.
//

import SwiftUI
import UniformTypeIdentifiers

/// String Studio 文档模型，实现 FileDocument 协议
struct StringStudioDocument: FileDocument {
    /// XCStrings 文档数据
    var xcstrings: XCStringsDocument

    /// 支持的文件类型
    static let readableContentTypes: [UTType] = [
        UTType(filenameExtension: "xcstrings", conformingTo: .json)!
    ]

    /// 初始化新文档
    init(xcstrings: XCStringsDocument = XCStringsDocument()) {
        self.xcstrings = xcstrings
    }

    /// 从文件读取文档
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }

        guard let jsonData = string.data(using: .utf8) else {
            throw CocoaError(.fileReadCorruptFile)
        }

        do {
            let document = try JSONDecoder().decode(XCStringsDocument.self, from: jsonData)
            self.xcstrings = document
        } catch {
            throw CocoaError(.fileReadCorruptFile)
        }
    }

    /// 将文档写入文件
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        do {
            let jsonData = try JSONEncoder().encode(xcstrings)
            let formattedJSON = try JSONSerialization.jsonObject(with: jsonData, options: [])
            let prettyData = try JSONSerialization.data(withJSONObject: formattedJSON, options: [.prettyPrinted, .sortedKeys])
            return .init(regularFileWithContents: prettyData)
        } catch {
            throw CocoaError(.fileWriteInvalidFileName)
        }
    }
}
