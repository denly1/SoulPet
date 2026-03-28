enum AppTimeOfDay { morning, day, evening, night }

enum Season { spring, summer, autumn, winter }

class TimeUtils {
  TimeUtils._();

  static AppTimeOfDay getCurrentTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) return AppTimeOfDay.morning;
    if (hour >= 12 && hour < 18) return AppTimeOfDay.day;
    if (hour >= 18 && hour < 22) return AppTimeOfDay.evening;
    return AppTimeOfDay.night;
  }

  static Season getCurrentSeason() {
    final month = DateTime.now().month;
    if (month >= 3 && month <= 5) return Season.spring;
    if (month >= 6 && month <= 8) return Season.summer;
    if (month >= 9 && month <= 11) return Season.autumn;
    return Season.winter;
  }

  static bool isNight() {
    final tod = getCurrentTimeOfDay();
    return tod == AppTimeOfDay.night;
  }

  static bool isDaytime() {
    final tod = getCurrentTimeOfDay();
    return tod == AppTimeOfDay.day || tod == AppTimeOfDay.morning;
  }

  static String getGreeting() {
    switch (getCurrentTimeOfDay()) {
      case AppTimeOfDay.morning:
        return 'Доброе утро';
      case AppTimeOfDay.day:
        return 'Добрый день';
      case AppTimeOfDay.evening:
        return 'Добрый вечер';
      case AppTimeOfDay.night:
        return 'Доброй ночи';
    }
  }

  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'только что';
    if (diff.inMinutes < 60) return '${diff.inMinutes} мин назад';
    if (diff.inHours < 24) return '${diff.inHours} ч назад';
    if (diff.inDays == 1) return 'вчера';
    return '${date.day}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
