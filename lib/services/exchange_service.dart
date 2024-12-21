import 'package:calendar/api/endpoints.dart';
import 'package:calendar/api/interceptor.dart';
import 'package:calendar/model/budget_schema.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'exchange_service.g.dart';

typedef ExchangeModel = Map<Currency, double>;

@Riverpod(keepAlive: true)
class ExchangeService extends _$ExchangeService {

  final _dio = Dio(
    BaseOptions(
      baseUrl: Endpoints.exchangeBaseUrl,
      connectTimeout: Endpoints.connectionTimeout,
      receiveTimeout: Endpoints.receiveTimeout,
    )
  )..interceptors.add(LoggerInterceptor());

  Future<ExchangeModel> _fetchExchangeRate() async {
    ExchangeModel model = {};
    final res = await _dio.get(
      Endpoints.exchangeInDefaultCur,
    );

    Map<String, dynamic>? exchangeList = res.data['rates'] as Map<String, dynamic>;
    for (final c in Currency.values) {
      if (exchangeList.containsKey(c.name.toUpperCase())) {
        model[c] = exchangeList[c.name.toUpperCase()] / 1;
      }
    }
    return model;
  }

  @override
  Future<ExchangeModel> build() async {
    return _fetchExchangeRate();
  }

  double getExchangedPrice(LocalizedPrice price) {
    final exchangeRate = state.value;
    if (exchangeRate == null) return 0;

    return price.value / exchangeRate[price.currency]! ; 
  }
}