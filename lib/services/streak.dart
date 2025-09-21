import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

class StreakService {
  final Box _box;
  static ValueNotifier<int> currentStreakNotifier = ValueNotifier<int>(0);

  StreakService() : _box = Hive.box('userStats') {
    // Delay init fino a fine build
    SchedulerBinding.instance.addPostFrameCallback((_) {
      int current = _box.get('currentStreak', defaultValue: 0);
      currentStreakNotifier.value = current;
    });
  }

  int updateStreak() {
    DateTime today = DateTime.now();
    String todayKey = _normalizeDate(today).toIso8601String();

    String? lastCheckInString = _box.get('lastCheckInDate');
    DateTime? lastCheckIn =
        lastCheckInString != null ? DateTime.parse(lastCheckInString) : null;

    int currentStreak = _box.get('currentStreak', defaultValue: 0);
    int bestStreak = _box.get('bestStreak', defaultValue: 0);

    if (lastCheckIn == null) {
      currentStreak = 1;
    } else {
      int diff = _normalizeDate(today).difference(_normalizeDate(lastCheckIn)).inDays;
      if (diff == 1) {
        currentStreak++;
      } else if (diff > 1) {
        currentStreak = 1;
      }
    }

    if (currentStreak > bestStreak) {
      bestStreak = currentStreak;
      _box.put('bestStreak', bestStreak);
    }

    _box.put('lastCheckInDate', todayKey);
    _box.put('currentStreak', currentStreak);

    // Qui notificare è sicuro, non è nel costruttore
    currentStreakNotifier.value = currentStreak;

    return currentStreak;
  }

  int getCurrentStreak() => _box.get('currentStreak', defaultValue: 0);
  int getBestStreak() => _box.get('bestStreak', defaultValue: 0);

  DateTime _normalizeDate(DateTime dt) => DateTime(dt.year, dt.month, dt.day);
}
