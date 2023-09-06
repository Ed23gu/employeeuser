import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_supabase/main.dart';
import 'package:flutter_supabase/utils/check_internet_connection.dart';

class ConnectionStatusValueNotifier extends ValueNotifier<ConnectionStatus> {
  late StreamSubscription _connectionSubscription;

  ConnectionStatusValueNotifier() : super(ConnectionStatus.online) {
    _connectionSubscription = internetChecker
        .internetStatus()
        .listen((newStatus) => value = newStatus);
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
    super.dispose();
  }
}
