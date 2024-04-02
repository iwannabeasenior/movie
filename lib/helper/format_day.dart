
String? formatDay(String? date) {
  if(date == null) {
    return null;
  }
  String month = date.substring(5, 7);
  String year = date.substring(0, 4);
  String day = date.substring(8, 10);
  String value =  switch(month) {
    '01' => 'Jan',
    '02' => 'Feb',
    '03' => 'Mar',
    '04' => 'Apr',
    '05' => 'May',
    '06' => 'Jun',
    '07' => 'Jul',
    '08' => 'Aug',
    '09' => 'Sep',
    '10' =>'Oct',
    '11' => 'Nov',
    '12' => 'Dec',
    _ => throw Exception()
  };
  return '$value $day, $year';
}
