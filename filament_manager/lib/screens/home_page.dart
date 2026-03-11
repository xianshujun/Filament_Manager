import 'package:flutter/material.dart';
import '../models/filament_spool.dart';
import '../models/filament_type.dart';
import '../services/filament_spool_service.dart';
import '../services/filament_type_service.dart';
import '../theme/app_theme.dart';
import '../widgets/filament_spool_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<FilamentSpool> _spools = [];
  List<FilamentType> _types = [];
  bool _isLoading = true;

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
      final spools = await FilamentSpoolService.getAllSpools();
      final types = await FilamentTypeService.getAllTypes();

      setState(() {
        _spools = spools;
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

  FilamentType? _getTypeForSpool(FilamentSpool spool) {
    try {
      return _types.firstWhere((type) => type.id == spool.typeId);
    } catch (e) {
      return null;
    }
  }

  Future<void> _showAddSpoolDialog() async {
    if (_types.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先添加耗材类型')),
      );
      return;
    }

    final selectedType = await showDialog<FilamentType>(
      context: context,
      builder: (context) => _SelectTypeDialog(types: _types),
    );

    if (selectedType != null && mounted) {
      await _showAddSpoolForm(selectedType);
    }
  }

  Future<void> _showAddSpoolForm(FilamentType type) async {
    final initialWeightController = TextEditingController(text: '1000');
    final remainingWeightController = TextEditingController(text: '1000');
    bool isInUse = false;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('添加耗材卷 - ${type.name}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: initialWeightController,
                  decoration: const InputDecoration(
                    labelText: '初始重量 (g)',
                    hintText: '1000',
                    prefixIcon: Icon(Icons.scale),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: remainingWeightController,
                  decoration: const InputDecoration(
                    labelText: '剩余重量 (g)',
                    hintText: '1000',
                    prefixIcon: Icon(Icons.scale),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('正在使用'),
                  subtitle: const Text('标记为当前使用的耗材卷'),
                  value: isInUse,
                  onChanged: (value) {
                    setState(() {
                      isInUse = value;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('取消'),
              ),
              ElevatedButton(
                onPressed: () {
                  final initialWeight = int.tryParse(initialWeightController.text);
                  final remainingWeight =
                      int.tryParse(remainingWeightController.text);

                  if (initialWeight == null ||
                      remainingWeight == null ||
                      initialWeight <= 0 ||
                      remainingWeight < 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('请输入有效的重量')),
                    );
                    return;
                  }

                  if (remainingWeight > initialWeight) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('剩余重量不能大于初始重量')),
                    );
                    return;
                  }

                  Navigator.pop(context, true);
                },
                child: const Text('添加'),
              ),
            ],
          );
        },
      ),
    );

    if (result == true && mounted) {
      try {
        await FilamentSpoolService.addSpool(
          typeId: type.id!,
          initialWeight: int.parse(initialWeightController.text),
          remainingWeight: int.parse(remainingWeightController.text),
          isInUse: isInUse,
        );
        await _loadData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('耗材卷添加成功')),
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

  Future<void> _showEditSpoolDialog(FilamentSpool spool) async {
    final remainingWeightController =
        TextEditingController(text: spool.remainingWeight.toString());

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('编辑耗材卷 - ${spool.displayName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: remainingWeightController,
              decoration: const InputDecoration(
                labelText: '剩余重量 (g)',
                prefixIcon: Icon(Icons.scale),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              final remainingWeight =
                  int.tryParse(remainingWeightController.text);

              if (remainingWeight == null || remainingWeight < 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('请输入有效的重量')),
                );
                return;
              }

              if (remainingWeight > spool.initialWeight) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('剩余重量不能大于初始重量')),
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
        await FilamentSpoolService.updateRemainingWeight(
          spoolId: spool.id!,
          newRemainingWeight: int.parse(remainingWeightController.text),
        );
        await _loadData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('耗材卷更新成功')),
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

  Future<void> _deleteSpool(FilamentSpool spool) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除 ${spool.displayName} 吗？'),
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
        await FilamentSpoolService.deleteSpool(spool.id!);
        await _loadData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('耗材卷删除成功')),
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
        title: const Text('耗材管理'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: '刷新',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _spools.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 80,
                        color: AppTheme.textHint,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '暂无耗材卷',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '点击右下角按钮添加耗材卷',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textHint,
                            ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: _spools.length,
                    itemBuilder: (context, index) {
                      final spool = _spools[index];
                      final type = _getTypeForSpool(spool);
                      return FilamentSpoolCard(
                        spool: spool,
                        type: type,
                        onTap: () => _showEditSpoolDialog(spool),
                        onEdit: () => _showEditSpoolDialog(spool),
                        onDelete: () => _deleteSpool(spool),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddSpoolDialog,
        icon: const Icon(Icons.add),
        label: const Text('添加耗材卷'),
      ),
    );
  }
}

class _SelectTypeDialog extends StatefulWidget {
  final List<FilamentType> types;

  const _SelectTypeDialog({required this.types});

  @override
  State<_SelectTypeDialog> createState() => _SelectTypeDialogState();
}

class _SelectTypeDialogState extends State<_SelectTypeDialog> {
  late List<FilamentType> _filteredTypes;

  @override
  void initState() {
    super.initState();
    _filteredTypes = widget.types;
  }

  void _filterTypes(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredTypes = widget.types;
      } else {
        _filteredTypes = widget.types.where((type) {
          return type.name.toLowerCase().contains(query.toLowerCase()) ||
              type.brand.toLowerCase().contains(query.toLowerCase()) ||
              type.material.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('选择耗材类型'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: '搜索耗材类型...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterTypes,
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredTypes.length,
                itemBuilder: (context, index) {
                  final type = _filteredTypes[index];
                  return ListTile(
                    title: Text(type.name),
                    subtitle: Text('${type.brand} - ${type.material}'),
                    trailing: type.isPreset
                        ? const Icon(Icons.star, color: AppTheme.warningColor)
                        : null,
                    onTap: () => Navigator.pop(context, type),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
      ],
    );
  }
}