import 'package:sweetai/features/recipe/cubit/recipe_state.dart';
//import 'package:sweetai/features/recipe/services/service.dart';
import 'package:bloc/bloc.dart';


/*class RecipeCubit extends Cubit<RecipeState> {
  final AIRecipeService service;

  RecipeCubit(this.service) : super(RecipeInitial());

  Future<void> generateRecipe(List<String> ingredients) async {
    emit(RecipeLoading());

    try {
      final recipe = await service.generateRecipe(ingredients);
      emit(RecipeLoaded(recipe));
    } catch (e) {
      emit(RecipeError("Impossible de générer la recette"));
    }
  }
}*/

//pour ne pas dépendre d'une api pour l'instant
import 'package:sweetai/features/recipe/models/recipe.dart';

class RecipeCubit extends Cubit<RecipeState> {
  RecipeCubit() : super(RecipeInitial());

  Future<void> generateRecipe(List<String> ingredients) async {
    emit(RecipeLoading());

    // mock de génération de recette
    await Future.delayed(const Duration(seconds: 2));

    final recipe = Recipe(
      title: "Gâteau aux ${ingredients.join(', ')}",
      ingredients: ingredients,
      steps: [
        "Mélanger tous les ingrédients",
        "Verser dans un moule",
        "Cuire 30 min à 180°C",
        "Déguster"
      ],
    );

    emit(RecipeLoaded(recipe));
  }
}