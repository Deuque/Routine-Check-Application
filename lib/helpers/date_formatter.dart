import 'package:intl/intl.dart';

String formattedDate(DateTime time) {
  final now = DateTime.now();

  final isYesterday = DateFormat.yMMMd().format(time) ==
      DateFormat.yMMMd().format(now.subtract(const Duration(days: 1)));
  if (isYesterday) return 'Yesterday';
  final isToday =
      DateFormat.yMMMd().format(time) == DateFormat.yMMMd().format(now);
  if (isToday) return 'Today';
  final isTomorrow = DateFormat.yMMMd().format(time) ==
      DateFormat.yMMMd().format(now.add(const Duration(days: 1)));
  if (isTomorrow) return 'Tomorrow';

  return DateFormat.yMMMd().format(time);
}

String formattedTimeDifference(DateTime time) {
  final now = DateTime.now();
  final difference = time.difference(now);

  if (difference.inDays > 0) {
    return '${difference.inDays} days';
  }

  if (difference.inHours > 0) {
    return '${difference.inHours} hours';
  }

  if (difference.inMinutes > 0) {
    return '${difference.inMinutes} minutes';
  }

  return '${difference.inSeconds} seconds';
}
