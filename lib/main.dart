import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas/providers/recipe_provider.dart';
import 'package:recetas/screens/recipes_list_screen.dart';
import 'package:recetas/themes/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final recipeProvider = RecipeProvider();
  await recipeProvider.loadRecipes();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider.value(value: recipeProvider)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recetas de Cocina',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const RecipesListScreen(),
    );
  }
}