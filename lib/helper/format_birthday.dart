String? formatBirthday(String? date) {
  if(date == null) {
    return null;
  }
  String month = date.substring(5, 7);
  String year = date.substring(0, 4);
  String day = date.substring(8, 10);
  String value =  switch(month) {
    '01' => 'January',
    '02' => 'February',
    '03' => 'March',
    '04' => 'April',
    '05' => 'May',
    '06' => 'June',
    '07' => 'July',
    '08' => 'August',
    '09' => 'September',
    '10' =>'October',
    '11' => 'November',
    '12' => 'December',
    _ => throw Exception()
  };
  int age = 0;
  var monthNow = DateTime.now().month;
  var yearNow = DateTime.now().year;
  var dayNow = DateTime.now().day;

  var fMonth = int.parse(month);
  var fYear = int.parse(year);
  var fDay = int.parse(day);

  age = yearNow - fYear;
  if (DateTime(fYear, fMonth, fDay).isAfter(DateTime(fYear, monthNow, dayNow))) {
    age--;
  }
  // String age = (DateTime.now().year - int.parse(year)).toString();
  return '$value $day, $year($age years old)';

}