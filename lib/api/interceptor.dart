import 'package:calendar/utils/logger.dart';
import 'package:dio/dio.dart';

class LoggerInterceptor extends Interceptor {
  
  final logger = Log();

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    logger.e("[ERROR ON REQUEST] ${err.requestOptions.path} : ${err.message}");
    super.onError(err, handler);
  }
  
  @override
  void onResponse (Response response, ResponseInterceptorHandler handler) async {
    logger.log("Response[${response.statusCode}] => Path: ${response.requestOptions.path}");
    super.onResponse(response, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.log("Request[${options.method}] => Path: ${options.path}");
    super.onRequest(options, handler);
  }
}