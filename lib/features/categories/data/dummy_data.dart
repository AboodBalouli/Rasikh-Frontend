import 'package:flutter/material.dart';
import '../domain/entities/category.dart';

final List<Categrory> dummyCategories = [
  Categrory(id: 'c1', title: 'إلكترونيات', color: Colors.blue.toARGB32()),
  Categrory(id: 'c2', title: 'ملابس', color: Colors.purple.toARGB32()),
  Categrory(id: 'c3', title: 'أثاث', color: Colors.brown.toARGB32()),
  Categrory(id: 'c4', title: 'مطبخ', color: Colors.orange.toARGB32()),
  Categrory(id: 'c5', title: 'ألعاب', color: Colors.green.toARGB32()),
];

// This list is a small in-memory placeholder used by presentation
// widgets and providers during development. Replace with calls to the
// repository/data-source layer when wiring a backend.
