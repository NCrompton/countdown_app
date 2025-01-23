import 'dart:convert';

import 'package:calendar/model/countdown_data.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

const targetDateConfig = "targetDateConfig";
const dateListConfig = "dateListConfig";
const targetThreadConfig = "targetThreadConfig";

class LocalStorageManager {
  static LocalStorageManager? _manager; 
  final SharedPreferencesAsync? _pref;

  LocalStorageManager._({required SharedPreferencesAsync pref}) : _pref = pref;

  static Future<LocalStorageManager> instance() async {
    _manager = _manager ?? LocalStorageManager._(pref: await getPref());
    return _manager!;
  }

  static Future<SharedPreferencesAsync> getPref() async{
    return SharedPreferencesAsync();
  }

  Future<CountdownData?> getTargetDate() async{
    final String? targetDateString = await _pref?.getString(targetDateConfig);
    if (targetDateString == null) return null;
    return CountdownData.fromJson(jsonDecode(targetDateString));
  }

  Future<List<CountdownData>?> getDateList() async {
    final List<String>? dateListString = await _pref?.getStringList(dateListConfig);
    if (dateListString == null) return null;
    return dateListString.map((m) => CountdownData.fromJson(jsonDecode(m))).toList();
  }

  Future<Id?> getTargetBudgetThread() async{
    return await _pref?.getInt(targetThreadConfig); 
  }

  Future<void> setDateList(List<CountdownData> dateList) async {
    await _pref?.setStringList(dateListConfig, 
      dateList.map((e) => jsonEncode(e.toJson())).toList());
  }

  Future<void> setTargetDate(CountdownData? targetDate) async {
    if (targetDate == null) return _pref?.remove(targetDateConfig);
    await _pref?.setString(targetDateConfig, jsonEncode(targetDate.toJson()));
  }

  Future<void> setTargetBudgetThread(Id? id) async {
    if (id == null) return await _pref?.remove(targetThreadConfig);
    await _pref?.setInt(targetThreadConfig, id);
  }
}

