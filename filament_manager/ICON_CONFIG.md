# 应用图标配置指南

## 当前状态

✅ 图标文件已放置：`assets/manager.png`
✅ pubspec.yaml 已配置：添加了 assets 引用

## 需要手动配置的部分

由于环境权限限制，以下配置需要你手动完成：

### 1. Windows 图标

**目标文件：** `windows/runner/resources/app_icon.ico`

**步骤：**
1. 将 `manager.png` 转换为 `.ico` 格式
   - 可以使用在线工具：https://convertio.co/png-to-ico
   - 或使用 ImageMagick：`convert manager.png -define icon:auto-resize=256,128,64,48,32,16 app_icon.ico`

2. 替换 `windows/runner/resources/app_icon.ico` 文件
3. 重新构建应用：`flutter build windows --release`

**说明：**
- Windows 应用需要 256x256, 128x128, 64x64, 48x48, 32x32, 16x16 多个尺寸
- 推荐使用专业工具转换

### 2. Android 图标

**目标文件：** `android/app/src/main/res/mipmap-*`

**步骤：**
1. 创建不同尺寸的图标：
   - mipmap-mdpi: 48x48
   - mipmap-hdpi: 72x72
   - mipmap-xhdpi: 96x96
   - mipmap-xxhdpi: 144x144
   - mipmap-xxxhdpi: 192x192

2. 将图标放置到对应目录：
   ```
   android/app/src/main/res/
   ├── mipmap-mdpi/ic_launcher.png
   ├── mipmap-hdpi/ic_launcher.png
   ├── mipmap-xhdpi/ic_launcher.png
   ├── mipmap-xxhdpi/ic_launcher.png
   └── mipmap-xxxhdpi/ic_launcher.png
   ```

3. 重新构建应用：`flutter build apk --release`

**说明：**
- Android 需要多个尺寸的图标
- 文件名必须是 `ic_launcher.png`

### 3. 自动生成图标（推荐）

**使用 flutter_launcher_icons 插件：**

1. 安装插件：
   ```bash
   flutter pub add flutter_launcher_icons
   ```

2. 配置 pubspec.yaml：
   ```yaml
   flutter_launcher_icons:
     android: true
     ios: false
     image_path: "assets/manager.png"
     adaptive_icon_background: "#00C853"
   ```

3. 生成图标：
   ```bash
   flutter pub run
   flutter_launcher_icons
   ```

4. 重新构建：
   ```bash
   flutter build windows --release
   flutter build apk --release
   ```

**优势：**
- 自动生成所有平台所需尺寸
- 自动生成自适应图标（Android）
- 一次性配置，多平台使用

## 快速配置方案

### 方案1：使用 flutter_launcher_icons（推荐）

```bash
# 1. 添加插件
flutter pub add flutter_launcher_icons

# 2. 生成图标
flutter pub get
flutter_launcher_icons

# 3. 重新构建
flutter build windows --release
flutter build apk --release
```

### 方案2：手动配置（不推荐）

需要手动转换图标并替换多个文件，比较繁琐。

## 验证图标

### Windows

构建后检查：
- `build/windows/x64/runner/Release/filament_manager.exe` 的图标是否更新

### Android

构建后检查：
- APK 的安装图标是否更新
- 可以在模拟器或真机上测试

## 常见问题

### Q: 图标显示模糊？

A: 确保图标尺寸正确：
- Windows：至少 256x256
- Android：至少 192x192

### Q: 图标背景色不对？

A: 使用 flutter_launcher_icons 时，配置 `adaptive_icon_background`：
```yaml
flutter_launcher_icons:
  adaptive_icon_background: "#00C853"  # 绿色背景
```

### Q: 如何测试图标？

A:
- Windows：构建后查看 exe 文件图标
- Android：安装 APK 后查看桌面图标

## 推荐工具

### 在线转换工具
- https://convertio.co/png-to-ico - PNG 转 ICO
- https://cloudconvert.com/png-to-ico - 多格式转换

### 命令行工具
- ImageMagick：`convert manager.png app_icon.ico`
- flutter_launcher_icons：自动生成所有平台图标

## 下一步

1. 选择配置方案（推荐使用 flutter_launcher_icons）
2. 执行配置命令
3. 重新构建应用
4. 验证图标是否正确显示