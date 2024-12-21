class Logger {

  static final Logger _logger = Logger._internal();

  Logger._internal();

  factory Logger() => _logger;

  void log(Object? s) => print(s);

  void e(Object? s) => print(s);
}