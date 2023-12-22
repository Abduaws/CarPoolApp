import 'package:logger/logger.dart';

class LoggingPrinter extends LogPrinter{
  final String className;
  LoggingPrinter(this.className);

  @override
  List<String> log(LogEvent event) {
    var color = PrettyPrinter.defaultLevelColors[event.level];
    if(event.level == Level.debug){color = const AnsiColor.fg(40);} 
    if(event.level == Level.info){color = const AnsiColor.fg(11);} 
    var emoji = PrettyPrinter.defaultLevelEmojis[event.level];
    var message = event.message;
    return [color!('$emoji: $className: $message')];
  }
}

Logger getCustomLogger(Type className){
  return Logger(
    printer: LoggingPrinter(className.toString())
  );
}