import 'package:logger/logger.dart';

class LoggingWrapper {
  static void print(
    String message, {
    String name = 'Dental App',
    bool isError = false,
  }) {
    final logger = Logger(
      filter: DentalAppFilter(),
      printer: DentalAppPrinter(name: name),
      output: null,
    );
    if (isError)
      logger.e(message);
    else
      logger.i(message);
  }
}

class DentalAppPrinter extends LogPrinter {
  static final levelColors = {
    Level.verbose: AnsiColor.fg(AnsiColor.grey(0.5)),
    Level.debug: AnsiColor.none(),
    Level.info: AnsiColor.fg(3),
    Level.warning: AnsiColor.fg(208),
    Level.error: AnsiColor.fg(196),
    Level.wtf: AnsiColor.fg(199),
  };

  final String name;

  DentalAppPrinter({required this.name});

  @override
  List<String> log(LogEvent event) {
    var color = levelColors[event.level];
    String prefix = '[$name] ';
    String content = prefix + event.message;

    var coloredContent = color!(content);

    return [coloredContent];
  }
}

class DentalAppFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) => true;
}
