import 'package:employee_attendance/screens/splash_screen.dart';
import 'package:employee_attendance/services/attendance_service.dart';
import 'package:employee_attendance/services/auth_service.dart';
import 'package:employee_attendance/services/db_service.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
///////////////////////////ADMIN OPCION//////
//////version 2 administrado////////////////////////////////
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // load env
 /* await dotenv.load(fileName: ".env");
  String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  String supabaseKey = dotenv.env['SUPABASE_KEY'] ?? '';
*/
  // Initialize Supabase
  String supabaseUrl = 'https://glknpzlrktillummmbrr.supabase.co';
  String supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imdsa25wemxya3RpbGx1bW1tYnJyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODM1MjE4MzMsImV4cCI6MTk5OTA5NzgzM30.gKrH4NNsIPZeDqys4BbQz0IU187EXU-g0WGXbxqAaKU';
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      dark: ThemeData.dark(),
      light: ThemeData.light(),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => AuthService()),
            ChangeNotifierProvider(create: (context) => DbService()),
            ChangeNotifierProvider(create: (context) => AttendanceService()),
          ],
          child: MaterialApp(
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('es', 'ES')
              ],
              debugShowCheckedModeBanner: false,
              title: 'Asistencia',
              /*  theme: ThemeData(
          primarySwatch: Colors.blue,
          ),*/
              theme: theme,
              darkTheme: darkTheme,
              home: const SplashScreen()),
        );
      },
    );
  }
}
