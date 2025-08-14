import 'dart:convert';

class Recipe {
  final String id;
  final String title;
  final String description;
  final List<String> ingredients;
  final String imageUrl;
  bool isFavorite;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'ingredients': ingredients,
    'imageUrl': imageUrl,
    'isFavorite': isFavorite,
  };

  factory Recipe.fromMap(Map<String, dynamic> map) => Recipe(
    id: map['id'],
    title: map['title'],
    description: map['description'],
    ingredients: List<String>.from(map['ingredients'] ?? const []),
    imageUrl: map['imageUrl'],
    isFavorite: map['isFavorite'] ?? false,
  );

  String toJson() => jsonEncode(toMap());
  factory Recipe.fromJson(String source) => Recipe.fromMap(jsonDecode(source));
}