 pad(int n) {
  if (n >= 10) return "$n";
  return "0$n";
}

String format(Duration duration) {
  int hours = duration.inHours.remainder(24);
  int minutes = duration.inMinutes.remainder(60);
  int seconds = duration.inSeconds.remainder(60);

  if (duration.inHours > 0) {
    return '$hours:${pad(minutes)}:${pad(seconds)}';
  }

  return '$minutes:${pad(seconds)}';
}