import 'package:flutter/material.dart';
import 'services/preset_data_service.dart';
import 'theme/app_theme.dart';
import 'screens/home_page.dart';
import 'screens/filament_type_page.dart';
import 'screens/usage_history_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PresetDataService.initializePresetData();
  runApp(const FilamentManagerApp());
}

class FilamentManagerApp extends StatelessWidget {
  const FilamentManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '耗材管理',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const FilamentTypePage(),
    const UsageHistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: '耗材卷',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category),
            label: '类型',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: '历史',
          ),
        ],
      ),
    );
  }
}