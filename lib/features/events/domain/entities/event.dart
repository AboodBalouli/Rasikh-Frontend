/// Domain entity for an Event.
class Event {
  final int id;
  final String name;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool published;
  final String? imageUrl;

  const Event({
    required this.id,
    required this.name,
    this.description,
    this.startDate,
    this.endDate,
    required this.published,
    this.imageUrl,
  });

  /// Whether the event is currently active (between start and end dates).
  bool get isActive {
    final now = DateTime.now();
    final start = startDate;
    final end = endDate;
    if (start == null || end == null) return false;
    return now.isAfter(start) && now.isBefore(end);
  }

  /// Whether the event has ended.
  bool get hasEnded {
    final end = endDate;
    if (end == null) return false;
    return DateTime.now().isAfter(end);
  }

  /// Whether the event is upcoming (hasn't started yet).
  bool get isUpcoming {
    final start = startDate;
    if (start == null) return false;
    return DateTime.now().isBefore(start);
  }
}
