import 'package:flutter/material.dart';
import '../models/filament_type.dart';
import '../services/filament_type_service.dart';
import '../theme/app_theme.dart';

class FilamentTypePage extends StatefulWidget {
  const FilamentTypePage({super.key});

  @override
  State<FilamentTypePage> createState() => _FilamentTypePageState();
}

class _FilamentTypePageState extends State<FilamentTypePage> {
  List<FilamentType> _types = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final types = await FilamentTypeService.getAllTypes();
      setState(() {
        _types = types;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('加载数据失败，请重试')),
        );
      }
    }
  }

  List<FilamentType> get _filteredTypes {
    if (_searchQuery.isEmpty) return _types;
    
    final query = _searchQuery.toLowerCase();
    return _types.where((type) {
      return type.name.toLowerCase().contains(query) ||
          type.brand.toLowerCase().contains(query) ||
          type.material.toLowerCase().contains(query) ||
          type.color.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> _showAddTypeDialog() async {
    final nameController = TextEditingController();
    final brandController = TextEditingController();
    final materialController = TextEditingController();
    final colorController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('添加耗材类型'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: '类型名称',
                  hintText: '例如：白色 Bambu PLA',
                  prefixIcon: Icon(Icons.label),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: brandController,
                decoration: const InputDecoration(
                  labelText: '品牌',
                  hintText: '例如：Bambu Lab',
                  prefixIcon: Icon(Icons.business),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: materialController,
                decoration: const InputDecoration(
                  labelText: '材质',
                  hintText: '例如：PLA',
                  prefixIcon: Icon(Icons.category),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: colorController,
                decoration: const InputDecoration(
                  labelText: '颜色',
                  hintText: '例如：白色',
                  prefixIcon: Icon(Icons.palette),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isEmpty ||
                  brandController.text.isEmpty ||
                  materialController.text.isEmpty ||
                  colorController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('请填写所有字段')),
                );
                return;
              }
              Navigator.pop(context, true);
            },
            child: const Text('添加'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      try {
        await FilamentTypeService.addType(
          FilamentType(
            name: nameController.text.trim(),
            brand: brandController.text.trim(),
            material: materialController.text.trim(),
            color: colorController.text.trim(),
            isPreset: false,
            createdAt: DateTime.now(),
          ),
        );
        await _loadData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('耗材类型添加成功')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('添加失败，请重试')),
          );
        }
      }
    }
  }

  Future<void> _showEditTypeDialog(FilamentType type) async {
    final nameController = TextEditingController(text: type.name);
    final brandController = TextEditingController(text: type.brand);
    final materialController = TextEditingController(text: type.material);
    final colorController = TextEditingController(text: type.color);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('编辑耗材类型'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: '类型名称',
                  prefixIcon: Icon(Icons.label),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: brandController,
                decoration: const InputDecoration(
                  labelText: '品牌',
                  prefixIcon: Icon(Icons.business),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: materialController,
                decoration: const InputDecoration(
                  labelText: '材质',
                  prefixIcon: Icon(Icons.category),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: colorController,
                decoration: const InputDecoration(
                  labelText: '颜色',
                  prefixIcon: Icon(Icons.palette),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isEmpty ||
                  brandController.text.isEmpty ||
                  materialController.text.isEmpty ||
                  colorController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('请填写所有字段')),
                );
                return;
              }
              Navigator.pop(context, true);
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      try {
        await FilamentTypeService.updateType(
          type.copyWith(
            name: nameController.text.trim(),
            brand: brandController.text.trim(),
            material: materialController.text.trim(),
            color: colorController.text.trim(),
          ),
        );
        await _loadData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('耗材类型更新成功')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('更新失败，请重试')),
          );
        }
      }
    }
  }

  Future<void> _deleteType(FilamentType type) async {
    if (type.isPreset) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('预设类型不能删除')),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除 "${type.name}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await FilamentTypeService.deleteType(type.id!);
        await _loadData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('耗材类型删除成功')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('删除失败，请重试')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('耗材类型'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: '搜索耗材类型...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: _filteredTypes.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.category_outlined,
                                size: 80,
                                color: AppTheme.textHint,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '暂无耗材类型',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: AppTheme.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadData,
                          child: ListView.builder(
                            itemCount: _filteredTypes.length,
                            itemBuilder: (context, index) {
                              final type = _filteredTypes[index];
                              return Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: AppTheme.primaryGreenLight,
                                    child: Text(
                                      type.material[0].toUpperCase(),
                                      style: const TextStyle(
                                        color: AppTheme.primaryGreen,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Text(type.name),
                                  subtitle: Text('${type.brand} - ${type.color}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (type.isPreset)
                                        const Icon(
                                          Icons.star,
                                          color: AppTheme.warningColor,
                                        ),
                                      IconButton(
                                        icon: const Icon(Icons.edit_outlined),
                                        onPressed: () => _showEditTypeDialog(type),
                                      ),
                                      if (!type.isPreset)
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline),
                                          color: AppTheme.errorColor,
                                          onPressed: () => _deleteType(type),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTypeDialog,
        icon: const Icon(Icons.add),
        label: const Text('添加类型'),
      ),
    );
  }
}