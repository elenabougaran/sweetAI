import 'package:sweetai/features/recipe/models/recipe.dart';

abstract class RecipeState {}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final Recipe recipe;
  RecipeLoaded(this.recipe);
}

class RecipeError extends RecipeState {
  final String message;
  RecipeError(this.message);
}
