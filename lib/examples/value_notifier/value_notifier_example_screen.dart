import 'package:flutter/material.dart';
import 'package:flutter_supabase/error_page.dart';
import 'package:flutter_supabase/examples/fake_user_list.dart';
import 'package:flutter_supabase/examples/value_notifier/warning_widget_value_notifier.dart';

class ValueNotifierExampleScreen extends StatelessWidget {
  const ValueNotifierExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Value notifier Example'),
      ),
      body: Column(
        children: const <Widget>[
          WarningWidgetValueNotifier(),
          FakeUserList(),
        ],
      ),
    );
  }
}
