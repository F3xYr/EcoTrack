import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';

class StreakService {
  final Box box = Hive.box('userStats');

  /// 🔥 ValueNotifier per aggiornare la UI in tempo reale
  static ValueNotifier<int> currentStreakNotifier = ValueNotifier<int>(0);

  StreakService() {
    // Inizializza con il valore già salvato
    int current = box.get('currentStreak', defaultValue: 0);
    currentStreakNotifier.value = current;
  }

  /// Aggiorna la streak giornaliera
  int updateStreak() {
    DateTime today = DateTime.now();
    String todayKey = _normalizeDate(today).toIso8601String();

    // Recupera ultimo accesso
    String? lastCheckInString = box.get('lastCheckInDate');
    DateTime? lastCheckIn =
        lastCheckInString != null ? DateTime.parse(lastCheckInString) : null;

    int currentStreak = box.get('currentStreak', defaultValue: 0);
    int bestStreak = box.get('bestStreak', defaultValue: 0);

    if (lastCheckIn == null) {
      // Primo giorno
      currentStreak = 1;
    } else {
      int diff = _normalizeDate(today).difference(_normalizeDate(lastCheckIn)).inDays;
      if (diff == 1) {
        // Giorno consecutivo
        currentStreak++;
      } else if (diff > 1) {
        // Saltato → reset streak
        currentStreak = 1;
      }
    }

    // Aggiorna record migliore
    if (currentStreak > bestStreak) {
      bestStreak = currentStreak;
      box.put('bestStreak', bestStreak);
    }

    // Salva valori aggiornati
    box.put('lastCheckInDate', todayKey);
    box.put('currentStreak', currentStreak);

    // 🔥 Aggiorna anche il ValueNotifier → la UI si aggiorna subito
    currentStreakNotifier.value = currentStreak;

    return currentStreak;
  }

  /// Ottieni streak attuale
  int getCurrentStreak() {
    return box.get('currentStreak', defaultValue: 0);
  }

  /// Ottieni miglior streak
  int getBestStreak() {
    return box.get('bestStreak', defaultValue: 0);
  }

  /// Normalizza la data (rimuove ore/minuti)
  DateTime _normalizeDate(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }
}
