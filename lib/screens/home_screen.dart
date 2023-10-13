import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:employee_attendance/constants/gaps.dart';
import 'package:employee_attendance/screens/errores/error_page_asis.dart';
import 'package:employee_attendance/screens/errores/error_page_calen.dart';
import 'package:employee_attendance/screens/errores/error_page_perfi.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 1;
  var pad16 = 16.0;
  var pad8 = 8.0;
  var pad4 = 4.0;

  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 15,
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        leading: Builder(builder: (BuildContext context) {
          return Row(
            children: [
              gapW16,
              SizedBox(
                  child: Center(
                child: Image.asset(
                  'assets/icon/icon.png',
                  width: 40,
                ),
              )),
            ],
          );
        }),
        title: Text(
          "ArtconsGroup.",
          style: TextStyle(
            fontSize: 28,
          ),
        ),
      ),
      body: IndexedStack(
        index: _page,
        children: const [ErrorPageCalen(), ErrorPageAsis(), ErrorPagePerfil()],
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
