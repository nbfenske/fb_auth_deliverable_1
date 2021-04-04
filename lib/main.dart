import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mysql1/mysql1.dart' as sql;

import 'sign_in.dart';
import 'login_page.dart';
import 'class_display.dart';
import 'notification_plugin.dart';

// Author: Timothy Nkata
// Holidays for later use
final Map<DateTime, List> _holidays = {
  DateTime(2021, 1, 1): ['New Year\'s Day'],
  DateTime(2021, 1, 6): ['Epiphany'],
  DateTime(2021, 2, 14): ['Valentine\'s Day'],
  DateTime(2021, 4, 21): ['Easter Sunday'],
  DateTime(2021, 4, 22): ['Easter Monday'],
  DateTime(2021, 5, 16): ['End of semester'],
};

// Author: Nathan Fenske + Timothy Nkata
// info to establish connection to external user database later
var conn;
var settings = new sql.ConnectionSettings(
    host: 'sql5.freesqldatabase.com',
    port: 3306,
    user: 'sql5399694',
    password: '4k6zvHCLMV',
    db: 'sql5399694'
);

Map<DateTime, List> _events;
void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

// Author: Nathan Fenske
// Defines what should be loaded upon launching the application
// In this case we open to the login (google sign-in) page
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(), // home refers to the page, our google sign-in page, to be initally shown
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// Author: Nathan Fenske + Timothy Nkata
// adds class information into our external user database
addClass(year, month, day, className) async {
  conn = await sql.MySqlConnection.connect(settings);
  var result = await conn.query('insert into users (userID, class, year, month, day) values (?, ?, ?, ?, ?)', [user_id, className, year, month, day]);
}

// Author: Nathan Fenske + Timothy Nkata
// removes class information into our external user database
removeClass(className) async {
  conn = await sql.MySqlConnection.connect(settings);
  var result = await conn.query('delete from users where userID = ? and class = ?', [user_id, className]);
}

