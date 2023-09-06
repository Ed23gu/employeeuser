import 'package:employee_attendance/error_page.dart';
import 'package:employee_attendance/examples/value_notifier/connection_status_value_notifier.dart';
import 'package:employee_attendance/utils/check_internet_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

final List<String> _fakeNames = [
  'Abigail',
  'Alexandra',
  'Alison',
  'Amanda',
  'Amelia',
  'Amy',
  'Andrea',
  'Angela',
  'Anna',
  'Anne',
  'Audrey',
  'Ava',
  'Bella'
];

class FakeUserList extends StatelessWidget {
  const FakeUserList();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ConnectionStatusValueNotifier(),
      builder: (context, ConnectionStatus status, child) {
        return status != ConnectionStatus.online
            ? SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/nocone22.svg',
                      width: 300,
                      height: 400,
                      //color: Colors.red[200],
                    ),
                    // Image.asset(
                    //   'assets/error.png',
                    //   width: 200,
                    //   height: 200,
                    //   //color: Colors.red[200],
                    // ),
                    const SizedBox(height: 5.0),
                    const Text('Sin Conección.\n',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        )),
                    RichText(
                        textAlign: TextAlign.left,
                        text: const TextSpan(
                            style: TextStyle(fontSize: 13, color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(text: 'Intente:\n'),
                              TextSpan(
                                text:
                                    '     - Activar sus Datos mobiles o Wifi.\n     - Buscar un lugar con mejor cobertura. \n',
                              ),
                              TextSpan(text: 'y vuelva a '),
                              TextSpan(
                                  text: 'intentarlo.',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold)),
                            ])),
                  ],
                ),
                /*  child: Text(
                                    '${snapshot.error!.toString()}\n ${snapshot.stackTrace!.toString()}'), */
              )
            : const ErrorPage();
      },
    );
  }
}
