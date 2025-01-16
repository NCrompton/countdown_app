import 'package:calendar/services/budget_service.dart';
import 'package:calendar/services/exchange_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'total_price_provider.g.dart';

@riverpod
class TotalPrice extends _$TotalPrice{
  @override
  Future<double> build(int threadId) async {
    final prices = await ref.read(budgetServiceProvider.future).then((db) => 
      db.getAllPrice(threadId));
    final service = await ref.watch(exchangeServiceProvider.future);
    if (prices == null) return 0;
    double total = 0;
    for (var p in prices) {
      total += service.getExchangedPrice(p);
    }
    return total;
  }
}