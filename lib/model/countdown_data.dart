import 'package:uuid/uuid.dart';

class CountdownData {
  final String id;
  final String name;
  DateTime _date;
  final Duration? interval;

  CountdownData({
    String? id,
    required this.name,
    required date,
    this.interval,
  }) : id = id ?? const Uuid().v4(), _date = date.toUtc();  // Generate UUID if not provided

  CountdownData copyWith({
    String? id,
    String? name,
    DateTime? date,
    Duration? interval,
  }) {
    return CountdownData(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      interval: interval ?? this.interval,
    );
  }
  
  DateTime get date { return _date.toLocal();}
  set date (DateTime d) { _date = d.toUtc(); }

  @override
  String toString() {
    return name;
  }

  // Optional: Add JSON serialization if needed
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'interval': interval?.inMilliseconds,
    };
  }

  factory CountdownData.fromJson(Map<String, dynamic> json) {
    return CountdownData(
      id: json['id'] as String,
      name: json['name'] as String,
      date: DateTime.parse(json['date'] as String),
      interval: json['interval'] != null 
          ? Duration(milliseconds: json['interval'] as int)
          : null,
    );
  }
}
