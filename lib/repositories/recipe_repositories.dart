import 'package:sweetai/core/network/http_client.dart';

class RecipeRepository {
  final OpenRouterHttpClient client;
  final String model;

// client optionnel, on crée un client par défaut si rien n'est fourni
  RecipeRepository({required this.client, required this.model});

  Future<String> generateRecipe(String prompt) async {
    final response = await client.post(model, prompt);

    // On récupère le texte généré dans 'choices[0].message.content'
    if (response['choices'] != null &&
        response['choices'].isNotEmpty &&
        response['choices'][0]['message'] != null &&
        response['choices'][0]['message']['content'] != null) {
      return response['choices'][0]['message']['content'];
    } else {
      throw Exception("Réponse API invalide");
    }
  }
}
