import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
  bool _iconBool = false;
  IconData _iconLuz = Icons.wb_sunny;
  IconData _iconObs = Icons.nights_stay;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context) {
          return SizedBox(
              child: Center(
            child: Image.asset(
              'assets/icon/icon.png',
              width: 40,
            ),
          ));
        }),
        title: Text(
          "ArtConsGroup.",
          style: TextStyle(
            fontSize: 23,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _iconBool = !_iconBool;
                });
                if (_iconBool) {
                  AdaptiveTheme.of(context).setLight();
                } else {
                  AdaptiveTheme.of(context).setDark();
                }
              },
              icon: Icon(_iconBool ? _iconLuz : _iconObs)),
        ],
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
