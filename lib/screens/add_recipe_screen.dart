import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas/models/recipe.dart';
import 'package:recetas/providers/recipe_provider.dart';
import 'package:uuid/uuid.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _ingredientsController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final ingredients = _ingredientsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final newRecipe = Recipe(
      id: const Uuid().v4(),
      title: _titleController.text.trim(),
      ingredients: ingredients,
      description: _descriptionController.text.trim(),
      imageUrl: _imageUrlController.text.trim(),
    );

    await Provider.of<RecipeProvider>(
      context,
      listen: false,
    ).addRecipe(newRecipe);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Receta agregada exitosamente!')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Receta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título de la Receta',
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Por favor ingresa un título'
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _ingredientsController,
                decoration: const InputDecoration(
                  labelText: 'Ingredientes (separados por comas)',
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Por favor ingresa los ingredientes'
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Por favor ingresa una descripción'
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL de la imagen',
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Por favor ingresa una URL de imagen'
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Agregar Receta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
