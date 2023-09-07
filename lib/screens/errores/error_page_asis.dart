import 'package:employee_attendance/examples/value_notifier/connection_status_value_notifier.dart';
import 'package:employee_attendance/examples/value_notifier/warning_widget_value_notifier.dart';
import 'package:employee_attendance/screens/attendance_screen.dart';
import 'package:employee_attendance/utils/check_internet_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ErrorPageAsis extends StatelessWidget {
  const ErrorPageAsis();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ConnectionStatusValueNotifier(),
      builder: (context, ConnectionStatus status, child) {
        return status != ConnectionStatus.online
            ? Container(
                child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    WarningWidgetValueNotifier(),
                    SvgPicture.asset(
                      'assets/nocone22.svg',
                      width: 300,
                      height: 300,
                    ),
                    const SizedBox(height: 5.0),
                    const Text('Sin Conección.\n',
                        style: TextStyle(
                          //  color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        )),
                    RichText(
                        textAlign: TextAlign.left,
                        text: const TextSpan(
                            style: TextStyle(
                              fontSize: 13, /* color: Colors.black */
                            ),
                            children: <TextSpan>[
                              TextSpan(text: 'Intente:\n'),
                              TextSpan(
                                text:
                                    '     - Activar sus Datos mobiles o Wifi.\n     - Buscar un lugar con mejor cobertura. \n',
                              ),
                              TextSpan(text: 'y vuelva a '),
                              TextSpan(
                                  text: 'intentarlo.',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ])),
                  ],
                ),
                /*  child: Text(
                                    '${snapshot.error!.toString()}\n ${snapshot.stackTrace!.toString()}'), */
              ))
            : const AttendanceScreen();
      },
    );
  }
}
