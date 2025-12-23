import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/recipe_cubit.dart';
import '../cubit/recipe_state.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({super.key});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipeCubit = context.read<RecipeCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text("SweetAI - Recettes")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input ingrédients + bouton
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Entrez vos ingrédients séparés par des virgules",
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      final ingredients = _controller.text
                          .split(',')
                          .map((e) => e.trim())
                          .toList();
                      recipeCubit.generateRecipe(ingredients);
                      _controller.clear();
                    }
                  },
                  child: const Text("Générer"),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // BlocBuilder pour gérer les états
            Expanded(
              child: BlocBuilder<RecipeCubit, RecipeState>(
                builder: (context, state) {
                  if (state is RecipeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is RecipeLoaded) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.recipe.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Ingrédients :",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          ...state.recipe.ingredients
                              .map((i) => Text("- $i"))
                              .toList(),
                          const SizedBox(height: 12),
                          const Text(
                            "Étapes :",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          ...state.recipe.steps
                              .asMap()
                              .entries
                              .map((e) => Text("${e.key + 1}. ${e.value}"))
                              .toList(),
                        ],
                      ),
                    );
                  } else if (state is RecipeError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text(
                        "Entrez vos ingrédients et appuyez sur Générer",
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
