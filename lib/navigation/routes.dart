import 'package:flutter/material.dart';
import 'package:flutter_supabase/examples/change_notifier/change_notifier_example_screen.dart';
import 'package:flutter_supabase/examples/cubit/cubit_example_screen.dart';
import 'package:flutter_supabase/examples/getx/getx_example_screen.dart';
import 'package:flutter_supabase/examples/home.dart';
import 'package:flutter_supabase/examples/value_notifier/value_notifier_example_screen.dart';

class Routes {
  static const root = '/';
  static const getXExample = '/getXExample';
  static const cubitExample = '/cubitExample';
  static const valueNotifierExample = '/valueNotifierExample';
  static const changeNotifierExample = '/changeNotifierExample';

  static Route routes(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case root:
        return _buildRoute(const HomeWidget());
      case getXExample:
        return _buildRoute(const GetXExampleScreen());
      case cubitExample:
        return _buildRoute(const CubitExampleScreen());
      case valueNotifierExample:
        return _buildRoute(const ValueNotifierExampleScreen());
      case changeNotifierExample:
        return _buildRoute(const ChangeNotifierExampleScreen());
      default:
        throw Exception('Route does not exists');
    }
  }

  static MaterialPageRoute _buildRoute(Widget widget) =>
      MaterialPageRoute(builder: (_) => widget);
}
