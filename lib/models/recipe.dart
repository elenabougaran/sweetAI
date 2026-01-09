import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String id; //Firestore docId
  final String title;
  final List<String> ingredients;
  final List<String> steps;
  final DateTime createdAt;

  Recipe({
    this.id = "",
    required this.title,
    required this.ingredients,
    required this.steps,
    DateTime? createdAt
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap({required String uid}) => {
        "title": title,
        "ingredients": ingredients,
        "steps": steps,
        "createdAt": FieldValue.serverTimestamp(),
        "userId": uid,
      };

//Firestore ne stocke pas directement des objets Dart donc mapping
  factory Recipe.fromMap(String id, Map<String, dynamic> map) {
    final ts = map["createdAt"] as Timestamp?;
    return Recipe(
      id: id,
      title: (map["title"] ?? "") as String,
      ingredients: List<String>.from(map["ingredients"] ?? const []),
      steps: List<String>.from(map["steps"] ?? const []),
      createdAt: ts?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}