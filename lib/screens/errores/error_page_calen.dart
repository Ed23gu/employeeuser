import 'package:employee_attendance/constants/gaps.dart';
import 'package:employee_attendance/examples/value_notifier/connection_status_value_notifier.dart';
import 'package:employee_attendance/screens/calender_screen.dart';
import 'package:employee_attendance/utils/check_internet_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ErrorPageCalen extends StatelessWidget {
  const ErrorPageCalen();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ConnectionStatusValueNotifier(),
      builder: (context, ConnectionStatus status, child) {
        return status != ConnectionStatus.online
            ? Center(
                child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // WarningWidgetValueNotifier(),
                    SvgPicture.asset(
                      'assets/nocone22.svg',
                      width: imgenerror300,
                      height: imgenerror300,
                    ),
                    gapH4,
                    const Text('Sin Conexión.\n',
                        style: TextStyle(
                          //  color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: sizeresul17,
                        )),
                    RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                            style: TextStyle(
                                fontSize: fontsize13,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer),
                            children: <TextSpan>[
                              const TextSpan(text: 'Asegurese de:\n \n'),
                              const TextSpan(
                                text:
                                    '     - Activar sus Datos mobiles o Wifi.\n     - Buscar un lugar con mejor cobertura. \n \n',
                              ),
                              const TextSpan(text: 'y vuelva a '),
                              const TextSpan(
                                  text: 'intentarlo.',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ])),
                  ],
                ),
              ))
            : const CalenderScreen();
      },
    );
  }
}
