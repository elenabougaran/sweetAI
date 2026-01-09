import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';

class RecipeFirestoreRepository {
  final FirebaseFirestore firestore;

  RecipeFirestoreRepository(this.firestore);

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      firestore.collection("users").doc(uid).collection("recipes");

  Future<String> saveRecipe({
    required String uid,
    required Recipe recipe,
  }) async {
    final docRef = _col(uid).doc();
    await docRef.set(recipe.toMap(uid:uid));
    return docRef.id;
  }

  Stream<List<Recipe>> watchRecipes(String uid) {
    return _col(uid)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => Recipe.fromMap(d.id, d.data()))
              .toList(),
        );
  }

  Future<void> deleteRecipe({
    required String uid,
    required String recipeId,
  }) {
    return _col(uid).doc(recipeId).delete();
  }
}
