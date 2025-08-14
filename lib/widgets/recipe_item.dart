import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas/models/recipe.dart';
import 'package:recetas/providers/recipe_provider.dart';
import 'package:recetas/screens/edit_recipe_screen.dart';
import 'package:share_plus/share_plus.dart';

class RecipeItem extends StatelessWidget {
  const RecipeItem({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {

    final recipeProvider = Provider.of<RecipeProvider>(context);

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(recipe.imageUrl),
        ),
        title: Text(recipe.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(recipe.description, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: Wrap(
          children: [
            IconButton(
              icon: Icon(
                recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: recipe.isFavorite ? Colors.red : null,
              ),
              onPressed: () {
                recipeProvider.toggleFavoriteStatus(recipe.id);
              },
            ),
            IconButton(
              onPressed: () {
                // ignore: deprecated_member_use
                Share.share('Oe mmvrg, mira esta receta ${recipe.title}\n\n Descripcion: ${recipe.description}\n\n Ingredientes: ${recipe.ingredients}');
              },
              icon: const Icon(Icons.share),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditRecipeScreen(recipe: recipe),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                recipeProvider.deleteRecipe(recipe.id);
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}