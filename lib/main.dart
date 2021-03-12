import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'sign_in.dart';

import 'login_page.dart';
import 'class_display.dart';

// Author: Timothy Nkata
//Holidays for later use:
final Map<DateTime, List> _holidays = {
  DateTime(2021, 1, 1): ['New Year\'s Day'],
  DateTime(2021, 1, 6): ['Epiphany'],
  DateTime(2021, 2, 14): ['Valentine\'s Day'],
  DateTime(2021, 4, 21): ['Easter Sunday'],
  DateTime(2021, 4, 22): ['Easter Monday'],
  DateTime(2021, 5, 16): ['End of semester'],
};

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

// Author: Nathan Fenske
// Defines what should be loaded upon launching the application
// In this case we open to the login page
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  TextEditingController _eventController;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _eventController = TextEditingController();
    final _selectedDay = DateTime.now();


    _events = {
      /*_selectedDay.add(Duration(days: 1)): [
        'Class 1',
        'Class 2',
        'Class 3'
      ],*/
      DateTime.utc(2021, 12, 25): ['Christmas'],
      DateTime.utc(2021, 12, 25).subtract(Duration(days: 1)): ['Christmas Eve'],
      /*_selectedDay: ['Class A7', 'Class B7', 'Class C7', 'Class D7'],*/

    };

    _selectedEvents = [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: TextButton(
            child: Text("Log Out"),
            onPressed: () {
              signOutGoogle();
              Navigator.pop(context);
            },
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith(
                        (state) => Colors.white)),

          ),
          //Update. Code to delete a class, by Tim.
          actions: [

            /*IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async{
                final confirm = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Warning"),
                    content: Text("Deletes the most recent class added to the current date selected. Are you sure?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedEvents.removeAt(_selectedEvents.length - 1);
                          });
                          Navigator.pop(context, false);
                        },
                        child: Text("Delete"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text("Cancel", style: TextStyle(color: Colors.grey.shade700),),
                      ),
                    ],
                  ),
                ) ?? false;
                if(confirm){
                  //pop and delete the event
                  Navigator.pop(context);
                }
              },
            )*/
          ],
          title: Text(widget.title),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // Switch out 2 lines below to play with TableCalendar's settings
            //-----------------------
            _buildTableCalendar(
            ),
            // _buildTableCalendarWithBuilders(),
            const SizedBox(height: 8.0),
            _buildButtons(),
            const SizedBox(height: 8.0),
            Expanded(child: _buildEventList()),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){

            _showAddDialog();
            _buildEventList();
          },
        )
    );
  }
//Recent update to add a class. By Timothy N.
  _showAddDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Add Course to Selected Date"),
          content: TextField(
            controller: _eventController,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Add"),
              onPressed: (){
                if(_eventController.text.isEmpty) return;
                setState(() {
                  if(_events[_calendarController.selectedDay] != null){
                    _events[_calendarController.selectedDay].add(_eventController.text);
                    print(_events[_calendarController.selectedDay]);
                  } else {
                    _events[_calendarController.selectedDay] = [_eventController.text];
                  }
                  _eventController.clear();
                  Navigator.pop(context);
                });
              },
            )
          ],
        )
    );

  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar({Map<DateTime, List> events}) {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[400],
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
        TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'pl_PL',
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.amber[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events, holidays) {
        _onDaySelected(date, events, holidays);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
            ? Colors.brown[300]
            : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }


  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildButtons() {
    final dateTime = _events.keys.elementAt(_events.length - 2);

    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text('Month'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.month);
                });
              },
            ),
            RaisedButton(
              child: Text('2 weeks'),
              onPressed: () {
                setState(() {
                  _calendarController
                      .setCalendarFormat(CalendarFormat.twoWeeks);
                });
              },
            ),
            RaisedButton(
              child: Text('Week'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.week);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        RaisedButton(
          child: Text(
              'Set day ${dateTime.day}-${dateTime.month}-${dateTime.year}'),
          onPressed: () {
            _calendarController.setSelectedDay(
              DateTime(dateTime.year, dateTime.month, dateTime.day),
              runCallback: true,
            );
          },
        ),
      ],
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.8),
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin:
        const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ListTile(
          title: Text(event.toString()),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async{
              final confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Warning"),
                  content: Text("This class will be deleted forever. Are you sure?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedEvents.removeAt(_selectedEvents.indexOf('$event'));
                        });
                        Navigator.pop(context, false);
                      },
                      child: Text("Delete"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text("Cancel", style: TextStyle(color: Colors.grey.shade700),),
                    ),
                  ],
                ),
              ) ?? false;
              if(confirm){
                //pop and delete the event
                Navigator.pop(context);
              }
            },
          ),
          onTap: () {
            print('$event tapped');
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return ClassScreen(title: '$event');
                  },
                )
            );
          },
        ),
      ))
          .toList(),
    );
  }
}