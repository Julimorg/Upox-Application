// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';
import 'dart:developer';

import 'package:table_calendar/table_calendar.dart';

/// Example event class.
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
/// 
/// 
/// 

//List<TrackedCalendarProduct>
final kEvents = LinkedHashMap<DateTime, List<Event>>(equals: isSameDay,hashCode: getHashCode,)..addAll(customDates);


final Map<DateTime, List<Event>> customDates = {
  DateTime.utc(2024, 1, 01): [Event("New Year Celebration")],
  DateTime.utc(2024, 2, 14): [Event("Valentine's Day")],
  DateTime.utc(2024, 3, 08): [Event("International Women's Day")],
  DateTime.utc(2024, 12, 01): [Event("Christmas")],
  DateTime.utc(2024, 12, 02): [Event("Christmas")],
  DateTime.utc(2024, 12, 03): [Event("Christmas")],
  DateTime.now(): [Event("Christmas")],
};


//Map<DateTime, List<Events>>
//Func đổ dữ liệu vào cho _kEventSource
Map<DateTime,List<Event>> generateEventCalendar(){
  Map<DateTime,List<Event>> mp = {};
  mp[DateTime(2024, 1, 1)] = [const Event("NY"), const Event("CL")];
  mp[DateTime(2024, 2, 4)] = [const Event("VL")];
  mp[DateTime(2024, 12, 25)] = [const Event("CM")];

  return mp;
}

List<Event> listTest = [const Event("Hello")];

final _kEventSource = //generateEventCalendar();
Map.fromIterable( //50 events
  List.generate(5, (index) => index), //5 [0, 4] //5 events này m hãy chia đều ngày xuất hiện cho nó
                                        //Bắt đầu từ tháng 12, 2024
    key: (item) { 
      log("Vị trí ngày: ${(item + 1).toString()}");
      log(DateTime.utc(kFirstDay.year, 12, item + 1).toString());
    return DateTime.utc(kFirstDay.year, 12, item + 1);
    }, //DateTime
    value: (item) { 
    log("Số lượng event trong ngày: ${item % 4 + 1}");
    // log("Event $item");
    return listTest;
        // List.generate(
        //   item % 4 + 1, (index) => Event('Event $item | ${index + 1}')
        // );
      }
    );
  // ..addAll({
  //   kToday: [
  //     Event('Today\'s Event 1'),
  //     Event('Today\'s Event 2'),
  //   ],
  // });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
//Tháng 9, 2024 (bắt đầu từ đây)
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
