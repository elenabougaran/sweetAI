import 'package:sweetai/repositories/recipe_repositories.dart';

class RecipeService {
   final RecipeRepository repository;

 RecipeService({required this.repository});
      
  Future<String> getRecipe(String ingredients) async {
    final prompt = "Écris une recette avec ces ingrédients : $ingredients";
    return await repository.generateRecipe(prompt);
  }
}