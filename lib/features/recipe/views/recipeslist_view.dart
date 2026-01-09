import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sweetai/models/recipe.dart';
import 'package:sweetai/providers/recipe_providers.dart'; // là où est recipesStreamProvider

class RecipesListView extends ConsumerWidget {
  const RecipesListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesAsync = ref.watch(recipesStreamProvider);

    return Scaffold(
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
                  // TODO: navigation vers la page de détail, avec la recette
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

