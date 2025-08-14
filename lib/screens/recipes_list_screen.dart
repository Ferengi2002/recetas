import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas/providers/recipe_provider.dart';
import 'package:recetas/screens/add_recipe_screen.dart';
import 'package:recetas/widgets/recipe_item.dart';

class RecipesListScreen extends StatefulWidget {
  const RecipesListScreen({super.key});

  @override
  State<RecipesListScreen> createState() => _RecipesListScreenState();
}

class _RecipesListScreenState extends State<RecipesListScreen> {
  String _searchQuery = '';
  bool _showFavoritesOnly = false;

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final recipes = _showFavoritesOnly
        ? recipeProvider.favoriteRecipes
        : recipeProvider.recipes.where((recipe) {
            return recipe.title.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                recipe.description.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                );
          }).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recetas de Cocina 🧑‍🍳'),
        actions: [
          IconButton(
            icon: Icon(
              _showFavoritesOnly ? Icons.favorite : Icons.favorite_border,
            ),
            onPressed: () {
              setState(() {
                _showFavoritesOnly = !_showFavoritesOnly;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar recetas...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
          ),
          Expanded(
            child: recipes.isEmpty
                ? const Center(child: Text('No hay recetas disponibles.'))
                : ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      return RecipeItem(recipe: recipes[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddRecipeScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
