import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:flutter/material.dart';

const List<String> twelveMonths = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

const sevenDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
const fullDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];

class MyDateTime {
  static String formatDate(DateTime date, List<String> monthList) {
    var str =
        "${monthList[date.month - 1].toString()}, ${date.year.toString()} ";
    return str;
  }

  ///get first date of week
  static DateTime getFirstDateOfWeek(DateTime date) {
    return date.weekday == 7 ? date : date.add(Duration(days: -date.weekday));
  }

  ///get all days of week
  static List<int> getDaysOfWeek(DateTime date) {
    var firstDay = getFirstDateOfWeek(date);
    var days = <int>[];
    for (var i = 0; i < 7; i++) {
      days.add(firstDay.add(Duration(days: i)).day);
    }
    return days;
  }
}

typedef DateCallback = void Function(DateTime val);

class CustomWeekViewCalendar extends StatefulWidget {
  final Color selectedDayBackgroundColor;
  final DateTime currentDate;
  final List<String> strWeekDays;
  final List<String> monthList;
  final String format;
  final DateCallback? dateCallback;

  //style
  final TextStyle defaultTextStyle;
  final TextStyle headerTextStyle;
  final TextStyle dateTextStyle;
  final TextStyle disableDateTextStyle;
  final TextStyle selectedDateTextStyle;
  final TextStyle weekDayTextStyle;
  final TextStyle selectedWeekDayTextStyle;
  final TextStyle disableWeekDayTextStyle;
  final BoxDecoration selectedBackgroundDecoration;
  final BoxDecoration backgroundDecoration;
  final bool typeCollapse;
  final double bodyHeight;

  CustomWeekViewCalendar({
    required this.selectedDayBackgroundColor,
    required this.bodyHeight,
    required this.currentDate,
    this.strWeekDays = sevenDays,
    this.monthList = twelveMonths,
    this.format = "yyyy/MM/dd",
    this.dateCallback,
    this.defaultTextStyle = const TextStyle(),
    this.headerTextStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: kDeepBlueColor,
    ),
    this.dateTextStyle = const TextStyle(
      fontSize: 14.0,
      height: 2.2,
      fontWeight: FontWeight.bold,
      color: kDeepBlueColor,
    ),
    this.disableDateTextStyle = const TextStyle(
      fontSize: 14.0,
      height: 2.2,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
    ),
    this.selectedDateTextStyle = const TextStyle(
      fontSize: 14.0,
      // height: 2.2,
      fontWeight: FontWeight.bold,
      color: kMediumBlueColor,
    ),
    this.weekDayTextStyle = const TextStyle(
        fontSize: 14.0,
        color: kDeepBlueColor
    ),
    this.selectedWeekDayTextStyle = const TextStyle(
        fontSize: 14.0, color: Colors.white
    ),
    this.disableWeekDayTextStyle = const TextStyle(
        fontSize: 14.0, color: Colors.grey
    ),
    this.selectedBackgroundDecoration = const BoxDecoration(),
    this.backgroundDecoration = const BoxDecoration(),
    this.typeCollapse = false,
  });

  @override
  _CustomWeekViewCalendarState createState() => _CustomWeekViewCalendarState();
}

