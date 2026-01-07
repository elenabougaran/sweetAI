// lib/network/http_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenRouterHttpClient {
  final String apiKey;

  // apiKey optionnelle, valeur par défaut si rien n'est passé
  OpenRouterHttpClient({String? apiKey})
      : apiKey = apiKey ?? dotenv.env['OPENROUTER_API_KEY']!; // clé par défaut

  Future<Map<String, dynamic>> post(String model, String prompt, {int maxTokens = 1500}) async {
    final url = Uri.parse("https://openrouter.ai/api/v1/chat/completions");
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $apiKey",
    };

    final body = jsonEncode({
      "model": model,
      "messages": [
        {"role": "user", "content": prompt}
      ],
      "max_tokens": maxTokens
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur API : ${response.statusCode} - ${response.body}");
    }
  }
}
