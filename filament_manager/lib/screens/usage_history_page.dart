import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/usage_history.dart';
import '../models/filament_spool.dart';
import '../models/filament_type.dart';
import '../services/usage_history_service.dart';
import '../services/filament_spool_service.dart';
import '../services/filament_type_service.dart';
import '../theme/app_theme.dart';

class UsageHistoryPage extends StatefulWidget {
  const UsageHistoryPage({super.key});

  @override
  State<UsageHistoryPage> createState() => _UsageHistoryPageState();
}

class _UsageHistoryPageState extends State<UsageHistoryPage> {
  List<UsageHistory> _history = [];
  Map<int, FilamentSpool> _spools = {};
  Map<int, FilamentType> _types = {};
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
      final history = await UsageHistoryService.getAllHistory();
      final spools = await FilamentSpoolService.getAllSpools();
      final types = await FilamentTypeService.getAllTypes();

      final spoolsMap = {for (var spool in spools) spool.id!: spool};
      final typesMap = {for (var type in types) type.id!: type};

      setState(() {
        _history = history;
        _spools = spoolsMap;
        _types = typesMap;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载数据失败: $e')),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return '今天 ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays == 1) {
      return '昨天 ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前 ${DateFormat('HH:mm').format(date)}';
    } else {
      return DateFormat('yyyy-MM-dd HH:mm').format(date);
    }
  }

  FilamentSpool? _getSpoolForHistory(UsageHistory history) {
    return _spools[history.spoolId];
  }

  FilamentType? _getTypeForHistory(UsageHistory history) {
    final spool = _getSpoolForHistory(history);
    if (spool == null) return null;
    return _types[spool.typeId];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('使用历史'),
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
          : _history.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history_outlined,
                        size: 80,
                        color: AppTheme.textHint,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '暂无使用记录',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '编辑耗材卷剩余量时会自动记录',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textHint,
                            ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _history.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final history = _history[index];
                      final spool = _getSpoolForHistory(history);
                      final type = _getTypeForHistory(history);

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: AppTheme.textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _formatDate(history.createdAt),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppTheme.textSecondary,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              if (type != null)
                                Text(
                                  type.name,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              if (spool != null)
                                Text(
                                  spool.displayName,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppTheme.textSecondary,
                                      ),
                                ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryGreenLight.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildStatItem(
                                      context,
                                      '消耗',
                                      '${history.usedWeight}g',
                                      Icons.arrow_downward,
                                      AppTheme.primaryGreen,
                                    ),
                                    Container(
                                      width: 1,
                                      height: 40,
                                      color: AppTheme.dividerColor,
                                    ),
                                    _buildStatItem(
                                      context,
                                      '修改前',
                                      '${history.remainingBefore}g',
                                      Icons.history,
                                      AppTheme.textSecondary,
                                    ),
                                    Container(
                                      width: 1,
                                      height: 40,
                                      color: AppTheme.dividerColor,
                                    ),
                                    _buildStatItem(
                                      context,
                                      '修改后',
                                      '${history.remainingAfter}g',
                                      Icons.check_circle,
                                      AppTheme.primaryGreen,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
                        const SizedBox(height: 4),
                        Text(
                          value,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: color,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          label,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                        ),
                      ],
                    );
  }
}