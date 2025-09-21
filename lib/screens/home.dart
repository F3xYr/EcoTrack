import 'package:flutter/material.dart';
import 'scanner.dart';
import 'history.dart';
import '../services/streak.dart';

final streakService = StreakService();
int streak = streakService.getCurrentStreak();

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoTrack'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Color(0xFF2E7D32)),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => HistoryScreen()),
            ),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // COUNTER STREAK REATTIVO
              ValueListenableBuilder<int>(
                valueListenable: StreakService.currentStreakNotifier,
                builder: (context, streak, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.local_fire_department, color: Colors.orange, size: 32),
                      const SizedBox(width: 8),
                      Text(
                        'Streak: $streak giorni',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                },
              ),


              const SizedBox(height: 16),
              const Text(
                'Inquadra uno scontrino o un codice a barre',
                style: TextStyle(fontSize: 18, color: Color(0xFF586776)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3BAE60),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 16),
                ),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Scansiona'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ScannerScreen()),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
