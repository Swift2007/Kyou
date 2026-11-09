// Responsibility: Plain Dart model for a journal entry with fromJson/toJson.
class Entry {
  const Entry({
    required this.id,
    required this.userId,
    this.title,
    required this.body,
    this.mood,
    this.parentEntryId,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final String? title;
  final String body;
  final String? mood;
  final String? parentEntryId;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Entry.fromJson(Map<String, dynamic> json) => Entry(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    title: json['title'] as String?,
    body: json['body'] as String,
    mood: json['mood'] as String?,
    parentEntryId: json['parent_entry_id'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'title': title,
    'body': body,
    'mood': mood,
    'parent_entry_id': parentEntryId,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}

const entryMoods = ['great', 'good', 'okay', 'low', 'rough'];

String moodLabel(String mood) =>
    mood.isEmpty ? mood : mood[0].toUpperCase() + mood.substring(1);
