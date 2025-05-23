import 'package:travelbuddy/utils/index_storage_service.dart';

/// Клас Place описує туристичне місце, яке зберігається у додатку.
/// Містить основні дані про місце: id, назву, опис, рейтинг, шлях до фото та категорію.
/// Для унікальності id використовується лічильник _counter, який синхронізується з IndexStorageService.
class Place {
  static int _counter = 0;

  final int id; // Унікальний ідентифікатор місця
  final String title; // Назва місця
  final String? description; // Опис місця
  final double? rating; // Рейтинг місця
  String? path; // Шлях до папки з фото місця
  final String? category; // Категорія місця

  /// Конструктор для створення нового місця (id генерується автоматично)
  Place({
    required this.title,
    this.description,
    this.rating,
    this.path,
    required this.category,
  }) : id = _counter++;

  /// Приватний конструктор для створення місця з JSON (id задається явно)
  Place._fromJson({
    required this.id,
    required this.title,
    this.description,
    this.rating,
    this.path,
    required this.category,
  });

  /// Створення об'єкта Place з JSON-даних
  factory Place.fromJson(Map<String, dynamic> json) {
    return Place._fromJson(
      id: json['id'],
      title: json['title'],
      rating: (json['rating'] as num?)?.toDouble(),
      description: json['description'],
      path: json['path'],
      category: json['category'],
    );
  }

  /// Перетворення об'єкта Place у JSON для збереження
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'rating': rating,
      'description': description,
      'path': path,
      'category': category,
    };
  }

  /// Ініціалізація лічильника id з IndexStorageService (перед першим використанням)
  static Future<void> initCounter() async {
    _counter = await IndexStorageService.getLastIndex();
  }

  /// Збереження поточного значення лічильника id у IndexStorageService
  static Future<void> saveCounter() async {
    await IndexStorageService.setLastIndex(_counter);
  }
}
