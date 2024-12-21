import 'package:logger/logger.dart';

class Log {
  static final Log _logger = Log._internal();
  final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2, // Number of method calls to be displayed
      errorMethodCount: 8, // Number of method calls if stacktrace is provided
      lineLength: 120, // Width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      // Should each log print contain a timestamp
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  Log._internal();

  factory Log() => _logger;

  void log(Object? s) => logger.t(s);

  void e(Object? s) => logger.e(s);

  void d(Object? s) => logger.d(s);
}