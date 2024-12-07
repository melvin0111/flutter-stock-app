import 'package:flutter/material.dart';
import '../service/db_helper.dart';
import '../models/journel_model.dart';

// Inittialy TestScreen was to see if my database was working correctly, but I kept it as the journal screen
class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<JournalEntry> _notes = [];

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  // Grab all notes from the database
  Future<void> _fetchNotes() async {
    final data = await _dbHelper.fetchAllNotes();
    setState(() {
      _notes = data.map((e) => JournalEntry.fromMap(e)).toList();
    });
  }

  // Delete a note from the database
  Future<void> _deleteNote(int id) async {
    await _dbHelper.delete(id);
    _fetchNotes();
  }
  // Edit a note
  Future<void> _editNoteDialog(JournalEntry note) async {
    final TextEditingController _noteController = TextEditingController();
    _noteController.text = note.notes; 

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Note for ${note.stockName}'),
          content: TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              hintText: 'Update your note here...',
            ),
            maxLines: 4,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () async {
                final updatedNote = _noteController.text.trim();
                if (updatedNote.isNotEmpty) {
                  final updatedEntry = JournalEntry(
                    id: note.id,
                    stockName: note.stockName,
                    notes: updatedNote,
                    timestamp: DateTime.now().toIso8601String(),
                  );
                  await _dbHelper.update(note.id!, updatedEntry.toMap());
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Note has been updated successfully!!!')),
                  );
                  _fetchNotes();
                }
              },
              child: const Text('Save',
              style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Journal',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return Card(
                  child: ListTile(
                    title: Text(note.stockName),
                    subtitle: Text(note.notes),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // edit icon
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editNoteDialog(note),
                        ),
                        const SizedBox(width: 8),
                        // delete icon
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.grey),
                          onPressed: () => _deleteNote(note.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}