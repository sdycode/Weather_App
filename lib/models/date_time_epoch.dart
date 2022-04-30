class EpochDateTime {
  int timestamp;
  int year;
  int day;
  int hour;
  int minute;
  late DateTime dateTime;

  EpochDateTime(
    this.timestamp, {
    this.year = 2000,
    this.day = 1,
    this.hour = 10,
    this.minute = 10,
  }) {
    dateTime = DateTime.now();
    getTimeData();
  }

  void getTimeData() {
     dateTime = DateTime.fromMicrosecondsSinceEpoch(DateTime.now().toUtc().microsecondsSinceEpoch-timestamp,  isUtc: false);
  //  DateTime.
    year = dateTime.year;
    day = dateTime.day;
    hour = dateTime.hour;
    minute = dateTime.minute;
    // dateTime =  DateTime.fromMillisecondsSinceEpoch(timestamp);
  }
}
