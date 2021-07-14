import 'package:intl/intl.dart';

String localize(DateTime created) {
  final difference = DateTime.now().difference(created).inSeconds;

  // TODO: Add support for different locales.
  if (difference < 60) {
    return '${difference}s';
  } else if (difference < 60 * 60) {
    return '${difference ~/ 60}m';
  } else if (difference < 60 * 60 * 24) {
    return '${difference ~/ (60 * 60)}h';
  } else if (difference < 60 * 60 * 24 * 30) {
    return '${difference ~/ (60 * 60 * 24)}d';
  } else {
    return DateFormat.MMMd().format(created);
  }
}
