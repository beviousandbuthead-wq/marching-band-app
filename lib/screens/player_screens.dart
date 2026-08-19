import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/show_data.dart';

class PlayersScreen extends StatelessWidget {
  const PlayersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final show = context.watch<ShowData>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Players'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: show.players.length,
        itemBuilder: (context, index) {
          final p = show.players[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: p.color,
              child: Text(
                '${p.number}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(p.name),
            subtitle: Text(p.section),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => show.removePlayer(p.id),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final nameController = TextEditingController();
    final numberController = TextEditingController();
    String section = 'Brass';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Player'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: numberController,
              decoration: const InputDecoration(labelText: 'Number'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              value: section,
              items: ['Woodwind', 'Brass', 'Battery', 'Front Ensemble', 'Guard']
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => section = v!,
              decoration: const InputDecoration(labelText: 'Section'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                context.read<ShowData>().addPlayer(
                      name,
                      section: section,
                      number: int.tryParse(numberController.text) ?? 0,
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
