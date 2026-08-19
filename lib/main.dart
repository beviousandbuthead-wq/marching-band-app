import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'models/show_data.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ShowData()..load(),
      child: const MarchingBandApp(),
    ),
  );
}

class MarchingBandApp extends StatelessWidget {
  const MarchingBandApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marching Band Drill',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade800),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
