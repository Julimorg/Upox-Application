import 'dart:collection';
import 'dart:developer';
import 'package:first_app/Components/CommonComponent/guide_button.dart';
import 'package:first_app/Components/CommonComponent/title_text.dart';
import 'package:first_app/Controller/request_controller.dart';
import 'package:first_app/Service/fetching_service.dart';
import 'package:first_app/View_Page/calendar_comboPage/EventDetailsPage.dart';
import 'package:first_app/View_Page/calendar_comboPage/ulti.dart';
import 'package:first_app/model/track_calendar_product.dart';
import 'package:first_app/model/track_user_product_response.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

//** NOTE
//** ĐÃ THÊM UI CHO CALENDAR, THÊM EventDetailsPage ĐỂ SET EVENT  ,
//** SET HIGHT CHO DAY VÀ HEIGHT CHO DATE*/

class CalendarMainPage extends StatefulWidget {

  

  @override
  _CalendarMainPage createState() => _CalendarMainPage();
}

class _CalendarMainPage extends State<CalendarMainPage> {
  // late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now(); //Thằng này đổi
  DateTime? _selectedDay;

  late LinkedHashMap<DateTime, List<TrackedCalendarProduct>> dangerousDates;// = LinkedHashMap<DateTime, List<TrackedUserProductResponse>>(equals: isSameDay,hashCode: getHashCode,);
  Map<DateTime,List<TrackedCalendarProduct>> productsInCalendar = {};
  String originalPath = "assets/calendarstatus/calendar_status";
  
  //List<TrackedCalendarProduct> calendarProducts
  FetchingService fetchingService = FetchingService.initialize();

  Future<List<TrackedCalendarProduct>> fetchData(String month, String year) async{
    
    log("Calendar fetching");  

    funcCallBack() {
      return fetchingService.fetchCalendar(month, year);
    }

    RequestController requestController = RequestController.withoutParameter(
      funcCallBack
    );

    fetchingService = FetchingService(requestController: requestController);

    List<TrackedCalendarProduct> calendarProducts = await requestController.request(); //List<TrackedCalendarProduct>
    await _buildDisplayedDates(calendarProducts);
    
    return calendarProducts;
  }

  Future<void> _buildDisplayedDates(List<TrackedCalendarProduct> products) async{

    log("Calendar Products: ${products.length}");

    for (var product in products) {
      List<TrackedCalendarProduct> displayedProduct = productsInCalendar[product.dateDisplay] ?? [];
      displayedProduct.add(product);
      productsInCalendar[product.dateDisplay] = displayedProduct;
    }

    dangerousDates = LinkedHashMap<DateTime, List<TrackedCalendarProduct>>(equals: isSameDay,hashCode: getHashCode,)..addAll(productsInCalendar);
  }
  
  List<TrackedCalendarProduct> _getEventsForDay(DateTime day) {
    return dangerousDates[day] ?? []; //List Event của ngày
  }

  List<TrackedCalendarProduct> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  String _getDateStatus(DateTime dateDisplay){
    int count = dangerousDates[dateDisplay]!.length;
    switch(count){
      case (>= 1 && <= 3):
        return "_3PRODUCTS.png";
      case (>= 4 && <= 7):
        return "_7PRODUCTS.png";
      case (>= 8 && <= 10):
        return "_10PRODUCTS.png";
      case (> 10):
        return "_OVER10.png";
      default:
        return "_NOTHING.png";
    }
  }
  

  int _findDiffFromFirstDayOfWeek(DateTime chosenDate){
    int dayOfWeek = chosenDate.weekday; //[1,7]
    return dayOfWeek - 1;
  }


  Map<DateTime,List<TrackedCalendarProduct>> takeChosenWeekEvents(DateTime chosenDate){
    Map<DateTime,List<TrackedCalendarProduct>> mp = {};
    int diff = _findDiffFromFirstDayOfWeek(chosenDate);
    DateTime firstDayOfWeek = chosenDate.subtract(Duration(days: diff));
    
    int count = 0;
    do{
      DateTime nextDayOfWeek = firstDayOfWeek.add(Duration(days: count));
      List<TrackedCalendarProduct> productList = dangerousDates[nextDayOfWeek]??[];
      mp[nextDayOfWeek] = productList;
      count++;
    }while(count < 7);

    return mp;
  }

