library globals;

String userID = 'null';
String userName = '';
bool isAdmin = false;

String selSubforAttendance = 'Subject';
String classMode = 'mode';
String timeOfClass = 'time';

//SUBJECTS FOR COUNTING CLASSES
List<String> subjects = [
  'C++',
  'Dart',
  'Java',
  'Javascript',
  'Python',
  'Swift'
];

List subjectsAttendance = [];
List subjectsTotalClass = [];
String attendancePercent = 'null';

//LOCATION BASED ATTENDANCE

// double latitude = 11.6273631;
// double longitude = 75.7227307;

double latitude = 13.0843241;
double longitude = 77.4849571;
bool streamStarted = false;
