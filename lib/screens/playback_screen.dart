import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/show_data.dart';
import '../models/set_data.dart';
import '../widgets/field_painter.dart';

class PlaybackScreen extends StatefulWidget {
  const PlaybackScreen({super.key});

  @override
  State<PlaybackScreen> createState() => _PlaybackScreenState();
}

class _PlaybackScreenState extends State<PlaybackScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int currentSetIndex = 0;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // time to move between sets
    )..addListener(() {
        setState(() {});
      });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        final show = context.read<ShowData>();
        if (currentSetIndex < show.sets.length - 1) {
          setState(() {
            currentSetIndex++;
          });
          _controller.reset();
          if (isPlaying) {
            _controller.forward();
          }
        } else {
          setState(() {
            isPlaying = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    final show = context.read<ShowData>();
    if (show.sets.length < 2) return;

    setState(() {
      isPlaying = !isPlaying;
    });

    if (isPlaying) {
      if (_controller.isCompleted || currentSetIndex >= show.sets.length - 1) {
        setState(() {
          currentSetIndex = 0;
        });
        _controller.reset();
      }
      _controller.forward();
    } else {
      _controller.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final show = context.watch<ShowData>();

    if (show.sets.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Play Show')),
        body: const Center(child: Text('No sets to play')),
      );
    }

    final currentSet = show.sets[currentSetIndex];
    final nextSet = currentSetIndex < show.sets.length - 1
        ? show.sets[currentSetIndex + 1]
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text('Playing: ${currentSet.name}'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomPaint(
              size: Size.infinite,
              painter: FieldPainter(
                currentSet: currentSet,
                nextSet: nextSet,
                progress: _controller.value,
                players: show.players,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Set ${currentSetIndex + 1} of ${show.sets.length}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 36,
                      icon: const Icon(Icons.skip_previous),
                      onPressed: () {
                        setState(() {
                          currentSetIndex = (currentSetIndex - 1).clamp(0, show.sets.length - 1);
                          _controller.reset();
                          isPlaying = false;
                        });
                      },
                    ),
                    const SizedBox(width: 16),
                    FloatingActionButton.large(
                      onPressed: _togglePlay,
                      backgroundColor: Colors.green.shade800,
                      child: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      iconSize: 36,
                      icon: const Icon(Icons.skip_next),
                      onPressed: () {
                        setState(() {
                          currentSetIndex = (currentSetIndex + 1).clamp(0, show.sets.length - 1);
                          _controller.reset();
                          isPlaying = false;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: show.sets.length <= 1
                      ? 0
                      : (currentSetIndex + _controller.value) / (show.sets.length - 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
