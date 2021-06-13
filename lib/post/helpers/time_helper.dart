class TimeHelper {
  static String readTimestamp(String timestamp) {
    var now = DateTime.now();
    var date = DateTime.parse(timestamp);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      if (diff.inHours > 0) {
        time = diff.inHours.toString() + ' giờ trước';
      } else if (diff.inMinutes > 0) {
        time = diff.inMinutes.toString() + ' phút trước';
      } else if (diff.inSeconds > 0) {
        time = 'Vừa xong';
      } else if (diff.inMilliseconds > 0) {
        time = 'Vừa xong';
      } else if (diff.inMicroseconds > 0) {
        time = 'Vừa xong';
      } else {
        time = 'Vừa xong';
      }
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      time = diff.inDays.toString() + ' ngày trước';
    } else if (diff.inDays > 6) {
      time = (diff.inDays / 7).floor().toString() + ' tuần trước';
    } else if (diff.inDays > 29) {
      time = (diff.inDays / 30).floor().toString() + ' tháng trước';
    } else if (diff.inDays > 365) {
      time = '${date.month} ${date.day}, ${date.year}';
    }
    return time;
  }
}
