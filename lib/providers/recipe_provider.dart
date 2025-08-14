import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recetas/models/recipe.dart';

class RecipeProvider with ChangeNotifier {
  static const _storageKey = 'recipes_storage_v1';

  List<Recipe> _recipes = [];
  List<Recipe> get recipes => _recipes;

  Future<void> loadRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_storageKey) ?? [];
    _recipes = jsonList.map((e) => Recipe.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _recipes.map((r) => r.toJson()).toList();
    await prefs.setStringList(_storageKey, jsonList);
  }

  Future<void> addRecipe(Recipe recipe) async {
    _recipes.add(recipe);
    await _persist();
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String id) async {
    final index = _recipes.indexWhere((r) => r.id == id);
    if (index != -1) {
      _recipes[index].isFavorite = !_recipes[index].isFavorite;
      await _persist();
      notifyListeners();
    }
  }

  List<Recipe> get favoriteRecipes =>
      _recipes.where((r) => r.isFavorite).toList();

  Future<void> updateRecipe(Recipe recipe) async {
    final index = _recipes.indexWhere((r) => r.id == recipe.id);
    if (index != -1) {
      _recipes[index] = recipe;
      await _persist();
      notifyListeners();
    }
  }

  Future<void> deleteRecipe(String id) async {
    _recipes.removeWhere((r) => r.id == id);
    await _persist();
    notifyListeners();
  }
}