class AgeResult {
  final int years;
  final int months;
  final int days;
  final int totalMonths;
  final int totalDays;

  const AgeResult({
    required this.years,
    required this.months,
    required this.days,
    required this.totalMonths,
    required this.totalDays,
  });

  static AgeResult? calculate(DateTime dob) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final dobDate = DateTime(dob.year, dob.month, dob.day);

    if (dobDate.isAfter(todayDate)) return null;

    int years = todayDate.year - dobDate.year;
    int months = todayDate.month - dobDate.month;
    int days = todayDate.day - dobDate.day;

    if (days < 0) {
      months -= 1;
      final prevMonth = DateTime(todayDate.year, todayDate.month, 0);
      days += prevMonth.day;
    }
    if (months < 0) {
      years -= 1;
      months += 12;
    }

    int totalMonths = (todayDate.year - dobDate.year) * 12 +
        (todayDate.month - dobDate.month);
    if (todayDate.day < dobDate.day) totalMonths -= 1;

    final totalDays = todayDate.difference(dobDate).inDays;

    return AgeResult(
      years: years,
      months: months,
      days: days,
      totalMonths: totalMonths,
      totalDays: totalDays,
    );
  }
}