    @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    // _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    // _selectedEvents.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    productsInCalendar = {};
    // dateHaveEvents = {};
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: fetchData(_focusedDay.month.toString(), _focusedDay.year.toString()), 
        builder: (context, snapshot) {
          //Pending
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.discreteCircle(
                  color: Colors.blue,
                  size: 50,
                ),
              );
            }
            if (snapshot.hasData && snapshot.data != null) {
              return 	SafeArea(
                child: Column(
                  children: [
                    Container(
                      width: width * 0.95,
                      height: height * 0.06,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.date_range),
                            onPressed: () async {
                              //Lịch chọn
                              _showDatePicker(context);
                            },
                          ),
                          const TitleText(
                            titleName: "Lịch của tôi",
                            fontFam: "Roboto",
                            fontWeight: FontWeight.w700,
                            fontSize: 25,
                            textColor: const Color(0xff363636),
                          ),
                          GuideButton(onPressed: () {}),
                          // Image.asset("assets/calendarstatus/calendar_status5.png"),
                        ],
                      ),
                    ),
                    Container(
                      // height: height * 0.5,
                      // color: Colors.amber,
                      child: TableCalendar(
                        firstDay: DateTime.utc(2024, 1, 1),
                        lastDay: DateTime.utc(2025, 12, 31),
                        // ? Set Height cho Calendar UI
                        daysOfWeekHeight: height * 0.1,
                        // ? Set Height cho Day UI
                        rowHeight: height * 0.1,
                        focusedDay: _focusedDay,
                        calendarFormat: _calendarFormat,
                        eventLoader: (day) {
                          log('Loading events for day: ${DateFormat('yyyy-MM-dd').format(day)}');
                          return _getEventsForDay(day);
                        },
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        calendarBuilders: CalendarBuilders(
                          markerBuilder: (context, date, events) {
                            // if(events.isEmpty && date.difference(_focusedDay).inDays == 0){
                            //   String imageName = '${originalPath}_CURRENT.png';
                            //   return Center(
                            //     child: Container(
                            //       width: 30,
                            //       height: 30,
                            //       // color: Colors.white,
                            //       decoration: BoxDecoration(
                            //         image: DecorationImage(
                            //           image: AssetImage(imageName),
                            //           fit: BoxFit.cover,
                            //         ),
                            //       ),
                            //       alignment: Alignment.center,
                            //       child: Text(
                            //         "${_focusedDay.day}", // SHow ra Date của event
                            //         style: const TextStyle(
                            //           color: Colors.white,
                            //           // fontWeight: FontWeight.bold,
                            //           fontSize: 12,
                            //         ),
                            //       ),
                            //     ),
                            //   );
                            // }
                            if (events.isNotEmpty) {
                              // dateHaveEvents[date] = true;
                              //Map<Date, int>
                              String imageName =
                                  '$originalPath${_getDateStatus(date)}';
                              return Center(
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  // color: Colors.white,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(imageName),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${date.day}", // SHow ra Date của event
                                    style: const TextStyle(
                                      color: Colors.black,
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return null; // Nếu không có sự kiện, không hiển thị gì
                          },
                        ),
                        onDaySelected: (selectedDay, focusedDay) {
                          // setState(() {
                          //   _selectedDay = selectedDay;
                          //   _focusedDay = focusedDay;
                          // });
                          // Điều hướng đến trang chi tiết sự kiện

                          Map<DateTime, List<TrackedCalendarProduct>>
                              eventsOfWeek = takeChosenWeekEvents(selectedDay);

                          if (dangerousDates[selectedDay] != null &&
                              dangerousDates[selectedDay]!.isNotEmpty) {
                            log("$selectedDay has events");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    //Truyền quả sự kiện cho cả tuần
                                    EventDetailsPage(selectedDay, eventsOfWeek),
                              ),
                            );
                          }
                        },
                        headerStyle: const HeaderStyle(
                          formatButtonVisible:
                              false, // Ẩn nút chuyển đổi định dạng lịch
                          titleCentered: true, // Canh giữa tiêu đề
                          leftChevronIcon:
                              Icon(Icons.chevron_left, color: Colors.white),
                          rightChevronIcon:
                              Icon(Icons.chevron_right, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );

            }
            else{
              return const SnackBar(
                content: Text("Took too long to response"),
                backgroundColor: Colors.red,
              );
            }
        },)
    );
  }

  // Hàm hiển thị DatePicker
  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _focusedDay,
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime(2025, 12, 31),
    );

    if (picked != null && picked != _focusedDay) {
      setState(() {
        _focusedDay = picked;
      });
    }
  }
}
