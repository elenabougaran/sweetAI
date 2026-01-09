import 'package:sweetai/repositories/recipe_repositories.dart';
import '../repositories/firestore_repository.dart';
import '../models/recipe.dart';
import 'dart:convert';

class RecipeService {
  final RecipeRepository repository;
  final RecipeFirestoreRepository firestoreRepository;

  RecipeService({required this.repository, required this.firestoreRepository});

  Future<Recipe> getRecipe(String ingredients) async {
    final prompt =
        """
Tu es un assistant de pâtisserie.
Réponds UNIQUEMENT avec un JSON valide, sans texte autour, sans ```.

Le JSON DOIT respecter exactement ce format :
{
  "title": "Titre court",
  "ingredients": ["ingrédient 1", "ingrédient 2"],
  "steps": ["étape 1", "étape 2"]
}

Contraintes :
- Écris en français
- 5 à 12 étapes max
- Ingrédients réalistes et cohérents

Ingrédients disponibles : $ingredients
""";

    final raw = await repository.generateRecipe(prompt);

    // Parse JSON -> Recipe
    final map = jsonDecode(raw) as Map<String, dynamic>;

    return Recipe(
      title: (map["title"] ?? "") as String,
      ingredients: List<String>.from(map["ingredients"] ?? const []),
      steps: List<String>.from(map["steps"] ?? const []),
    );
  }

  Future<Recipe> generateAndSaveRecipe({
    required String uid,
    required String ingredients,
  }) async {
    final recipe = await getRecipe(ingredients);
    await firestoreRepository.saveRecipe(uid: uid, recipe: recipe);
    return recipe;
  }

  Stream<List<Recipe>> watchUserRecipes({required String uid}) {
    return firestoreRepository.loadRecipes(uid: uid);
  }
}
