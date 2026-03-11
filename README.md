# Filament Manager

一个简单优雅的3D打印耗材管理应用，支持Windows和Android平台。

## 功能特性

- 耗材类型管理（预设+自定义）
- 耗材卷管理（添加、编辑、删除）
- 自动编号（同类型下递增）
- 剩余克数统计
- 手动变更剩余量
- 使用历史记录
- 剩余量预警（<10g）
- 绿白配色主题（Bambu Studio风格）
- 搜索功能
- 云端同步字段预留

## 技术栈

- 前端：Flutter 3.19
- 数据库：SQLite
- 平台：Windows、Android

### 下载构建产物

从 Release 页面下载最新版本。

## 项目结构

```
filament_manager/
├── lib/
│   ├── models/                    # 数据模型
│   │   ├── filament_type.dart
│   │   ├── filament_spool.dart
│   │   └── usage_history.dart
│   ├── services/                  # 服务层
│   │   ├── database_service.dart
│   │   ├── preset_data_service.dart
│   │   ├── filament_type_service.dart
│   │   ├── filament_spool_service.dart
│   │   └── usage_history_service.dart
│   ├── screens/                   # 页面
│   │   ├── home_page.dart
│   │   ├── filament_type_page.dart
│   │   └── usage_history_page.dart
│   ├── widgets/                   # 组件
│   │   └── filament_spool_card.dart
│   ├── theme/                     # 主题
│   │   └── app_theme.dart
│   └── main.dart                 # 入口文件
├── .github/workflows/             # GitHub Actions 配置
│   └── build.yml
├── test/
│   └── widget_test.dart
└── pubspec.yaml
```

## 使用说明

### 添加耗材卷

1. 点击右下角"添加耗材卷"按钮
2. 选择耗材类型（或先创建新类型）
3. 输入初始重量和剩余重量
4. 选择是否标记为"使用中"
5. 点击"添加"

### 编辑剩余量

1. 点击耗材卷卡片
2. 修改剩余重量
3. 点击"保存"
4. 系统自动记录使用历史

### 创建自定义类型

1. 切换到"类型"标签页
2. 点击"添加类型"按钮
3. 填写类型名称、品牌、材质、颜色
4. 点击"添加"

### 查看使用历史

1. 切换到"历史"标签页
2. 查看所有使用记录
3. 显示消耗量、修改前后剩余量

## 预设类型

系统内置30+常见耗材类型，包括：

- Bambu Lab（PLA、PETG）
- Creality（PLA）
- eSun（PLA+）
- Polymaker（PLA）
- Hatchbox（PLA）
- ColorFabb（PLA）
- MatterHackers（PLA）
- AmazonBasics（PLA）

## 开发

### 运行测试

```bash
flutter test
```

### 代码分析

```bash
flutter analyze
```

### 格式化代码

```bash
flutter format .
```

## 贡献

欢迎提交 Issue 和 Pull Request！

## 许可证

MIT License

## 联系方式

如有问题，请提交 Issue或者联系我邮箱：2776085452@qq.com
