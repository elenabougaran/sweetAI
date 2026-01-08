import 'package:flutter/material.dart';

///Extrait la recette de la réponse de l'IA (il y a du texte en plus de la recette)
String extractRecipe(String fullText) {
  // Cherche "Préparation" ou "Instructions" et coupe avant
  final patterns = ["###"];
  for (var pattern in patterns) {
    final index = fullText.indexOf(pattern);
    if (index != -1) {
      return fullText.substring(index); // garde le texte à partir de ce mot
    }
  }
  // si aucun mot clé trouvé, retourne le texte entier
  return fullText;
}

/// Construit un widget à partir du texte renvoyé par l'IA :
/// - "### Titre" => gros titre
/// - "**gras**" => texte en gras (inline)
/// - "* item" => puce
Widget buildRecipeFormatted(String recipe) {
  final lines = recipe.split('\n');

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: lines
        .map((raw) => raw.trimRight())
        .where((line) => line.trim().isNotEmpty)
        .map((line) {
          // 1) Titres: ### ...
          if (line.startsWith('###')) {
            final title = line.replaceFirst('###', '').trim();
            return Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          }

          // 2) Puces: * ...
          if (line.startsWith('* ')) {
            final content = line.substring(2);
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('•  ', style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        children: _parseBold(content),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // 3) Ligne normale (avec gras possible)
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black),
                children: _parseBold(line),
              ),
            ),
          );
        })
        .toList(),
  );
}

/// Parse le gras **comme ça** (inline)
List<TextSpan> _parseBold(String text) {
  final spans = <TextSpan>[];
  final regex = RegExp(r'\*\*(.*?)\*\*'); // capture le contenu entre ** **
  int currentIndex = 0;

  for (final match in regex.allMatches(text)) {
    // Texte avant le gras
    if (match.start > currentIndex) {
      spans.add(TextSpan(text: text.substring(currentIndex, match.start)));
    }

    // Texte en gras
    final boldText = match.group(1) ?? '';
    spans.add(
      TextSpan(
        text: boldText,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );

    currentIndex = match.end;
  }

  // Texte restant après le dernier match
  if (currentIndex < text.length) {
    spans.add(TextSpan(text: text.substring(currentIndex)));
  }

  return spans;
}
