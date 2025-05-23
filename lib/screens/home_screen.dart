import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:travelbuddy/models/place.dart';
import 'package:travelbuddy/screens/add_place_screen.dart';
import 'package:travelbuddy/screens/profile_screen.dart';
import 'package:travelbuddy/screens/search_screen.dart';
import 'package:travelbuddy/widgets/place_card.dart';
import 'package:travelbuddy/widgets/responsive_grid.dart';

/// Головна сторінка з навігацією між екранами додатку
class HomeScreenPage extends StatefulWidget {
  final VoidCallback toggleTheme; // Метод для перемикання теми

  const HomeScreenPage({super.key, required this.toggleTheme});

  @override
  State<HomeScreenPage> createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {
  int _selectedPageIndex = 0; // Індекс вибраної сторінки

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedPageIndex,
        children: [
          const HomeScreen(),
          const SearchScreen(),
          Container(),
          ProfileScreen(toggleTheme: widget.toggleTheme),
        ],
      ),
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  /// Нижня панель навігації
  Widget _bottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedPageIndex,
      onTap: _openPage,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).canvasColor,
      items: [
        _customItem(Icons.home, "Головна", 0),
        _customItem(Icons.search, "Пошук", 1),
        _customItem(Icons.add, "Додати", 2),
        _customItem(Icons.person, "Профіль", 3),
      ],
    );
  }

  /// Кастомний елемент для нижньої панелі навігації
  BottomNavigationBarItem _customItem(
    IconData iconData,
    String label,
    int index,
  ) {
    final bool isSelected = index == _selectedPageIndex;
    final theme = Theme.of(context);

    // Використання кольорів з теми для вибраного/невибраного стану
    final Color selectedBg = theme.primaryColor;
    final Color unselectedBg = Theme.of(context).bottomNavigationBarTheme.backgroundColor ?? const Color(0xFFF5F5F5);
    final Color selectedIcon = Colors.white;
    final Color unselectedIcon = Theme.of(context).bottomNavigationBarTheme.unselectedItemColor ?? Colors.grey;

    return BottomNavigationBarItem(
      label: label,
      icon: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : unselectedBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          iconData,
          color: isSelected ? selectedIcon : unselectedIcon,
        ),
      ),
    );
  }

  /// Обробка натискання на елемент навігації
  void _openPage(int index) async {
    if (index == 2) {
      // Якщо result не використовується, можна додати нижнє підкреслення:
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddPlaceScreen()),
      );
      setState(() {
        _selectedPageIndex = 0;
      });
    } else {
      setState(() {
        _selectedPageIndex = index;
      });
    }
  }
}

/// Екран зі списком збережених місць
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Оновлення списку місць при pull-to-refresh
  Future<void> _refresh() async {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Center(
          child: Text(
            "TravelBuddy",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).appBarTheme.foregroundColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _buildPlaceList(),
      ),
    );
  }

  /// Побудова списку місць з використанням ResponsiveGrid
  Widget _buildPlaceList() {
    return FutureBuilder<List<Place>>(
      future: loadAllPlaces(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Помилка: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Обернуть пустой текст в RefreshIndicator + SingleChildScrollView
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 200),
                Center(child: Text('Немає збережених місць')),
              ],
            ),
          );
        } else {
          final places = snapshot.data!;
          return ResponsiveGrid(
            portraitCount: 1,
            landscapeCount: 2,
            childAspectRatio: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: places.map((place) => PlaceCard(place: place)).toList(),
          );
        }
      },
    );
  }
}

/// Завантаження всіх збережених місць з файлової системи
Future<List<Place>> loadAllPlaces() async {
  final Directory docsDir = await getApplicationDocumentsDirectory();
  final List<Place> places = [];

  final List<FileSystemEntity> folders = docsDir.listSync();
  for (var entity in folders) {
    if (entity is Directory && entity.path.contains(RegExp(r'place_\d+'))) {
      final File jsonFile = File('${entity.path}/place.json');
      if (await jsonFile.exists()) {
        try {
          final String content = await jsonFile.readAsString();
          final Map<String, dynamic> jsonData = jsonDecode(content);
          final Place place = Place.fromJson(jsonData);
          places.add(place);
        } catch (e) {
          print('Помилка при читанні ${jsonFile.path}: $e');
        }
      }
    }
  }

  return places;
}