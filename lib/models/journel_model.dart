class JournalEntry {
  final int? id;
  final String stockName;
  final String notes;
  final String timestamp;

  JournalEntry({
    this.id,
    required this.stockName,
    required this.notes,
    required this.timestamp,
  });

  // Converts a entry object into a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'stockName': stockName,
      'notes': notes,
      'timestamp': timestamp,
    };
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'],
      stockName: map['stockName'],
      notes: map['notes'],
      timestamp: map['timestamp'],
    );
  }
}
