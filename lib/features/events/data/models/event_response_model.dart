/// DTO for event data from the backend API.
class EventResponseModel {
  final int id;
  final String name;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool published;
  final String? imageUrl;

  const EventResponseModel({
    required this.id,
    required this.name,
    this.description,
    this.startDate,
    this.endDate,
    required this.published,
    this.imageUrl,
  });

  factory EventResponseModel.fromJson(Map<String, dynamic> json) {
    return EventResponseModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?) ?? '',
      description: json['description'] as String?,
      startDate: _parseDateTime(json['startDate']),
      endDate: _parseDateTime(json['endDate']),
      published: (json['published'] as bool?) ?? false,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}
