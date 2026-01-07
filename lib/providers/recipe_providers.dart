import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sweetai/services/ai_recipe_service.dart';
import 'package:sweetai/repositories/recipe_repositories.dart';
import 'package:sweetai/core/network/http_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Provider pour stocker la recette générée
final recipeTextProvider = StateProvider<String>(
  (ref) => "",
); //stateprovider permet de mettre à jour l'UI quand la recette change

// Provider pour le status de l'appel API
final recipeStatusProvider = StateProvider<AsyncValue<String>>(
  (ref) => AsyncValue.data(""), //asyncValue permet une evolution de la valeur
);

final openRouterClientProvider = Provider<OpenRouterHttpClient>((ref) { //crée une instance de OpenRouterHttpClient dispo à plsrs endroits
  final apiKey = dotenv.env['OPENROUTER_API_KEY']!;
  return OpenRouterHttpClient(apiKey: apiKey);
});

final recipeRepositoryProvider = Provider<RecipeRepository>(
  //permet d'avoir une instance partagée du repo
  (ref) {
final client = ref.read(openRouterClientProvider);
final model = dotenv.env['OPENROUTER_MODEL'] ?? "allenai/olmo-3.1-32b-think:free";
return RecipeRepository(client: client, model: model);
  },
);

//equivaut à : let recipeService = RecipeService() en swiftUI
final recipeServiceProvider = Provider<RecipeService>(
  (ref) {
    //permet d'avoir une instance partagée du service
    final repository = ref.read(recipeRepositoryProvider);
    return RecipeService(repository: repository);
  },
); //provider crée une instance du service que l'on peut reutiliser à plusieurs endroits, donne accès à AsyncLoading(), AsyncData(""), AsyncError(error)

