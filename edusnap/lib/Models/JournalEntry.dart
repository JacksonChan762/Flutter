// ignore_for_file: file_names
import 'dart:math';

/// Immutable data only. Identity and creation time survive edits.
class JournalEntry {
  final String id;
  final String title;
  final String note;
  final DateTime createdAt;

  /// Absolute path of the photo on this device, if the entry has one.
  final String? photoPath;

  JournalEntry({
    String? id,
    required this.title,
    required this.note,
    required this.createdAt,
    this.photoPath,
  }) : id = id ?? _newId();

  static final _random = Random.secure();
  static String _newId() =>
      'entry-${List.generate(16, (_) => _random.nextInt(256).toRadixString(16).padLeft(2, '0')).join()}';

  JournalEntry copyWith({
    String? title,
    String? note,
    String? photoPath,
    bool clearPhoto = false,
  }) => JournalEntry(
    id: id,
    title: title ?? this.title,
    note: note ?? this.note,
    createdAt: createdAt,
    photoPath: clearPhoto ? null : (photoPath ?? this.photoPath),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'note': note,
    'createdAt': createdAt.toIso8601String(),
    'photoPath': photoPath,
  };

  /// Returns null for malformed records so one bad row cannot break the list.
  static JournalEntry? fromJson(Object? json) {
    if (json is! Map) return null;
    final id = json['id'];
    final title = json['title'];
    final note = json['note'];
    final createdAt = json['createdAt'];
    final photoPath = json['photoPath'];
    if (id is! String || title is! String || createdAt is! String) return null;
    final parsed = DateTime.tryParse(createdAt);
    if (parsed == null) return null;
    return JournalEntry(
      id: id,
      title: title,
      note: note is String ? note : '',
      createdAt: parsed,
      photoPath: photoPath is String && photoPath.isNotEmpty ? photoPath : null,
    );
  }
}
