import 'package:flutter/material.dart';
import 'package:flutter_supabase/examples/cubit/warning_widget_cubit.dart';
import 'package:flutter_supabase/examples/fake_user_list.dart';

class CubitExampleScreen extends StatelessWidget {
  const CubitExampleScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cubit Example'),
      ),
      body: Column(
        children: <Widget>[
          const WarningWidgetCubit(),
          const FakeUserList(),
        ],
      ),
    );
  }
}
