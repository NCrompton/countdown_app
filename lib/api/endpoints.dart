import 'package:calendar/utils/const.dart';

class Endpoints {
  static const Duration receiveTimeout = Duration(seconds: 5);
  static const Duration connectionTimeout = Duration(seconds: 3);

  static const String exchangeBaseUrl = "https://open.er-api.com/v6/";
  static const String exchangeInDefaultCur = "latest/$defaultCurrency";
}