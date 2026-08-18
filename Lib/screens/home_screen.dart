import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/show_data.dart';
import 'players_screen.dart';
import 'editor_screen.dart';
import 'playback_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final show = context.watch<ShowData>();

    return Scaffold(
      appBar: AppBar(
        title: Text(show.showName),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(
            context,
            icon: Icons.people,
            title: 'Players',
            subtitle: '${show.players.length} members',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PlayersScreen()),
            ),
          ),
          _buildCard(
            context,
            icon: Icons.edit,
            title: 'Edit Drill',
            subtitle: '${show.sets.length} sets',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => EditorScreen()),
            ),
          ),
          _buildCard(
            context,
            icon: Icons.play_arrow,
            title: 'Play Show',
            subtitle: 'Watch the full animation',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PlaybackScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, size: 36, color: Colors.green.shade800),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
