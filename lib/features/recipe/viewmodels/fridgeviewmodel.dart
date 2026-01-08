import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sweetai/models/ingredient.dart';
import 'package:sweetai/services/ai_recipe_service.dart';
import 'package:sweetai/providers/recipe_providers.dart';
import 'package:sweetai/utils/recipe_text_formatter.dart';

final fridgeViewModelProvider =
    StateNotifierProvider<FridgeViewModel, List<Ingredient>>((ref) { //crée une instance de FridgeViewModel
      //ce provider est une liste d'ingrédients, et expose un stateNotifier qui a les méthodes pour modifier cette liste (addingredient et deleteingredient)
      final service = ref.read(
        recipeServiceProvider,
      ); //provider du VM maj quand le provider du service est maj
      return FridgeViewModel(service, ref);
    });



class FridgeViewModel extends StateNotifier<List<Ingredient>> {
  final RecipeService _service;
  final Ref _ref;

  FridgeViewModel(this._service, this._ref) : super([]);

  /// Ajoute un ingrédient
  void addIngredientFromInput({
    required String name,
    required double quantity,
    required Unit unit,
  }) {
    if (name.isEmpty || quantity <= 0) return;

    state = [
      //nelle liste -> riverpod détecte le changement = UI se rebuild
      ...state, //crée une nvelle liste en prenant les éléments actuels et en y ajoutant le nvel ingrédient à la fin
      Ingredient(name: name, quantity: quantity, unit: unit),
    ];
  }

  /// Supprime un ingrédient
  void deleteIngredient(Ingredient ingredient) {
    state = state.where((i) => i != ingredient).toList();
  }

  /// Fonction pour créer la recette
  Future<void> createRecipe() async {
    if (state.isEmpty) {
      _ref.read(recipeStatusProvider.notifier).state = AsyncValue.error(
        "Aucun ingrédient",
        StackTrace.current,
      );
      return;
    }

    /// Transforme la liste d'ingrédients en chaîne
    final ingredientsText = state
        .map((i) => "${i.quantity} ${i.unit.name} de ${i.name}")
        .join(", ");

    try {
      print("on est dans createRecipe");
      _ref.read(recipeStatusProvider.notifier).state =
          const AsyncValue.loading();
      final generated = await _service.getRecipe(ingredientsText);
      final recipeOnly = extractRecipe(generated);
      _ref.read(recipeTextProvider.notifier).state = recipeOnly;
      _ref.read(recipeStatusProvider.notifier).state = AsyncValue.data(
        recipeOnly,
      );
    } catch (e, st) {
      _ref.read(recipeStatusProvider.notifier).state = AsyncValue.error(
        e.toString(),
        st,
      );
    }
  }
}
