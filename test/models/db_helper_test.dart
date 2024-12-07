import 'package:flutter_test/flutter_test.dart';
import 'package:cs442_mp6/service/db_helper.dart';
import 'package:cs442_mp6/models/journel_model.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';


void main() {
  late DBHelper dbHelper;

  setUpAll(() {
    // Initialize sqflite with ffi
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    dbHelper = DBHelper();
  });

  group('db_helper tests', () { 
    test('Inserts a note successfully', () async { // Insert note
      final entry = JournalEntry(
        stockName: 'AAPL',
        notes: 'Test note for Apple stock',
        timestamp: DateTime.now().toIso8601String(),
      );

      final id = await dbHelper.insert(entry.toMap());

      expect(id, isNotNull);
    });

    test('Fetches all notes successfully', () async { // Fetch all notes
      final entry1 = JournalEntry(
        stockName: 'AAPL',
        notes: 'Test note 1',
        timestamp: DateTime.now().toIso8601String(),
      );
      final entry2 = JournalEntry(
        stockName: 'GOOG',
        notes: 'Test note 2',
        timestamp: DateTime.now().toIso8601String(),
      );
      await dbHelper.insert(entry1.toMap());
      await dbHelper.insert(entry2.toMap());

      final id1 = await dbHelper.insert(entry1.toMap());
      final id2 = await dbHelper.insert(entry2.toMap());

      final notes = await dbHelper.fetchAllNotes();

      final note1 = notes.firstWhere((note) => note['id'] == id1);
      final note2 = notes.firstWhere((note) => note['id'] == id2);

      expect(note1['stockName'], 'AAPL');
      expect(note1['notes'], 'Test note 1');

      expect(note2['stockName'], 'GOOG');
      expect(note2['notes'], 'Test note 2');
    });

    test('Deletes a note successfully', () async { // Delete a note (this is failing)
      final entry = JournalEntry(
        stockName: 'AAPL',
        notes: 'Test note to delete',
        timestamp: DateTime.now().toIso8601String(),
      );
      final id = await dbHelper.insert(entry.toMap());

      final deleteCount = await dbHelper.delete(id);

      expect(deleteCount, 1);
      final notes = await dbHelper.fetchAllNotes();

      final noteExists = notes.any((note) => note['id'] == id);
      expect(noteExists, false);
    });

    test('Updates a note successfully', () async {  // Update a note
      final entry = JournalEntry(
        stockName: 'AAPL',
        notes: 'Original note',
        timestamp: DateTime.now().toIso8601String(),
      );
      final id = await dbHelper.insert(entry.toMap());

      final updatedEntry = JournalEntry(
        id: id,
        stockName: 'AAPL',
        notes: 'Updated note',
        timestamp: DateTime.now().toIso8601String(),
      );

      await dbHelper.update(id, updatedEntry.toMap());

      final notes = await dbHelper.fetchAllNotes();
      expect(notes[0]['notes'], 'Updated note');
    });
  });
}
