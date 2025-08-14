import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas/models/recipe.dart';
import 'package:recetas/providers/recipe_provider.dart';

class EditRecipeScreen extends StatefulWidget {
  const EditRecipeScreen({super.key, required this.recipe});
  final Recipe recipe;

  @override
  State<EditRecipeScreen> createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _ingredients;
  late final TextEditingController _imageUrl;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.recipe.title);
    _description = TextEditingController(text: widget.recipe.description);
    _ingredients = TextEditingController(
      text: widget.recipe.ingredients.join(', '),
    );
    _imageUrl = TextEditingController(text: widget.recipe.imageUrl);
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _ingredients.dispose();
    _imageUrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final updated = Recipe(
      id: widget.recipe.id,
      title: _title.text.trim(),
      description: _description.text.trim(),
      ingredients: _ingredients.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      imageUrl: _imageUrl.text.trim(),
      isFavorite: widget.recipe.isFavorite,
    );

    await Provider.of<RecipeProvider>(
      context,
      listen: false,
    ).updateRecipe(updated);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Receta actualizada con éxito!')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar receta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Título'),
                controller: _title,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Ingresa un título'
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Descripción'),
                controller: _description,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Ingresa una descripción'
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Ingredientes (separados por comas)',
                ),
                controller: _ingredients,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Ingresa ingredientes'
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'URL de la imagen',
                ),
                controller: _imageUrl,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Ingresa la URL de imagen'
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _save, child: const Text('Guardar')),
            ],
          ),
        ),
      ),
    );
  }
}
