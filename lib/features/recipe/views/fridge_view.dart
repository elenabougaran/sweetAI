import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sweetai/features/recipe/viewmodels/fridgeviewmodel.dart';
import 'package:sweetai/models/ingredient.dart';
import 'package:sweetai/providers/recipe_providers.dart';
import 'package:sweetai/providers/ingredients_form_providers.dart';
import 'package:sweetai/utils/double_extensions.dart';
import 'package:sweetai/utils/recipe_text_formatter.dart';

class FridgeView extends ConsumerStatefulWidget {
  const FridgeView({super.key});

  @override
  ConsumerState<FridgeView> createState() => _FridgeViewState();
}

class _FridgeViewState extends ConsumerState<FridgeView> {
  final _nameController =
      TextEditingController(); //utiles pour que les textfields soient vidés après clic sur +
  final _quantityController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ingredients = ref.watch(fridgeViewModelProvider);
    final selectedUnit = ref.watch(unitProvider);

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
             Color(0xEEFFFFFF),
            BlendMode.dstATop)
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // IMPORTANT
        appBar: AppBar(
          title: const Text('Mon réfrigérateur'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          // Optionnel: pour que le titre/icone soit lisible selon l'image
          // foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// Formulaire
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(220),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: 'Ingrédient',
                              ),
                              controller: _nameController,
                              /*onChanged: (value) {
                        ref.read(nameProvider.notifier).state = value;
                      },*/
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: TextField(
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: const InputDecoration(
                                labelText: 'Qté',
                              ),
                              controller: _quantityController,
                              /*onChanged: (value) {
                        ref.read(quantityProvider.notifier).state = value;
                      },*/
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: DropdownButtonFormField<Unit>(
                                initialValue: selectedUnit,
                                isDense: true,
                                isExpanded: true,
                                onChanged: (unit) {
                                  if (unit != null) {
                                    ref.read(unitProvider.notifier).state =
                                        unit;
                                  }
                                },
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                                items: Unit.values
                                    .map(
                                      (unit) => DropdownMenuItem(
                                        value: unit,
                                        child: Text(unit.label),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                final name = _nameController.text.trim();
                                final quantity =
                                    double.tryParse(_quantityController.text) ??
                                    0;

                                if (name.isEmpty || quantity <= 0) return;

                                ref
                                    .read(fridgeViewModelProvider.notifier)
                                    .addIngredientFromInput(
                                      name: name,
                                      quantity: quantity,
                                      unit: selectedUnit,
                                    );
                                // Reset providers
                                //ref.read(nameProvider.notifier).state = '';
                                //ref.read(quantityProvider.notifier).state = '';
                                // Reset UI
                                _nameController.clear();
                                _quantityController.clear();
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// Liste des ingrédients
                ingredients.isEmpty
                    ? const Center(child: Text('Aucun ingrédient ajouté'))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(), //rend la liste non scrollable car la vue entière est scrollable elle meme
                        itemCount: ingredients.length,
                        itemBuilder: (context, index) {
                          final ingredient = ingredients[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              tileColor: Colors.white.withAlpha(230),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              title: Text(
                                '${ingredient.quantity.clean} ${ingredient.unit.label} de ${ingredient.name}',
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => ref
                                    .read(fridgeViewModelProvider.notifier)
                                    .deleteIngredient(ingredient),
                              ),
                            ),
                          );
                        },
                      ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                    onPressed:
                        (ingredients.isNotEmpty &&
                            ingredients.every((i) => i.quantity > 0.0))
                        ? () async {
                            print("Bouton cliqué");
                            await ref
                                .read(fridgeViewModelProvider.notifier)
                                .createRecipe();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Créer ma recette',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                ref
                    .watch(recipeStatusProvider)
                    .when(
                      loading: () => const CircularProgressIndicator(),
                      error: (error, _) => Text('Erreur : $error'),
                      data: (recipe) {
                        if (recipe.isEmpty) return const SizedBox.shrink();

                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(200),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: buildRecipeFormatted(recipe),
                          ),
                        );
                      },
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
