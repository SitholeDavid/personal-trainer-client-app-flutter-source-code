import 'package:flutter_test/flutter_test.dart';
import 'package:personal_trainer_client/core/utils.dart';

void main() {
  group('UtilsTest -', () {
    group('formatDay -', () {
      test(
          'When called with string format of DateTime on 03 Aug 2020 must return 03 Aug',
          () {
        String date = DateTime.utc(2020, 08, 03).toString();
        expect(formatDay(date), '03 Aug');
      });

      test('When called with invalid DateTime string must return empty string',
          () {
        String date = 'invalid date time';
        expect(formatDay(date), '');
      });
    });

    group('createSessions -', () {
      test(
          'When called with an end time that comes before the startTime must return empty list of sessions',
          () {
        DateTime startTime = DateTime.utc(2020, 0, 0, 5); //5AM
        DateTime endTime = DateTime.utc(2020, 0, 0, 4); //4AM
        DateTime duration = DateTime.utc(2020, 0, 0, 1); //1 hour

        var sessions = createSessions(startTime, endTime, duration);
        expect(sessions.length, 0);
      });

      test(
          'When called with an end time that is equal to startTime must return empty list of sessions',
          () {
        DateTime startTime = DateTime.utc(2020, 0, 0, 5); //5AM
        DateTime endTime = DateTime.utc(2020, 0, 0, 5); //5AM
        DateTime duration = DateTime.utc(2020, 0, 0, 1); //1 hour

        var sessions = createSessions(startTime, endTime, duration);
        expect(sessions.length, 0);
      });

      test(
          'When called with an end time equal to 17:00 and startTime equal to 08:00 with 1 hour duration must return 9 sessions',
          () {
        DateTime startTime = DateTime.utc(2020, 0, 0, 8); //8AM
        DateTime endTime = DateTime.utc(2020, 0, 0, 17); //5PM
        DateTime duration = DateTime.utc(2020, 0, 0, 1); //1 hour

        var sessions = createSessions(startTime, endTime, duration);
        expect(sessions.length, 9);
      });

      test(
          'When called with an end time equal to 16:59 and startTime equal to 08:00 with 1 hour duration must return 9 sessions',
          () {
        DateTime startTime = DateTime.utc(2020, 0, 0, 8); //8AM
        DateTime endTime = DateTime.utc(2020, 0, 0, 16, 59); //5PM
        DateTime duration = DateTime.utc(2020, 0, 0, 1); //1 hour

        var sessions = createSessions(startTime, endTime, duration);
        expect(sessions.length, 9);
      });

      test(
          'When called with an end time equal to 17:05 and startTime equal to 08:00 with 1 hour duration must return 10 sessions',
          () {
        DateTime startTime = DateTime.utc(2020, 0, 0, 8); //8AM
        DateTime endTime = DateTime.utc(2020, 0, 0, 17, 5); //5PM
        DateTime duration = DateTime.utc(2020, 0, 0, 1); //1 hour

        var sessions = createSessions(startTime, endTime, duration);
        expect(sessions.length, 10);
      });
    });
  });
}
