import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:travelbuddy/models/place.dart';
import 'package:dropdown_search/dropdown_search.dart';

/// Екран для додавання нового місця.
/// Дозволяє ввести назву, опис, вибрати категорію та додати фото.
class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final TextEditingController _nameController = TextEditingController(); // Контролер для назви
  final TextEditingController _descriptionController = TextEditingController(); // Контролер для опису
  String? _selectedCategory; // Обрана категорія
  final ImagePicker _picker = ImagePicker(); // Пікер зображень
  List<XFile> pickedImages = []; // Список вибраних зображень

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildText("Назва місця *"),
            const SizedBox(height: 10),
            _buildTextField(),
            const SizedBox(height: 10),
            _buildText("Категорія *"),
            const SizedBox(height: 10),
            _buildCategoryDropdown(),
            SizedBox(height: 10),
            _buildText("Опис"),
            const SizedBox(height: 10),
            _buildDescription(),
            const SizedBox(height: 10),
            _buildText("Додати фото"),
            const SizedBox(height: 10),
            _buildImageBar(),
            const SizedBox(height: 30),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  /// Текстовий заголовок для полів
  Widget _buildText(String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    );
  }

  /// AppBar для сторінки додавання місця
  dynamic _buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.blue,
      title: Text(
        "Додати місце",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
    );
  }

  /// Поле для введення назви місця
  Widget _buildTextField() {
    return TextFormField(
      controller: _nameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        return (value == null || value.isEmpty) ? '' : null;
      },
      decoration: InputDecoration(
        labelText: 'Введіть назву...',
        border: const OutlineInputBorder(),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }

  /// Випадаючий список для вибору категорії
  Widget _buildCategoryDropdown() {
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
    return DropdownSearch<String>(
      items: categories,
      selectedItem: _selectedCategory,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Категорія",
          hintText: "Оберіть категорію",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      popupProps: PopupProps.menu(
        showSearchBox: true,
        constraints: BoxConstraints(maxHeight: 300),
      ),
      onChanged: (String? newValue) {
        setState(() {
          _selectedCategory = newValue;
        });
      },
      validator:
          (value) =>
              value == null || value.isEmpty ? 'Оберіть категорію' : null,
    );
  }

  /// Поле для введення опису місця
  Widget _buildDescription() {
    return TextField(
      controller: _descriptionController,
      keyboardType: TextInputType.multiline,
      maxLines: 5,
      decoration: InputDecoration(
        isDense: true,
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      ),
    );
  }

  /// Панель для додавання та перегляду вибраних фото
  Widget _buildImageBar() {
    return SizedBox(
      height: 120,
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: pickImage,
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 228, 228, 228),
                borderRadius: BorderRadius.circular(15),
              ),
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(15),
                color: Colors.grey,
                dashPattern: [5, 5],
                strokeWidth: 2,
                child: Center(child: Icon(Icons.add_circle_rounded)),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: pickedImages.length,
              separatorBuilder: (_, __) => SizedBox(width: 10),
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.file(
                    File(pickedImages[index].path),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Плейсхолдер, якщо зображення не завантажилось
                      return Container(
                        height: 100,
                        width: 100,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 40,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Кнопка для збереження нового місця
  Widget _buildSaveButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Проверяем наличие названия, если пусто — показываем ошибку
          if (_nameController.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Введіть назву місця')),
            );
            return;
          }
          // Если категория не выбрана, ставим "Інше"
          if (_selectedCategory == null || _selectedCategory!.isEmpty) {
            _selectedCategory = "Інше";
          }
          _savePlace();
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
        child: Text(
          'Зберегти',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// Вибір зображення з галереї
  void pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        pickedImages.add(image);
      });
    }
  }

  /// Збереження нового місця у файлову систему
  Future<void> _savePlace() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Place.initCounter();
    Place _savingPlace = Place(
      title: _nameController.text,
      description: _descriptionController.text,
      category: _selectedCategory,
    );
    final Directory docsDir = await getApplicationDocumentsDirectory();
    final Directory placeDir = Directory(
      '${docsDir.path}/place_${_savingPlace.id}',
    );
    if (!await placeDir.exists()) {
      await placeDir.create(recursive: true);
    }
    for (int i = 0; i < pickedImages.length; i++) {
      final XFile img = pickedImages[i];
      final String newPath = '${placeDir.path}/img_$i.jpg';
      await File(img.path).copy(newPath);
    }
    _savingPlace.path = placeDir.path;

    final File jsonFile = File('${placeDir.path}/place.json');
    await jsonFile.writeAsString(jsonEncode(_savingPlace.toJson()));

    await Place.saveCounter();

    print("Place saved to ${placeDir.path}");
  }
}
