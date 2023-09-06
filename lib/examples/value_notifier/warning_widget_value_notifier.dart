import 'package:flutter/material.dart';
import 'package:flutter_supabase/examples/value_notifier/connection_status_value_notifier.dart';
import 'package:flutter_supabase/utils/check_internet_connection.dart';

class WarningWidgetValueNotifier extends StatelessWidget {
  const WarningWidgetValueNotifier({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ConnectionStatusValueNotifier(),
      builder: (context, ConnectionStatus status, child) {
        return Visibility(
          visible: status != ConnectionStatus.online,
          child: Container(
            padding: const EdgeInsets.all(5),
            height: 25,
            color: Colors.black87,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.wifi_off,
                  size: 15,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                Text(
                  'Sin conexión a internet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
