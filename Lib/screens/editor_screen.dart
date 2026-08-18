import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/show_data.dart';
import '../models/set_data.dart';
import '../widgets/field_painter.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  String? selectedSetId;
  String? selectedPlayerId;

  @override
  void initState() {
    super.initState();
    final show = context.read<ShowData>();
    if (show.sets.isNotEmpty) {
      selectedSetId = show.sets.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final show = context.watch<ShowData>();

    if (show.sets.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Drill')),
        body: const Center(child: Text('No sets yet')),
      );
    }

    selectedSetId ??= show.sets.first.id;
    final currentSet = show.sets.firstWhere((s) => s.id == selectedSetId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Drill'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Set',
            onPressed: () {
              final name = 'Set ${show.sets.length + 1}';
              show.addSet(name);
              setState(() {
                selectedSetId = show.sets.last.id;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Set selector
          SizedBox(
            height: 56,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              itemCount: show.sets.length,
              itemBuilder: (context, index) {
                final set = show.sets[index];
                final isSelected = set.id == selectedSetId;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(set.name),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() => selectedSetId = set.id);
                    },
                  ),
                );
              },
            ),
          ),

          // Field
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onTapDown: (details) {
                    if (selectedPlayerId == null) return;

                    final size = Size(constraints.maxWidth, constraints.maxHeight);
                    final fieldWidth = size.width * 0.92;
                    final fieldHeight = size.height * 0.85;
                    final left = (size.width - fieldWidth) / 2;
                    final top = (size.height - fieldHeight) / 2;

                    final local = details.localPosition;

                    // Convert screen → field coordinates
                    final dx = ((local.dx - left) / fieldWidth) * 100 - 50;
                    final dy = (1 - ((local.dy - top) / fieldHeight)) * 53.333;

                    // Clamp
                    final clamped = Offset(
                      dx.clamp(-50.0, 50.0),
                      dy.clamp(0.0, 53.333),
                    );

                    show.updatePosition(selectedSetId!, selectedPlayerId!, clamped);
                  },
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: FieldPainter(
                      currentSet: currentSet,
                      players: show.players,
                      selectedPlayerId: selectedPlayerId,
                    ),
                  ),
                );
              },
            ),
          ),

          // Player selector
          Container(
            height: 90,
            color: Colors.grey.shade100,
            child: show.players.isEmpty
                ? const Center(child: Text('Add players first'))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(8),
                    itemCount: show.players.length,
                    itemBuilder: (context, index) {
                      final p = show.players[index];
                      final isSelected = p.id == selectedPlayerId;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          avatar: CircleAvatar(
                            backgroundColor: p.color,
                            radius: 12,
                            child: Text(
                              '${p.number}',
                              style: const TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ),
                          label: Text(p.name),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() {
                              selectedPlayerId = isSelected ? null : p.id;
                            });
                          },
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
