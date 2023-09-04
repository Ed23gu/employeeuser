import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Position? _position;
  String locationName = '';
  String address = " ";
  String _address1 = " ";
  String curren = " ";

  void _getCurrentLocation() async {
    Position position = await _determinePosition();
    String ubicacion = await obtenerNombreUbicacion(position);
    setState(() {
      _position = position;
      _address1 = ubicacion;
    });
  }

  Future<String> obtenerNombreUbicacion(Position position) async {
    String posicion = position.toString().replaceAll(",", "");
    var lat = double.parse(posicion.split(' ')[1]);
    var log = double.parse(posicion.split(' ')[3]);
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, log);
      if (placemarks.isNotEmpty) {
        Placemark placeMark = placemarks[4];
        Placemark placeMark2 = placemarks[0];
        String name = placeMark.name!;
        String? subLocality = placeMark.subLocality;
        String? locality = placeMark.locality;
        String? administrativeArea = placeMark.administrativeArea;
        String? subadministrativeArea = placeMark.subAdministrativeArea;
        String? postalCode = placeMark.postalCode;
        String? country = placeMark.country;
        String? thoroughfare = placeMark.thoroughfare;
        String? street = placeMark2.street;
        //String address = "${name},${subLocality},${locality},${administrativeArea},${postalCode}, ${country}";
        setState(() {
          address =
              "$street,$thoroughfare,$subLocality,$locality,$subadministrativeArea,$administrativeArea";
        });
      } else {
        setState(() {
          locationName = 'No se pudo obtener el nombre de la ubicación.';
        });
      }
    } catch (e) {
      setState(() {
        print("error:$e");
        locationName = 'Error de conexión.';
      });
    }
    return address;
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permissions are denied');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Geolocation App"),
      ),
      body: Center(
        child: _position != null
            ? Text('ubicacion actual $_position \n $_address1')
            : const Text('sin datos de ubicaion'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


/* import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:employee_attendance/color_schemes.g.dart';
import 'package:employee_attendance/screens/splash_screen.dart';
import 'package:employee_attendance/services/attendance_service.dart';
import 'package:employee_attendance/services/attendance_service_admin.dart';
import 'package:employee_attendance/services/auth_service.dart';
import 'package:employee_attendance/services/db_service.dart';
import 'package:employee_attendance/services/db_service_admin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  String supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imdsa25wemxya3RpbGx1bW1tYnJyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODM1MjE4MzMsImV4cCI6MTk5OTA5NzgzM30.gKrH4NNsIPZeDqys4BbQz0IU187EXU-g0WGXbxqAaKU';
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      dark: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      light: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => AuthService()),
            ChangeNotifierProvider(create: (context) => DbService()),
            ChangeNotifierProvider(create: (context) => AttendanceService()),
            ChangeNotifierProvider(create: (context) => DbServiceadmin()),
            ChangeNotifierProvider(
                create: (context) => AttendanceServiceadmin()),
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
              theme: theme,
              darkTheme: darkTheme,
              home: const SplashScreen()),
        );
      },
    );
  }
}
 */