// Author: Nathan Fenske
// Collects all the classes with a date currently assigned to it (meaning it occurs) for the
// current user and updates the passed map to have those date/class values.
loadClasses(map) async {
  conn = await sql.MySqlConnection.connect(settings);
  var results = await conn.query('select userID, class, year, month, day from users where userID = ?', [user_id]);
  // grabs and prints all ID/class name entries for this user
  for (var row in results) {
    print('Name: ${row[0]}, email: ${row[1]}, Y:${row[2]}, M:${row[3]}, D:${row[4]}');
    if (!(row[2] == 0 || row[3] == 0 || row[4] == 0 )){
      if(map[DateTime(row[2], row[3], row[4])] != null) {
        map[DateTime(row[2], row[3], row[4])].add(row[1]);
      } else {
        map[DateTime(row[2], row[3], row[4])]= [row[1]];
      }
    }
  };
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {

  TextEditingController _eventController;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    _events = {
      /*_selectedDay.add(Duration(days: 1)): [
        'Class 1',
        'Class 2',
        'Class 3'
      ],*/
      //DateTime.utc(2021, 12, 25): ['Christmas'],
      //DateTime.utc(2021, 12, 25).subtract(Duration(days: 1)): ['Christmas Eve'],
      /*_selectedDay: ['Class A7', 'Class B7', 'Class C7', 'Class D7'],*/

    };
    // Author: Nathan Fenske
    // This line below updates the current _events map to contain entries from the database
    loadClasses(_events);
    super.initState();
    _eventController = TextEditingController();
    final _selectedDay = DateTime.now();




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

  // Author: Timothy Nkata
  // Defines the structure of the calendar view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar( // Top bar of the calendar screen
          leading: TextButton(
            // Author: Nathan Fenske
            // Logout button on the top left, signs out of google
            child: Text("Log Out"),
            onPressed: () {
              signOutGoogle();
              Navigator.pop(context); // pop context just means go back to the previous screen (google sign-in)
            },
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith(
                        (state) => Colors.white)),

          ),
          //Update. Code to delete a class, by Tim.
          actions: [
            // Old code for the delete button, moved to the buildEventList function
            // so we have delete buttons for every class (not just the overall context)
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
            // Builds the calendar in the body of our main screen
            //_buildTableCalendar(
            //),
            _buildTableCalendarWithBuilders(),
            const SizedBox(height: 8.0),
            _buildButtons(),
            const SizedBox(height: 8.0),
            Expanded(child: _buildEventList()),
          ],
        ),
        // Author: Timothy Nkata
        // Add button in bottom right of screen, redirect to _showAddDialog
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){

            _showAddDialog();
            _buildEventList();
          },
        )
    );
  }

  // Author: Timothy Nkata
  // Adds a class into the current selected date (assuming a title is given to the class)
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
              onPressed: () async{
                await notificationPlugin.showNotification();
                if(_eventController.text.isEmpty) return; // Returns the same event list if not class title is given
                setState(() {
                  if(_events[_calendarController.selectedDay] != null){
                    _events[_calendarController.selectedDay].add(_eventController.text);
                    print(_events[_calendarController.selectedDay]);
                  } else {
                    _events[_calendarController.selectedDay] = [_eventController.text];
                  }
                  // add class information to the user database
                  addClass(_calendarController.selectedDay.year, _calendarController.selectedDay.month, _calendarController.selectedDay.day, _eventController.text);
                  _eventController.clear();
                  Navigator.pop(context); // Takes us back to the calendar once we have added a class
                });
              },
            )
          ],
        )
    );

  }

  // Author: Timothy Nkata
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

  // Author: Timothy Nkata
  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'en_US',
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

  // Author: Timothy Nkata
  // Builds the markers (little dots) to represent events associated with a given date
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

  // Builds markers for holidays, for later use
  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  // Builds the daterange selection buttons
  // Two weeks, month, week, set day to today
  Widget _buildButtons() {
    final dateTime = DateTime.now();

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
              'Refresh/Load Classes'),
          onPressed: () {
            _calendarController.setSelectedDay(
              DateTime(dateTime.year, dateTime.month, dateTime.day),
              runCallback: true,
            );
          },
        ),
        // Overview Button created by Konstatninos
        RaisedButton(
          child: Text('Overview'),
          onPressed:(){
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => OverviewPage()),
            );
          },
        ),
      ],
    );
  }

  // Builds a list of events underneath the calendar
  // Generated only for the current select day
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
                // Here's where we moved the delete button to, by putting it here we now have
                // A delete button associated with each event on the current event list showing
                builder: (context) => AlertDialog(
                  title: Text("Warning"),
                  content: Text("This class will be deleted forever. Are you sure?"),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          // Removes the associated event from the selected days event list
                          removeClass('$event');
                          _selectedEvents.removeAt(_selectedEvents.indexOf('$event'));
                        });
                        Navigator.pop(context);
                      },
                      child: Text("Delete"),
                    ),
                    TextButton( // Option to cancel and not delete anything if you accidentally pressed delete
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
          // Author: Nathan Fenske
          // Redirects the user to the ClassScreen defined in class_display.dart when they
          // tap on an event in the event list. The title for this screen will be set to the
          // name of this event
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

//New class is created in order to navigate to a new window (Konstantinos)
class OverviewPage extends StatelessWidget{


  Widget build(BuildContext context) {
    final title = 'Classes';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const SizedBox(height: 8.0),
            Expanded(child: _buildClassList(context)),
          ],
        ),
      ),
    );
  }

  // Author: Nathan Fenske
  // A near carbon-copy of the buildEventList function, repurposed to display the
  // overall list of classes in the Overview page as opposed to just
  Widget _buildClassList(BuildContext context) {
    print(_events.values);
    List<dynamic> listClasses = <dynamic>[];
    for (var i = 0; i < _events.values.length; i++){
      listClasses.addAll(_events.values.elementAt(i));
    }
    print(listClasses);
    return ListView(
      children: listClasses
          .map((event) => Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.8),
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin:
        const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ListTile(
          title: Text(event.toString()),
          // Author: Nathan Fenske
          // Redirects the user to the ClassScreen defined in class_display.dart when they
          // tap on an event in the event list. The title for this screen will be set to the
          // name of this event
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



// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text("Overview"),
//     ),
//     body: Center(
//       child: ElevatedButton(
//         onPressed: () {
//           Navigator.pop(context);
//         },
//         child: Text('Back to schedule'),
//       ),
//     ),
//   );
// }

}