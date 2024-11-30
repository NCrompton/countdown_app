import 'dart:convert';

import 'package:calendar/model/countdown_data.dart';
import 'package:calendar/utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageManager {
  static LocalStorageManager? _manager; 
  final SharedPreferencesWithCache? _pref;

  LocalStorageManager._({required SharedPreferencesWithCache pref}) : _pref = pref;

  
  static Future<LocalStorageManager> instance() async {
    return _manager ?? LocalStorageManager._(pref: await getPref());
  }

  static Future<SharedPreferencesWithCache> getPref() async{
    final cachePref = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        // When an allowlist is included, any keys that aren't included cannot be used.
        allowList: <String>{targetDateConfig, dateListConfig},
      ),
    );
    return cachePref;
  }

  Future<CountdownData?> getTargetDate() async{
    final String? targetDateString = _pref?.getString(targetDateConfig);
    CountdownData? targetDate;

    if (targetDateString != null) {
      targetDate = CountdownData.fromJson(jsonDecode(targetDateString));
    }
    return targetDate;
  }

  Future<List<CountdownData>?> getDateList() async {
    final List<String>? dateListString = _pref?.getStringList(dateListConfig);
    List<CountdownData>? dateList;
    if (dateListString != null) {
      dateList = dateListString.map((m) => CountdownData.fromJson(jsonDecode(m))).toList();
    }
    return dateList;
  }

  Future<void> setDateList(List<CountdownData> dateList) async {
    final dateListString = dateList.map((e) => jsonEncode(e.toJson())).toList();
    _pref?.setStringList(dateListConfig, dateListString);
  }

  Future<void> setTargetDate(CountdownData? targetDate) async {
    if (targetDate == null) return _pref?.remove(targetDateConfig);
    
    final targetDateString = jsonEncode(targetDate.toJson());
    _pref?.setString(targetDateConfig, targetDateString);
  }
}

