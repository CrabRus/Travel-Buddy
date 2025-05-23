import 'dart:io';

import 'package:flutter/material.dart';
import 'package:travelbuddy/models/place.dart';
import 'package:travelbuddy/screens/home_screen.dart';
import 'package:travelbuddy/screens/place_details_screen.dart';
import 'package:travelbuddy/widgets/responsive_grid.dart';
import 'package:dropdown_search/dropdown_search.dart';

/// Екран пошуку місць з фільтрацією за категорією та назвою
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Place> allPlaces = []; // Всі місця
  List<Place> filteredPlaces = []; // Відфільтровані місця
  String selectedCategory = 'Всі категорії'; // Обрана категорія
  String searchQuery = ''; // Пошуковий запит
  final List<String> categories = [
      'Інше',
      'Парк',
      'Музей',
      'Галерея',
      'Замок',
      'Палац',
      'Площа',
      'Пляж',
      'Гора',
      'Озеро',
      'Ліс',
      'Печера',
      'Зоопарк',
      'Акваріум',
      'Театр',
      'Церква',
      'Монастир',
      'Фортеця',
      'Памʼятник',
      'Ринок',
      'Фестиваль',
      'Історичне місце',
      'Ресторан',
      'Кафе',
      'Нічний клуб',
      'Набережна',
      'Ботанічний сад',
      'Спортивний комплекс',
      'Оглядовий майданчик',
      'Місце для кемпінгу',
    ];
  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  /// Завантаження всіх місць (замість цього можна підключити свою логіку)
  Future<void> _loadPlaces() async {
    final places = await loadAllPlaces();
    setState(() {
      allPlaces = places;
      filteredPlaces = places; // Спочатку показуємо всі місця
    });
  }

  /// Фільтрація місць за категорією та пошуковим запитом
  void _filterPlaces() {
    setState(() {
      filteredPlaces = allPlaces.where((place) {
        final matchesCategory = selectedCategory == 'Всі категорії' ||
            place.category == selectedCategory;
        final matchesSearch = place.title
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(
          child: Text(
            "Пошук",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Поля для пошуку та вибору категорії
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Пошук місця',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  onChanged: (value) {
                    searchQuery = value;
                    _filterPlaces();
                  },
                ),
                const SizedBox(height: 16),
                // Замість DropdownButtonFormField використовуйте DropdownSearch як у AddPlaceScreen
                DropdownSearch<String>(
                  items: categories,
                  selectedItem: selectedCategory,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: "Категорія",
                      hintText: "Оберіть категорію",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    constraints: const BoxConstraints(maxHeight: 300),
                  ),
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        selectedCategory = value;
                        _filterPlaces();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Відображення знайдених місць у вигляді сітки
          Expanded(
            child: filteredPlaces.isEmpty
                ? const Center(
                    child: Text(
                      'Нічого не знайдено',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ResponsiveGrid(
                    portraitCount: 1,
                    landscapeCount: 2,
                    childAspectRatio: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 0,
                    children: filteredPlaces.map((place) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(place: place),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                          child: SizedBox(
                            height: 110,
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                                  child: _buildPlaceImage(place),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          place.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          place.category ?? '',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 15,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  /// Побудова зображення місця або плейсхолдер, якщо фото немає
  Widget _buildPlaceImage(Place place) {
    final imagePath = place.path != null ? '${place.path}/img_0.jpg' : null;
    if (imagePath != null && File(imagePath).existsSync()) {
      return Image.file(
        File(imagePath),
        width: 110,
        height: 110,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _noImagePlaceholder();
        },
      );
    } else {
      return _noImagePlaceholder();
    }
  }

  /// Плейсхолдер, якщо немає фото
  Widget _noImagePlaceholder() {
    return Container(
      width: 110,
      height: 110,
      color: Colors.grey[300],
      child: const Icon(
        Icons.image_not_supported,
        color: Colors.grey,
        size: 40,
      ),
    );
  }
}