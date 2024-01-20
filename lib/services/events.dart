import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String? description;
  final DateTime date;

  Event({
    required this.id,
    required this.title,
    this.description,
    required this.date,
  });

  factory Event.fromFirestore(QueryDocumentSnapshot<Object?> doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      title: data['title'] as String,
      description: data['description'] as String?,
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      "title": title,
      "description": description,
      "date": date,
    };
  }
}