class CountdownData {
  final DateTime date;
  String emoji = "";
  int counter = 3;
  Duration? interval;

  CountdownData({required this.date, required this.counter, this.interval}) {
    this.emoji = "asd";
    this.interval = DateTime.utc(2024, 8, 16, 9).difference(DateTime.now());
    // this.counter = 2;
  }
}
