# GitHub Actions 使用说明

本项目使用 GitHub Actions 实现自动化构建和发布。

## 工作流文件

`.github/workflows/build.yml` - 主构建工作流

## 触发条件

### 自动触发

1. **推送到 main 分支**
   ```bash
   git push origin main
   ```

2. **创建 Pull Request**
   ```bash
   git checkout -b feature/new-feature
   git push origin feature/new-feature
   # 在 GitHub 上创建 PR
   ```

3. **创建 Release**
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   # 在 GitHub 上创建 Release
   ```

### 手动触发

1. 访问仓库的 Actions 页面
2. 选择 "Build and Release" 工作流
3. 点击 "Run workflow" 按钮
4. 选择分支（默认 main）
5. 点击 "Run workflow"

## 构建矩阵

工作流使用矩阵策略，同时构建：

| 操作系统 | 平台 | 构建命令 | 产物名称 |
|---------|-------|-----------|---------|
| Windows | Windows | `flutter build windows --release` | filament-manager-windows |
| Ubuntu | Android | `flutter build apk --release` | filament-manager-android |

## 构建步骤

### 1. 检出代码
```yaml
- name: Checkout code
  uses: actions/checkout@v4
```

### 2. 设置 Flutter
```yaml
- name: Setup Flutter
  uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.19.0'
    channel: 'stable'
    cache: true
```

### 3. 安装依赖
```yaml
- name: Install dependencies
  run: flutter pub get
```

### 4. 验证安装
```yaml
- name: Verify Flutter installation
  run: flutter doctor -v
```

### 5. 运行测试
```yaml
- name: Run tests
  run: flutter test
```

### 6. 构建应用
```yaml
- name: Build application
  run: ${{ matrix.build-command }}
```

### 7. 上传产物
```yaml
- name: Upload artifact
  uses: actions/upload-artifact@v4
  with:
    name: ${{ matrix.artifact-name }}
    path: ${{ matrix.artifact-path }}
    retention-days: 30
```

## Release 流程

当创建 GitHub Release 时：

1. **等待构建完成**
   - Windows 和 Android 构建并行执行
   - 预计耗时 10-20 分钟

2. **下载构建产物**
   - 自动下载 Windows 和 Android 产物
   - 保存到临时目录

3. **创建 Release**
   - 上传 `filament_manager.exe`
   - 上传 `app-release.apv`
   - 自动生成 Release Notes

## 下载构建产物

### 从 Actions 页面下载

1. 访问仓库的 Actions 页面
2. 选择 "Build and Release" 工作流
3. 选择一次成功的构建
4. 在 "Artifacts" 部分下载：
   - `filament-manager-windows` - Windows 可执行文件
   - `filament-manager-android` - Android APK 文件

### 从 Release 页面下载

1. 访问仓库的 Releases 页面
2. 选择一个 Release 版本
3. 下载附件：
   - `filament_manager.exe` - Windows 安装包
   - `app-release.apv` - Android 安装包

## 缓存策略

工作流使用以下缓存优化构建速度：

1. **Flutter SDK 缓存**
   ```yaml
   cache: true
   cache-key: flutter-${{ runner.os }}-${{ hashFiles('**/pubspec.lock') }}
   ```

2. **依赖缓存**
   - 自动缓存 `.pub-cache` 目录
   - 基于依赖文件哈希

## 故障排查

### 构建失败

**检查步骤：**
1. 查看 Actions 日志
2. 确认 Flutter 版本兼容性
3. 检查依赖冲突
4. 验证测试是否通过

### 常见错误

**错误：`flutter doctor` 失败**
- 解决：检查 Flutter SDK 安装

**错误：依赖安装失败**
- 解决：检查 `pubspec.yaml` 格式

**错误：测试失败**
- 解决：本地运行 `flutter test` 修复问题

**错误：构建超时**
- 解决：检查网络连接，重试构建

## 性能优化

### 当前优化

- ✅ Flutter SDK 缓存
- ✅ 依赖缓存
- ✅ 并行构建（Windows + Android）
- ✅ 失败快速终止（fail-fast: false）

### 未来优化

- ⏳ 增量构建
- ⏳ 构建结果缓存
- ⏳ 自托管 Runner

## 安全性

- ✅ 使用官方 Actions
- ✅ 依赖版本固定
- ✅ 无敏感信息泄露
- ✅ 最小权限原则

## 维护

### 更新 Flutter 版本

修改 `.github/workflows/build.yml`：
```yaml
- name: Setup Flutter
  uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.20.0'  # 更新版本
```

### 添加新平台

在 matrix 中添加新平台：
```yaml
matrix:
  os: [windows-latest, ubuntu-latest, macos-latest]
  include:
    - os: macos-latest
      platform: macos
      build-command: flutter build macos --release
      artifact-name: filament-manager-macos
      artifact-path: build/macos/Build/Products/Release/
```

## 贡献

修改工作流时：
1. 创建分支
2. 修改 `.github/workflows/build.yml`
3. 提交并推送
4. 创建 Pull Request
5. 等待 CI 通过