import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:travelbuddy/models/user.dart';
import 'package:travelbuddy/utils/index_storage_service.dart';

/// Екран профілю користувача з налаштуваннями та діями
class ProfileScreen extends StatefulWidget {
  final VoidCallback toggleTheme; // Метод для перемикання теми

  const ProfileScreen({super.key, required this.toggleTheme});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Демонстраційний користувач (замініть на завантаження з хмарного/локального сховища)
  User user = User(
    name: "Руслан Гончаров",
    email: "goncharov@gmail.com",
    savedCount: 0,
    visitedCount: 0,
    language: "Українська",
    notificationsEnabled: true,
  );

  bool isDarkMode = false; // Переменная для отслеживания состояния темы

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        // Центруємо заголовок
        title: const Center(
          child: Text(
            "Профіль",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          const SizedBox(height: 10),
          // Аватар користувача
          Center(
            child: CircleAvatar(
              radius: 48,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, size: 60, color: Colors.grey[500]),
            ),
          ),
          const SizedBox(height: 16),
          // Ім'я та email користувача
          Center(
            child: Column(
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22, // Збільшений розмір шрифту
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 18, // Збільшений розмір шрифту
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Статистика збережених та відвіданих місць
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      user.savedCount.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    const Text("Збережено", style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      user.visitedCount.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    const Text("Відвідано", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          // Заголовок налаштувань
          const Text(
            "Налаштування",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          // Вибір мови додатку
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: const Text("Мова додатку", style: TextStyle(fontSize: 16)),
              trailing: Text(
                user.language,
                style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500, fontSize: 16),
              ),
              onTap: () {},
              dense: true,
              visualDensity: VisualDensity.compact,
            ),
          ),
          const SizedBox(height: 12),
          // Перемикач сповіщень
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: const Text("Сповіщення", style: TextStyle(fontSize: 16)),
              trailing: Switch(
                value: user.notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    user.notificationsEnabled = value;
                  });
                },
              ),
              dense: true,
              visualDensity: VisualDensity.compact,
            ),
          ),
          const SizedBox(height: 12),
          // Перемикач теми
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: const Text("Темна тема", style: TextStyle(fontSize: 16)),
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                    widget.toggleTheme(); // Вызываем метод переключения теми
                  });
                },
              ),
              dense: true,
              visualDensity: VisualDensity.compact,
            ),
          ),
          const SizedBox(height: 24),
          // Кнопка очищення місць
          ElevatedButton(
            onPressed: () async {
              await clearPlacesStorage();
              print("Папки очищені, індекс скинуто.");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text("Очистити місця", style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(height: 16),
          // Кнопка виходу з профілю
          ElevatedButton(
            onPressed: () {
              // Закрыть приложение
              Future.delayed(const Duration(milliseconds: 100), () {
                // Импортировать: import 'dart:io';
                exit(0);
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text("Вийти", style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  /// Очищення всіх збережених місць та скидання індексу
  Future<void> clearPlacesStorage() async {
    final dir = await getApplicationDocumentsDirectory();
    final List<FileSystemEntity> entries = dir.listSync();

    for (var entity in entries) {
      if (entity is Directory && entity.path.contains(RegExp(r'place_\d+'))) {
        await entity.delete(recursive: true);
      }
    }

    await IndexStorageService.setLastIndex(0);
  }
}
