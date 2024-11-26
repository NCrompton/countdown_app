import 'package:calendar/model/countdown_data.dart';
import 'package:calendar/utils/const.dart';
import 'package:calendar/utils/storage.dart';
import 'package:calendar/utils/widget.dart';
import 'package:home_widget/home_widget.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:collection/collection.dart'; 

part 'date_provider.g.dart';

/// State class to hold both target date and date list
class DateState {
  final CountdownData? targetDate;
  final List<CountdownData> dateList;

  const DateState({
    this.targetDate,
    this.dateList = const [],
  });

  DateState copyWith({
    CountdownData? targetDate,
    List<CountdownData>? dateList,
  }) {
    return DateState(
      targetDate: targetDate ?? this.targetDate,
      dateList: dateList ?? this.dateList,
    );
  }
}

@riverpod
class AsyncDateState extends _$AsyncDateState {

  LocalStorageManager? manager;
  NativeWidgetManager nativeWidgetManager = NativeWidgetManager();

  AsyncDateState() {
    print("initiating manager");
    LocalStorageManager.instance().then((v) {
      manager = v;
      print("done initiating manager");
    });
  }



  Future<CountdownData?> _fetchTargetDate() async {
    final targetDate = await manager?.getTargetDate();
    return targetDate;
  }

  Future<List<CountdownData>> _fetchDateList() async {
    final dateList = await manager?.getDateList();
    return dateList ?? [];
  }

  Future<DateState> _fetchAll() async {
    final dateList = await _fetchDateList();
    final targetDate = await _fetchTargetDate();
    return DateState(dateList: dateList, targetDate: targetDate);
  }

  @override
  FutureOr<DateState> build() async { 
    manager = await LocalStorageManager.instance();
    final dateList = await _fetchDateList();
    final targetDate = await _fetchTargetDate();
    return DateState(targetDate: targetDate, dateList: dateList);
  }
  
  Future<CountdownData?> getTargetDate() async {
    final targetDate = await _fetchTargetDate();
    return targetDate;
  }

  Future<bool> setTargetDate(String targetDateId) async{
    final targetDate = await getDateById(targetDateId);
    if (targetDate == null) return false; 

    manager?.setTargetDate(targetDate);

    nativeWidgetManager.updateWidget(targetDate.date, targetDate.toString());

    final data = await _fetchAll();
    state = AsyncValue.data(data);
    return true;
  }

  Future<void> removeTargetDate() async {
    manager?.setTargetDate(null);

    nativeWidgetManager.resetWidget();
  }

  Future<void> addDate(CountdownData data) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final dateList = await _fetchDateList();
      final updatedList = [...dateList, data];
      manager?.setDateList(updatedList);
      return _fetchAll();
    });
  }

  Future<bool> removeDate(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final dateList = await _fetchDateList();
      final targetDate = await _fetchTargetDate();

      if (targetDate?.id == id) removeTargetDate();

      final updatedList = [...dateList]..removeWhere(
        (d) => d.id == id
      );
      manager?.setDateList(updatedList);
      return _fetchAll();
    });
    return true;
  }

  void clearDates() async {
    state = const AsyncLoading();
    manager?.setDateList([]);
    final data = await _fetchAll();
    state = AsyncValue.data(data);
  }

  void updateDate(String id, CountdownData newDate) async {
    final dateList = await _fetchDateList();
    final index = dateList.indexWhere((d) => d.id == id);
    
    if (index != -1) {
      final updatedList = [...dateList];
      updatedList[index] = newDate;
      manager?.setDateList(updatedList);
      final data = await _fetchAll();
      state = AsyncData(data);
    }
  }

  Future<CountdownData?> getDateById(String id) async {
    final dateList = await _fetchDateList();
    final updatedList = dateList.firstWhereOrNull(
      (d) => d.id == id,
    );
    return updatedList;
  }
}