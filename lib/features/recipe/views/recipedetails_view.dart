import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sweetai/providers/recipe_providers.dart';

class RecipeDetailView extends ConsumerWidget {
  final String recipeId;
  const RecipeDetailView({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeAsync = ref.watch(recipeByIdProvider(recipeId));

    return recipeAsync.when(
      loading: () => Scaffold(
        backgroundColor: const Color.fromARGB(255, 246, 237, 240),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 246, 237, 240),
          title: const Text("Chargement..."),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: const Color.fromARGB(255, 246, 237, 240),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 246, 237, 240),
          title: const Text("Erreur"),
        ),
        body: Center(child: Text("Erreur: $e")),
      ),
      data: (recipe) {
        if (recipe == null) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 246, 237, 240),
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 246, 237, 240),
              title: const Text("Recette introuvable"),
            ),
            body: const Center(child: Text("Recette introuvable.")),
          );
        }

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 246, 237, 240),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 246, 237, 240),
            title: Text(
              recipe.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
                  Text(
                    "🍚 Ingrédients",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              const SizedBox(height: 8),
              ...recipe.ingredients.map((i) => Text("• $i")),

              const SizedBox(height: 24),
              Text(
                "📋 Étapes",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...recipe.steps.asMap().entries.map(
                (e) => Text("${e.key + 1}. ${e.value}"),
              ),
            ],
          ),
        );
      },
    );
  }
}
