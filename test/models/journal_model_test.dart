import 'package:flutter_test/flutter_test.dart';
import 'package:cs442_mp6/models/journel_model.dart';

void main() {
  group('JournalEntry Model', () {
    test('Converts from Map correctly', () { // check if entry is converted from map correctly
      final map = {
        'id': 1,
        'stockName': 'AAPL',
        'notes': 'Test note for Apple stock.',
        'timestamp': '2024-12-06T16:14:39.215378',
      };
      final journalEntry = JournalEntry.fromMap(map);

      expect(journalEntry.id, 1);
      expect(journalEntry.stockName, 'AAPL');
      expect(journalEntry.notes, 'Test note for Apple stock.');
      expect(journalEntry.timestamp, '2024-12-06T16:14:39.215378');
    });

    test('Converts to Map correctly', () { // checks if entry is converted to map correctly
      final journalEntry = JournalEntry(
        id: 1,
        stockName: 'AAPL',
        notes: 'Test note for Apple stock.',
        timestamp: '2024-12-06T16:14:39.215378',
      );
      final map = journalEntry.toMap();

      expect(map['id'], 1);
      expect(map['stockName'], 'AAPL');
      expect(map['notes'], 'Test note for Apple stock.');
      expect(map['timestamp'], '2024-12-06T16:14:39.215378');
    });
  });
}
