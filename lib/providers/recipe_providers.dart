import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sweetai/services/ai_recipe_service.dart';
import 'package:sweetai/repositories/recipe_repositories.dart';
import 'package:sweetai/core/network/http_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../repositories/firestore_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';
import '../providers/auth_providers.dart';

// Provider pour stocker la recette générée
final recipeProvider = StateProvider<Recipe?>((ref) => null);
 //stateprovider permet de mettre à jour l'UI quand la recette change

// Provider pour le status de l'appel API
final recipeStatusProvider = StateProvider<AsyncValue<Recipe?>>(
  (ref) => const AsyncValue.data(null),
); //asyncValue permet une evolution de la valeur

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

final recipeFirestoreRepositoryProvider = Provider(
  (ref) => RecipeFirestoreRepository(FirebaseFirestore.instance),
);

//equivaut à : let recipeService = RecipeService() en swiftUI
final recipeServiceProvider = Provider<RecipeService>(
  (ref) {
    //permet d'avoir une instance partagée du service
    final repository = ref.read(recipeRepositoryProvider);
    return RecipeService(repository: repository, firestoreRepository: ref.read(recipeFirestoreRepositoryProvider));
  },
); //provider crée une instance du service que l'on peut reutiliser à plusieurs endroits, donne accès à AsyncLoading(), AsyncData(""), AsyncError(error)

//permet a la liste des recettes de suivre les changements des recettes dans firestore
final recipesStreamProvider =
    StreamProvider.autoDispose<List<Recipe>>((ref) {
  final user = ref.watch(currentUserProvider);
  final service = ref.watch(recipeServiceProvider);

  if (user == null) {
    return const Stream.empty();
  }

  return service.watchUserRecipes(uid: user.uid);
});
