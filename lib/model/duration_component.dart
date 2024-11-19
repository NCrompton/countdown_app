class DurationComponent {
  final Duration duration;
  int get days => duration.inDays;
  int get hours => duration.inHours % 24;
  int get minutes => duration.inMinutes % 60;
  int get seconds => duration.inSeconds % 60;

  DurationComponent({required this.duration});
}