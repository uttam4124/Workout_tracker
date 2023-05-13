// return todays date as yyyymmdd
String todaysDateYYYYYMMDD() {
// today
  var dateTimeObject = DateTime.now();
// year in the format УУУУ
  String year = dateTimeObject.year.toString();
// month in the format MM

  String month = dateTimeObject.month.toString();

  if (month.length == 1) {
    month = '0$month';
  }

// day in the format dd

  String day = dateTimeObject.day.toString();

  if (day.length == 1) {
    day = '0$day';
  }

// final format

  String yyyymmdd = year + month + day;
  return yyyymmdd;
}

//convert string yyyymmdd to Date time obeject
DateTime createDateTimeObject(String yyyymmdd) {
  int yyyy = int.parse(yyyymmdd.substring(0, 4));
  int mm = int.parse(yyyymmdd.substring(4, 6));
  int dd = int.parse(yyyymmdd.substring(6, 8));
  DateTime dateTimeObject = DateTime(yyyy, mm, dd);
  return dateTimeObject;
}

// convert Datetime object to string yyyymmdd
String convertDateTimeToYYYYMMDD(DateTime dateTime) {
// year in the format УУУУ
  String year = dateTime.year.toString();
// month in the format
  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }
// day in the format dd
  String day = dateTime.day.toString();
  if (day.length == 1) {
    day = 'e$day';
  }
// final format
  String yyyymmdd = year + month + day;
  return yyyymmdd;
}
