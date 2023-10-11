import 'package:employee_attendance/examples/value_notifier/connection_status_value_notifier.dart';
import 'package:employee_attendance/perfil/pages/account_page.dart';
import 'package:employee_attendance/screens/profile_screen.dart';
import 'package:employee_attendance/utils/check_internet_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ErrorPagePerfil extends StatelessWidget {
  const ErrorPagePerfil();

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
                      width: 300,
                      height: 300,
                    ),
                    const SizedBox(height: 5.0),
                    const Text('Sin Conexión.\n',
                        style: TextStyle(
                          //  color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        )),
                    RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                            children: <TextSpan>[
                              TextSpan(text: 'Asegurese de:\n \n'),
                              TextSpan(
                                text:
                                    '     - Activar sus Datos mobiles o Wifi.\n     - Buscar un lugar con mejor cobertura. \n \n',
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
            : const ProfileScreen();
      },
    );
  }
}
