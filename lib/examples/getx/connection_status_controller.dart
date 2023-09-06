import 'dart:async';

import 'package:flutter_supabase/main.dart';
import 'package:flutter_supabase/utils/check_internet_connection.dart';
import 'package:get/get.dart';

class ConnectionStatusController extends GetxController {
  late StreamSubscription _connectionSubscription;

  final status = Rx<ConnectionStatus>(ConnectionStatus.online);

  ConnectionStatusController() {
    _connectionSubscription = internetChecker
        .internetStatus()
        .listen((newStatus) => status.value = newStatus);
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
    super.dispose();
  }
}
