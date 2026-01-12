import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sweetai/models/recipe.dart';
import 'package:sweetai/providers/recipe_providers.dart'; // là où est recipesStreamProvider
import 'package:sweetai/features/recipe/views/recipedetails_view.dart';

class RecipesListView extends ConsumerWidget {
  const RecipesListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesAsync = ref.watch(recipesStreamProvider);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 237, 240),
      body: recipesAsync.when(
        data: (recipes) {
          if (recipes.isEmpty) {
            return const Center(
              child: Text("Aucune recette pour l’instant."),
            );
          }

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final Recipe recette = recipes[index];
              return ListTile(
                title: Text(recette.title),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => RecipeDetailView(recipeId: recette.id))
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (err, stack) => Center(
          child: Text('Erreur : $err'),
        ),
      ),
    );
  }
}

