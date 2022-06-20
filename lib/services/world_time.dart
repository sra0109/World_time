import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  String location; //name for UI
  String time = ' '; // time in that location
  String flag;
  String url;
  bool? isDaytime;
  WorldTime(
      {required this.location,
      required this.flag,
      required this.url}); // constructor
  Future<void> getTime() async {
    try {
      Response response =
          await get(Uri.parse('http://worldtimeapi.org/api/timezone/$url'));

      Map data = jsonDecode(response.body);
      String datetime = data['datetime'];
      String offset1 = data['utc_offset'].substring(1, 3);
      String offset2 = data['utc_offset'].substring(4, 6);
      // print(data['utc_offset']);
      // print(datetime);
      // print(offset2);
      // print(DateTime.now());
      DateTime now = DateTime.parse(
          datetime); // parse returns the time at UTC (0 degree longitude)
      // print(now);
      if (data['utc_offset'][0] == '+') {
        now = now.add(
            Duration(hours: int.parse(offset1), minutes: int.parse(offset2)));
      } else {
        now = now.subtract(
            Duration(hours: int.parse(offset1), minutes: int.parse(offset2)));
      }
      isDaytime = now.hour > 6 && now.hour < 18 ? true : false;

      time = DateFormat.jm().format(now); //set the time property
    } catch (e) {
      // print('caught error: $e');
      time = 'Could not get time data';
    }

    // print(now);
    // print(data);
    //need dart.convert package to convert json string to map so that we can use that
  }
}
