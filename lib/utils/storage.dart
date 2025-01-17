import 'dart:convert';

import 'package:calendar/model/countdown_data.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

const targetDateConfig = "targetDateConfig";
const dateListConfig = "dateListConfig";
const targetThreadConfig = "targetThreadConfig";

class LocalStorageManager {
  static LocalStorageManager? _manager; 
  final SharedPreferencesWithCache? _pref;

  LocalStorageManager._({required SharedPreferencesWithCache pref}) : _pref = pref;

  static Future<LocalStorageManager> instance() async {
    _manager = _manager ?? LocalStorageManager._(pref: await getPref());
    return _manager!;
  }

  static Future<SharedPreferencesWithCache> getPref() async{
    return await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        // When an allowlist is included, any keys that aren't included cannot be used.
        allowList: <String>{
          targetDateConfig, 
          dateListConfig,
          targetThreadConfig, 
        },
      ),
    );
  }

  Future<CountdownData?> getTargetDate() async{
    final String? targetDateString = _pref?.getString(targetDateConfig);
    if (targetDateString == null) return null;
    return CountdownData.fromJson(jsonDecode(targetDateString));
  }

  Future<List<CountdownData>?> getDateList() async {
    final List<String>? dateListString = _pref?.getStringList(dateListConfig);
    if (dateListString == null) return null;
    return dateListString.map((m) => CountdownData.fromJson(jsonDecode(m))).toList();
  }

  Id? getTargetBudgetThread() {
    return _pref?.getInt(targetThreadConfig); 
  }

  Future<void> setDateList(List<CountdownData> dateList) async {
    await _pref?.setStringList(dateListConfig, 
      dateList.map((e) => jsonEncode(e.toJson())).toList());
    _pref?.reloadCache();
  }

  Future<void> setTargetDate(CountdownData? targetDate) async {
    if (targetDate == null) return _pref?.remove(targetDateConfig);
    await _pref?.setString(targetDateConfig, jsonEncode(targetDate.toJson()));
    _pref?.reloadCache();
  }

  Future<void> setTargetBudgetThread(Id? id) async {
    if (id == null) return await _pref?.remove(targetThreadConfig);
    await _pref?.setInt(targetThreadConfig, id);
    _pref?.reloadCache();
  }
}

