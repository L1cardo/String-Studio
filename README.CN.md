<div align="center">
  <img src="./ScreenShot/StringStudio.png" alt="String Studio" width="120">
  <h1>String Studio</h1>
  <p>
    一款专为 macOS 设计的现代化国际化字符串管理工具，
    <br>
    帮助 Apple 开发者高效管理应用程序的多语言本地化文件。
  </p>

  <p>
    <strong>🇨🇳中文</strong>  | <strong><a href="./README.md">🇬🇧English</a></strong>
  </p>

  <p>
    <a href="https://apps.apple.com/app/id6753932371">
      <img src="https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg" alt="Download on the App Store" width="160">
    </a>
  </p>

  <p>
    <img src="https://img.shields.io/badge/platform-macOS-lightgrey?style=flat-square&logo=apple" alt="Platform: macOS">
    <img src="https://img.shields.io/badge/license-GPL--3.0-blue?style=flat-square" alt="License: GPL-3.0">
    <img src="https://img.shields.io/badge/Swift-5.9-orange?style=flat-square&logo=swift" alt="Swift 5.9">
    <img src="https://img.shields.io/badge/SwiftUI-blue?style=flat-square" alt="SwiftUI">
  </p>
</div>

---

## 📋 目录

- [功能特性](#-功能特性)
- [应用截图](#-应用截图)
- [安装方式](#-安装方式)
- [使用指南](#-使用指南)
- [技术详情](#-技术详情)
- [系统要求](#-系统要求)
- [贡献指南](#-贡献指南)
- [许可证](#-许可证)

## ✨ 功能特性

### 核心功能
- **📝 直观的编辑界面**：基于 SwiftUI 构建，为 .xcstrings 文件提供完整的编辑功能和现代化界面
- **🤖 AI 驱动的翻译**：集成 AI 翻译服务，支持批量字符串翻译，显著提升本地化效率
- **🌍 多语言管理**：同时管理多个语言版本，支持搜索、过滤和状态跟踪
- **👁️ 实时预览**：即时查看翻译进度和结果，确保本地化质量

### 高级功能
- **🎯 专为 Apple 开发者优化的翻译提示**，确保结果符合 Apple 设计指南
- **⚙️ 支持自定义 AI 服务配置**，灵活适应不同的开发需求
- **📊 智能状态管理**，跟踪每个字符串的翻译状态（已翻译/未翻译/不翻译）
- **🔍 高效的搜索功能**，快速定位需要编辑的字符串
- **💾 实时保存和编辑**，自动文件同步

## 🖼️ 应用截图

<img width="400" alt="EN-01" src="https://github.com/user-attachments/assets/20d99de7-2bf7-47dd-abc4-632b6759bf98" />
<img width="400" alt="EN-02" src="https://github.com/user-attachments/assets/1ed79a34-142b-4be6-86d8-b6b85f158539" />
<img width="400" alt="EN-03" src="https://github.com/user-attachments/assets/3e9832fa-a3fb-4f18-a435-2af56fe3fd8b" />

## 🚀 安装方式

### 从 App Store 安装

点击顶部的下载按钮或按照以下步骤：
1. 打开 Mac App Store
2. 搜索 "String Studio" 或直接访问：[App Store 上的 String Studio](https://apps.apple.com/app/id6753932371)
3. 点击"获取"下载并安装

### 从源码安装
1. 克隆此仓库：
   ```bash
   git clone https://github.com/yourusername/String-Studio.git
   cd String-Studio
   ```
2. 在 Xcode 中打开 `String Studio.xcodeproj`
3. 构建并运行项目

## 📖 使用指南

### 快速开始
1. **启动 String Studio** 并创建新文档或打开现有的 `.xcstrings` 文件
2. **设置源语言** - 大多数项目通常使用英语 (en)
3. **使用语言侧边栏添加目标语言**

### 字符串操作

#### 管理翻译
1. **从主表视图选择字符串**
2. **直接在目标语言列中编辑翻译**
3. **使用 AI 翻译进行批量处理**：
   - 选择多个字符串或使用"全选"
   - 点击 AI 翻译按钮
   - 选择目标语言
   - 确认开始批量翻译

#### 搜索和过滤
- **搜索栏**：通过键名或内容查找特定字符串
- **状态过滤**：按翻译状态过滤（新建、已翻译、需要审核、不翻译）
- **语言过滤**：专注于特定的目标语言

### AI 翻译设置
1. **打开设置**（⌘,）
2. **配置您的 AI 服务**：
   - 输入您的 API 密钥
   - 选择首选的 AI 提供商
   - 如需要，自定义翻译提示
3. **测试连接**以验证设置

## 🔧 技术详情

### 架构设计
- **平台**：macOS（使用 SwiftUI 构建）
- **文件格式**：`.xcstrings`（Apple 的标准本地化格式）
- **架构模式**：MVVM（模型-视图-视图模型）
- **文档管理**：使用 SwiftUI 的 `DocumentGroup` 进行文件处理

### 核心组件

#### 数据模型
- **`XCStringsDocument`**：本地化数据的根结构
- **`StringEntry`**：带有元数据的单个字符串条目
- **`Localization`**：特定语言的翻译数据
- **`TranslationState`**：用于跟踪翻译状态的枚举

#### 核心服务
- **`AITranslationService`**：处理 AI 驱动的翻译
- **`StringStudioDocument`**：管理文件 I/O 操作
- **`Defaults+Keys`**：应用程序设置和首选项

#### 视图组件
- **`MainContentView`**：主应用程序界面
- **`TranslationView`**：字符串编辑和翻译界面
- **`LanguageSidebarView`**：语言管理侧边栏
- **`SettingsView`**：应用程序配置

### 文件格式支持
String Studio 支持 Apple 的 `.xcstrings` 格式，包括：
- 带有键和值的字符串条目
- 多语言翻译
- 翻译状态（新建、已翻译、需要审核、不翻译）
- 给翻译者的注释和上下文
- 设备特定的变体
- 开发工作流的提取状态

## 📋 系统要求

- **macOS**：15.0 或更高版本


## 🤝 贡献指南

我们欢迎贡献！以下是如何帮助的方式：

### 报告问题
1. 使用 GitHub Issues 跟踪器
2. 提供关于错误的详细信息
3. 包括重现问题的步骤
4. 如适用，附上截图

### 功能请求
1. 使用"enhancement"标签打开 issue
2. 详细描述功能
3. 解释用例和好处

### 开发
1. Fork 仓库
2. 创建功能分支：`git checkout -b feature/your-feature-name`
3. 进行更改并彻底测试
4. 提交更改：`git commit -m "Add your feature"`
5. 推送到分支：`git push origin feature/your-feature-name`
6. 打开 Pull Request

### 代码风格
- 遵循 Swift 命名约定
- 使用 SwiftUI 最佳实践
- 为复杂逻辑添加注释
- 在适用的地方包含单元测试

## 📄 许可证

此项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件。

## 🙏 致谢

- Apple 提供的 SwiftUI 框架和 .xcstrings 格式
- 各种库和工具的开源社区
- 所有 beta 测试者和早期采用者的宝贵反馈

## 📞 支持

- **邮件**：[albert.abdilim@foxmail.com](mailto:albert.abdilim@foxmail.com)
- **GitHub Issues**：[在此报告问题](https://github.com/yourusername/String-Studio/issues)

---

**String Studio** - 让应用程序本地化变得简单高效 🌍