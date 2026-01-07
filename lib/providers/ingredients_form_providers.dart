import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sweetai/models/ingredient.dart';
//les StateProviders concernent l'UI, ils permettent de stocker les valeurs des textFields (comme @State en swiftUI)
// Texte du champ “nom de l’ingrédient”
//final nameProvider = StateProvider<String>((ref) => '');
// Texte du champ “quantité”
//final quantityProvider = StateProvider<String>((ref) => '');
// Unit sélectionnée dans le dropdown
final unitProvider = StateProvider<Unit>((ref) => Unit.piece);