class _CustomWeekViewCalendarState extends State<CustomWeekViewCalendar>
    with TickerProviderStateMixin {
  DateTime? currentSelectedDate;
  var weekDays = <int>[];
  var selectedIndex = 0;
  var _close = false;
  bool _isPrevious = false;

  //Collapse
  AnimationController? _collapseController;
  // Animation<double>? _collapseAnimation;
  // var _heightCollapse = 0.0;

  _setSelectedDate(int index) {
    setState(() {
      selectedIndex = index;

      currentSelectedDate =
          MyDateTime.getFirstDateOfWeek(currentSelectedDate!).add(Duration(days: index));
      if (widget.dateCallback != null) widget.dateCallback!(currentSelectedDate!);
      // print("selected date: $currentSelectedDate");
    });
  }

  _previousWeek(int days) {
    setState(() {
      final difference = currentSelectedDate!.difference(DateTime.now()).inDays;
      difference <= 12 ?_isPrevious = false : _isPrevious = true;
      currentSelectedDate = currentSelectedDate!.add(Duration(days: days));
      if (widget.dateCallback != null) widget.dateCallback!(currentSelectedDate!);
    });
  }

  _nextWeek(int days) {
    setState(() {
      _isPrevious = true;
      currentSelectedDate = currentSelectedDate!.add(Duration(days: days));
      if (widget.dateCallback != null) widget.dateCallback!(currentSelectedDate!);
    });
  }

  // _collapse() {
  //   if (!widget.typeCollapse) return;
  //   if (_collapseController!.status == AnimationStatus.completed && _close) {
  //     _collapseController!.reverse();
  //     _close = false;
  //   } else if (_collapseController!.status == AnimationStatus.dismissed) {
  //     _collapseController!.forward();
  //     _close = true;
  //   }
  // }

  @override
  void initState() {
    super.initState();
    currentSelectedDate = widget.currentDate;
    // if(widget.dateCallback != null)
    //   widget.dateCallback(currentDate);
    selectedIndex = currentSelectedDate!.weekday == 7 ? 0 : currentSelectedDate!.weekday;

    //Collapse
    // _heightCollapse = widget.bodyHeight;
    _collapseController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    // _collapseAnimation = Tween<double>(begin: widget.bodyHeight, end: 0)
    //     .animate(_collapseController!);
    _collapseController!.addListener(() {
      // setState(() {
      //   _heightCollapse = _collapseAnimation!.value;
      // });
      if (_collapseController!.status == AnimationStatus.completed && !_close) {
        _collapseController!.reset();
        _close = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    weekDays = MyDateTime.getDaysOfWeek(currentSelectedDate!);
    var size = MediaQuery.of(context).size;
    var rowWeeks = Column(
      children: <Widget>[
        Container(
            decoration: widget.backgroundDecoration,
            padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          MyDateTime.formatDate(
                            currentSelectedDate!,
                            widget.monthList,
                          ),
                          style: widget.headerTextStyle,
                        ),
                        const SizedBox(
                            height: 10.54,
                            width: 10.5,
                            child: ImageIcon(
                              AssetImage('assets/images/awesome-calendar-day.png'),
                              color: Color(0xFF3A3F6C),
                            )
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () => _isPrevious?_previousWeek(-7):null,
                          child: Transform.scale(
                            scale: 0.7,
                            child: Icon(Icons.arrow_back_ios_outlined,
                                color: _isPrevious
                                    ? const Color(0xFF53577D)
                                    : const Color(0xFF9E9E9E)),
                          ),
                        ),
                        SizedBox(width: size.width * 0.02),
                        InkWell(
                          onTap: () => _nextWeek(7),
                          child: Transform.scale(
                            scale: 0.7,
                            child: const Icon(Icons.arrow_forward_ios_outlined,
                                color: Color(0xFF53577D)
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ]
            )
        ),
        Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
            //height: _heightCollapse,
            decoration: widget.backgroundDecoration,
            child: Row(
              children: [
                Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: widget.strWeekDays.map((i) {
                        return MyDateTime.getFirstDateOfWeek(currentSelectedDate!).add(Duration(days: widget.strWeekDays.indexOf(i))).difference(DateTime.now()).inDays>=0?InkWell(
                            onTap: () =>
                                _setSelectedDate(widget.strWeekDays.indexOf(i)),
                            child: Container(
                              // padding: EdgeInsets.all(5),
                              decoration:
                              selectedIndex == widget.strWeekDays.indexOf(i)
                                  ? widget.selectedBackgroundDecoration
                                  : const BoxDecoration(),
                              child: selectedIndex ==
                                  widget.strWeekDays.indexOf(i)
                                  ? Container(
                                height: 65,
                                // width: 32,
                                padding: const EdgeInsets.only(
                                    top: 6.0, left: 3, right: 3),
                                decoration: BoxDecoration(
                                  color: widget.selectedDayBackgroundColor,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      i,
                                      style:
                                      widget.selectedWeekDayTextStyle,
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Container(
                                      height: 26,
                                      width: 26,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(18),
                                      ),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          weekDays[widget.strWeekDays
                                              .indexOf(i)]
                                              .toString(),
                                          style: widget
                                              .selectedDateTextStyle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  : Column(
                                children: <Widget>[
                                  Text(
                                    i,
                                    style: widget.weekDayTextStyle,
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                      weekDays[widget.strWeekDays
                                          .indexOf(i)]
                                          .toString(),
                                      style: widget.dateTextStyle),
                                ],
                              ),
                            )):InkWell(
                            onTap: () => () {},
                            child: Container(
                              // padding: EdgeInsets.all(5),
                              decoration: const BoxDecoration(),
                              child:  Column(
                                children: <Widget>[
                                  Text(
                                    i,
                                    style: widget.disableWeekDayTextStyle,
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                      weekDays[widget.strWeekDays
                                          .indexOf(i)]
                                          .toString(),
                                      style: widget.disableDateTextStyle),
                                ],
                              ),
                            ));
                      }).toList()),
                ),
              ],
            ))
      ],
    );
    return rowWeeks;
  }
}
