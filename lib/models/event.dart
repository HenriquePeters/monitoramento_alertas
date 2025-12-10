class Event {
  final int id;
  final String type;
  final String source;
  final DateTime timestamp;
  final DateTime? processedAt;

  Event({
    required this.id,
    required this.type,
    required this.source,
    required this.timestamp,
    this.processedAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'type': type,
    'source': source,
    'timestamp': timestamp.toIso8601String(),
    'processedAt': processedAt?.toIso8601String(),
  };

  factory Event.fromMap(Map<String, dynamic> m) => Event(
    id: m['id'] as int,
    type: m['type'] as String,
    source: m['source'] as String,
    timestamp: DateTime.parse(m['timestamp'] as String),
    processedAt: m['processedAt'] != null ? DateTime.parse(m['processedAt'] as String) : null,
  );
}
