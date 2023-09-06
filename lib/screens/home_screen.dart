import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:employee_attendance/screens/attendance_screen.dart';
import 'package:employee_attendance/screens/calender_screen.dart';
import 'package:employee_attendance/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 1;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _page,
        children: const [CalenderScreen(), AttendanceScreen(), ProfileScreen()],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 1,
        height: 55.0,
        items: <Widget>[
          Icon(Icons.calendar_today, size: 27),
          Icon(Icons.list, size: 27),
          Icon(Icons.person_outline_sharp, size: 27),
        ],
        color: Theme.of(context).colorScheme.tertiaryContainer,
        //     //  color: Colors.white,
        //     : Colors.black,
        buttonBackgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,

        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}
