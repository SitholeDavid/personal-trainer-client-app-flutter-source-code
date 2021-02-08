import 'package:flutter/cupertino.dart';

import 'models/session.dart';

Map<String, dynamic> dialogCustomData(dynamic value,
        {TextInputType inputType = TextInputType.text}) =>
    {'value': value, 'inputType': inputType};

String getWeekday(int weekday) {
  switch (weekday) {
    case 1:
      return 'MON';
    case 2:
      return 'TUE';
    case 3:
      return 'WED';
    case 4:
      return 'THU';
    case 5:
      return 'FRI';
    case 6:
      return 'SAT';
    case 7:
      return 'SUN';
    default:
      return 'SUN';
  }
}

String formatDay(String unformattedDay) {
  try {
    String day = unformattedDay.split(' ').first.split('-').elementAt(2);
    String intMonth = unformattedDay.split(' ').first.split('-').elementAt(1);
    String month = getMonth(int.parse(intMonth));
    String formattedDay = day + ' ' + month.substring(0, 3);
    return formattedDay;
  } catch (e) {
    return '';
  }
}

String getFullWeekday(int weekday) {
  switch (weekday) {
    case 1:
      return 'Monday';
    case 2:
      return 'Tuesday';
    case 3:
      return 'Wednesday';
    case 4:
      return 'Thursday';
    case 5:
      return 'Friday';
    case 6:
      return 'Saturday';
    case 7:
      return 'Sunday';
    default:
      return 'Sunday';
  }
}

String getMonth(int month) {
  switch (month) {
    case 1:
      return 'January';
    case 2:
      return 'February';
    case 3:
      return 'March';
    case 4:
      return 'April';
    case 5:
      return 'May';
    case 6:
      return 'June';
    case 7:
      return 'July';
    case 8:
      return 'August';
    case 9:
      return 'September';
    case 10:
      return 'October';
    case 11:
      return 'November';
    case 12:
      return 'December';
    default:
      return 'January';
  }
}

List<Session> createSessions(
    DateTime startTime, DateTime endTime, DateTime duration) {
  DateTime nextSlot =
      DateTime.utc(2020, 0, 0, startTime.hour, startTime.minute);
  DateTime endSlot = DateTime.utc(2020, 0, 0, endTime.hour, endTime.minute);
  var sessions = <Session>[];

  while (nextSlot.isBefore(endSlot)) {
    var nextSession = Session(
        client: 'Available',
        sessionID: '',
        startTime: nextSlot.toString(),
        clientToken: '',
        clientID: '-');

    sessions.add(nextSession);
    nextSlot =
        nextSlot.add(Duration(hours: duration.hour, minutes: duration.minute));
  }

  return sessions;
}

bool timeComesBefore(DateTime dateA, DateTime dateB) {
  if (dateA.hour < dateB.hour)
    return true;
  else if (dateA.hour == dateB.hour && dateA.minute < dateB.minute)
    return true;
  else
    return false;
}

bool timesAreEqual(DateTime timeA, DateTime timeB) {
  return (timeA.hour == timeB.hour && timeA.minute == timeB.minute);
}

List<Session> sortSessions(List<Session> sessions) {
  sessions.sort((a, b) {
    var aStartTime = DateTime.parse(a.startTime);
    var bStartTime = DateTime.parse(b.startTime);

    if (aStartTime.isBefore(bStartTime)) {
      return -1;
    } else {
      return 1;
    }
  });

  return sessions;
}

List<Session> sessionsBefore(List<Session> sessions, [DateTime reference]) {
  List<Session> filteredSessions = <Session>[];
  DateTime today = reference == null ? DateTime.now() : reference;
  for (Session session in sessions) {
    DateTime sessionDate = DateTime.parse(session.startTime);
    if (sessionDate.isBefore(today) || sessionDate.isAtSameMomentAs(today))
      filteredSessions.add(session);
  }
  return sortSessions(filteredSessions);
}

List<Session> sessionsAfter(List<Session> sessions, [DateTime reference]) {
  List<Session> filteredSessions = <Session>[];
  DateTime today = reference == null ? DateTime.now() : reference;
  for (Session session in sessions) {
    DateTime sessionDate = DateTime.parse(session.startTime);
    if (sessionDate.isAfter(today)) filteredSessions.add(session);
  }

  return sortSessions(filteredSessions);
}

String formatTime(DateTime time) {
  String unformattedTime = time.toString().split(' ').last;
  String hours = unformattedTime.split(':').first.padLeft(2, '0');
  String minutes = unformattedTime.split(':')[1].padLeft(2, '0');

  String formattedTime = '$hours : $minutes';

  return formattedTime;
}
