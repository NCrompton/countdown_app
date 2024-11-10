import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'date_provider.g.dart';

@riverpod
class DateNotifier extends _$DateNotifier {
  @override
  DateTime? build() {
    return null; // Initial state is null
  }

  void setTargetDate(DateTime date) {
    state = date;
  }
} 