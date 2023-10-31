import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:employee_attendance/constants/constants.dart';
import 'package:employee_attendance/constants/gaps.dart';
import 'package:employee_attendance/examples/value_notifier/warning_widget_value_notifier.dart';
import 'package:employee_attendance/models/attendance_model.dart';
import 'package:employee_attendance/models/ubi_model.dart';
import 'package:employee_attendance/services/attendance_service_admin.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart' as prove;
import 'package:readmore/readmore.dart';
import 'package:simple_month_year_picker/simple_month_year_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/user_model.dart';
import '../services/db_service_admin.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

Future<void> _openmap(String lat, String lon) async {
  Uri googleUrl =
      Uri.parse('https://www.google.com.ec/maps/search/?api=1&query=$lat,$lon');
  await canLaunchUrl(googleUrl)
      ? await launchUrl(googleUrl)
      : throw 'No se puede abrir $googleUrl';
}

class _CalenderScreenState extends State<CalenderScreen> {
  final AttendanceServiceadmin obtenerObs = AttendanceServiceadmin();
  final SupabaseClient supabase = Supabase.instance.client;
  late Stream<List<Map<String, dynamic>>> _readStream;
  final observacionesdiarias = [];
  final tablaasistencias = [];

  final tablaProvicional = [];
  List obsProvisional = [];
  final controller = ScrollController();
  String todayDate = DateFormat("MMMM yyyy", "es_ES").format(DateTime.now());
  var sizeicono = 20.0;
  var sizeletra = 12.0;
  String idSelected = 'abb73b57-f573-44b7-81cb-bf952365688b';
  UserModel? userModel;
  int? employeeDepartment;

  @override
  void initState() {
    super.initState();
    _readStream = supabase
        .from('todos')
        .stream(primaryKey: ['id'])
        .eq('user_id', "$idSelected")
        .order('id', ascending: false);
    todayDate = DateFormat("MMMM yyyy", "es_ES").format(DateTime.now());
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetch();
      }
    });
  }

  Future fetch() async {
    setState(() {});
  }

  List<dynamic> _filterpormes(List<dynamic> datalist, DateTime fecha) {
    final filteredList = datalist.where((element) {
      final createdAt = DateTime.parse(element['created_at']);
      final format = DateFormat('dd MMMM yyyy', "ES_es");
      final fechaObs = format.format(createdAt);
      final fechaAsistencia = format.format(fecha);
      return fechaObs == fechaAsistencia;
    }).toList();

    return filteredList;
  }

  Future getListadeObsyAsis(String id, DateTime fechaDeAsis) async {
    final format = DateFormat('dd MMMM yyyy', "ES_es");
    final fechaAsistenciaO = format.format(fechaDeAsis);
    try {
      List getAsisDiarias = await supabase
          .from(Constants.attendancetable)
          .select()
          .eq("employee_id", "$id")
          .eq("date", fechaAsistenciaO);

      final List getObsDiarias = await supabase
          .from(Constants.obstable)
          .select()
          .eq("user_id", "$id")
          .eq("date", fechaAsistenciaO);
    } catch (e) {
      print(e);
    }
  }

  Future<List<AttendanceModel>> getAttendanceHistory() async {
    final List data = await supabase
        .from(Constants.attendancetable)
        .select()
        .eq('employee_id', supabase.auth.currentUser!.id)
        //.textSearch('date', "'$attendanceHistoryMonth'")
        .order('created_at', ascending: false);
    return data
        .map((attendance) => AttendanceModel.fromJson(attendance))
        .toList();
  }

  Future<void> agregarFilasFaltantes() async {
    for (final observacion in observacionesdiarias) {
      final existe = tablaasistencias.any((asistencia) =>
          asistencia['employee_id'] == observacion['employee_id'] &&
          asistencia['fecha'] == observacion['fecha']);

      if (!existe) {
        tablaasistencias.add(observacion);
      }
    }
  }

  void _agregarObservacion(
      String employee_id, DateTime fecha, String observaciones) {
    final format = DateFormat('dd MMMM yyyy', "ES_es");
    final fechaAsistenciaO = format.format(fecha);
    Map<String, String> nuevaObservacion = {
      'employee_id': "$employee_id",
      'fecha': fechaAsistenciaO,
      'detalle': observaciones,
    };
    obsProvisional.add(nuevaObservacion);
    print(obsProvisional);
    print('pasada');
  }

  Future comprobarObs(
      String cadenaUnida, DateTime fechaDeAsis, String id) async {
    final format = DateFormat('dd MMMM yyyy', "ES_es");
    final fechaAsistenciaO = format.format(fechaDeAsis);
    try {
      final List result = await supabase
          .from(Constants.attendancetable)
          .select()
          .eq("employee_id", "$id")
          .eq('date', fechaAsistenciaO);
      if (result.isNotEmpty) {
        updateObs(cadenaUnida, fechaDeAsis, id);
      }
      insertarObs(cadenaUnida, fechaDeAsis, id);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future insertarObs(
      String cadenaUnida, DateTime fechaDeAsis, String id) async {
    final format = DateFormat('dd MMMM yyyy', "ES_es");
    final fechaAsistenciaO = format.format(fechaDeAsis);
    try {
      await supabase.from(Constants.attendancetable).insert({
        'date': fechaAsistenciaO,
        'obs': cadenaUnida,
        "employee_id": "$id"
      }).select();
      if (mounted) {}
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }

/*  

List<Map<String, dynamic>> observacionesdiarias = [
 { 'employee_id': '001', 'fecha': '02/01/2022', 'observaciones': 'Ejemplo de observación 1' },

];
void printTablaAsistencias(List<Map<String, dynamic>> tabla) {
 for (int i = 0; i < tabla.length; i++) {
    print('ID empleado: ${tabla[i]['employee_id']}');
    print('Fecha: ${tabla[i]['fecha']}');
    print('Observaciones: ${tabla[i]['observaciones']}');
    print('');
 }
}

/* import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:employee_attendance/screens/splash_screen.dart';
import 'package:employee_attendance/services/attendance_service.dart';
import 'package:employee_attendance/services/auth_service.dart';
import 'package:employee_attendance/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
xxxxxx
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
  String supabaseUrl = 'https://ikuxicurbjxyvfdaqevm.supabase.co';
  String supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlrdXhpY3VyYmp4eXZmZGFxZXZtIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODU1NzA3MjIsImV4cCI6MjAwMTE0NjcyMn0.M6gVfdPDTup6h-ritEoLXL37tLg_XSuVhnzqlRIcJ2w';
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
              theme: theme,
              darkTheme: darkTheme,
              home: const SplashScreen()),
        );
      },
    );
  }
}
 */

import 'package:flutter/material.dart';

List<Map<String, dynamic>> getObsDiarias = [
  {
    'employee_id': '001',
    'fecha': '01/01/2022',
    'detalle': 'observacioines de un dia sin registro'
  },
  {
    'employee_id': '001',
    'fecha': '02/01/2022',
    'detalle': 'observacioines añadida a asistencia'
  }
];
List<Map<String, dynamic>> getAsisDiarias = [
  {'employee_id': '001', 'fecha': '02/01/2022', 'detalle': ' '},
];
List<Map<String, dynamic>> obsProvisional = [];

void printTablaobs(List<Map<String, dynamic>> tabla) {
  for (int i = 0; i < tabla.length; i++) {
    print('ID empleado: ${tabla[i]['employee_id']}');
    print('Fecha: ${tabla[i]['fecha']}');
    print('Detalle: ${tabla[i]['detalle']}');
    print('');
  }
}

void _agregarObservacion(
    String employee_id, String fecha, String observaciones) {
  Map<String, dynamic> nuevaObservacion = {
    'employee_id': employee_id,
    'fecha': fecha,
    'detalle': observaciones,
  };

  obsProvisional.add(nuevaObservacion);
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi primera aplicacion en Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter'),
    );
  }
}

void passFromObsToAttendancce(
    List<Map<String, dynamic>> tabla1, List<Map<String, dynamic>> tabla2) {
  for (var entry1 in tabla1) {
    var found = false;

    for (var entry2 in tabla2) {
      if (entry1['employee_id'] == entry2['employee_id'] &&
          entry1['fecha'] == entry2['fecha']) {
        found = true;
        break;
      }
    }

    if (!found) {
      tabla2.add({
        'employee_id': entry1['employee_id'],
        'fecha': entry1['fecha'],
        'detalle': entry1['detalle'],
      });
    }
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.title),
        ),
        body: Center(
            child: Column(
          children: [
            IconButton(
                onPressed: () async {
                  print('--------------observaciones');
                  printTablaobs(getObsDiarias);
                  _agregarObservacion(
                      '001', '03/01/2022', 'observacion agregada provisional');
                  print('--------------observaciones añadidas ya unidas');
                  printTablaobs(getObsDiarias);
                  print('--------------observaciones provicionales');
                  printTablaobs(obsProvisional);
                },
                icon: Icon(Icons.add_a_photo)),
            Text(getAsisDiarias.toString()),
            IconButton(
                onPressed: () async {
                  print('-------------Lista con observaciones si no hay');
                  passFromObsToAttendancce(getObsDiarias, getAsisDiarias);
                  printTablaobs(getAsisDiarias);
                },
                icon: Icon(Icons.inventory_2)),
          ],
        )));
  }
}


void main() {
  
 printTablaAsistencias(observacionesdiarias);
   print('//////////////////////////////////////////////////');
 // Updating the list
  _agregarObservacion('hi',  '02/01/2022','observacion agregada');

 printTablaAsistencias(observacionesdiarias);
}


void _agregarObservacion(String employee_id, String fecha, String observaciones) {
 Map<String, dynamic> nuevaObservacion = {
    'employee_id': employee_id,
    'fecha': fecha,
    'observaciones': observaciones,
 };


    observacionesdiarias.add(nuevaObservacion);
}


















 tengo dos tablas en supabase la tabla uno, observacionesdiarias,  tiene id_empleado, fecha, y detalle y la tabla dos ,tablaasistencias, tiene id_empleado, fecha y observaciones, crear una funcion o funciones que vayan comparando los id_empleado y fecha entre ambas tablas y si no existe una fecha y id_empleado especifica en comun con tablados agregue una fila en tablados con el contenido de detalle con esa fecha y id_empleado , codigo en en flutter */
/*   Future<void> compareAndUpdateTables(DateTime fechaDeAsis, String id) async {
    final List<Map<String, dynamic>> tableOneData =
        await Supabase.instance.client.from(Constants.obstable).select();
    final List<Map<String, dynamic>> tableTwoData =
        await Supabase.instance.client.from(Constants.attendancetable).select();

    for (Map<String, dynamic> tableOneRecord in tableOneData) {
      int idEmpleado = tableOneRecord['id_empleado'];
      String fecha = tableOneRecord['fecha'];
      String detalle = tableOneRecord['detalle'];

      // Comprobar si hay un registro en la tabla dos con el mismo id_empleado y fecha
      bool exists = tableTwoData.any((record) =>
          record['id_empleado'] == idEmpleado && record['fecha'] == fecha);

      if (!exists) {
        // Agregar una fila en la tabla dos con el contenido de detalle de la tabla uno
        await Supabase.instance.client.from('tablaasistencias').insert([
          {'id_empleado': idEmpleado, 'fecha': fecha, 'observaciones': detalle}
        ]);
      }
    }
  }
 */
  Future updateObs(String cadenaUnida, DateTime fechaDeAsis, String id) async {
    final format = DateFormat('dd MMMM yyyy', "ES_es");
    final fechaAsistenciaO = format.format(fechaDeAsis);
    try {
      await supabase
          .from(Constants.attendancetable)
          .update({
            'obs': cadenaUnida,
          })
          .eq("employee_id", "$id")
          .eq('date', fechaAsistenciaO)
          .select();
      if (mounted) {}
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final attendanceService =
        prove.Provider.of<AttendanceServiceadmin>(context);
    final dbService = prove.Provider.of<DbServiceadmin>(context);
    dbService.allempleados.isEmpty ? dbService.getAllempleados() : null;
    return Column(
      children: [
        WarningWidgetValueNotifier(),
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
          child: const Text(
            "Mi Asistencia",
            style: TextStyle(fontSize: 22),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            dbService.allempleados.isEmpty
                ? SizedBox(width: 60, child: const LinearProgressIndicator())
                : Container(
                    //  padding: EdgeInsets.all(5),
                    margin: const EdgeInsets.only(
                        left: 5, top: 5, bottom: 10, right: 10),
                    height: widthSize50,
                    width: widthsize300,
                    child: DropdownButtonFormField(
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      value: dbService.empleadolista,
                      items: dbService.allempleados.map((UserModel item) {
                        return DropdownMenuItem(
                          value: item.id,
                          child: Text(
                            item.name.toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (selectedValue) {
                        setState(() {
                          attendanceService.attendanceusuario =
                              selectedValue.toString();
                          idSelected = selectedValue.toString();
                          _readStream = supabase
                              .from('todos')
                              .stream(primaryKey: ['id'])
                              .eq('user_id', "$idSelected")
                              .order('id', ascending: false);
                        });
                      },
                    ),
                  ),
            Text(
              attendanceService.attendanceHistoryMonth,
              style: const TextStyle(fontSize: fontsize25),
            ),
            OutlinedButton(
                onPressed: () async {
                  final selectedDate =
                      await SimpleMonthYearPicker.showMonthYearPickerDialog(
                          backgroundColor: AdaptiveTheme.of(context).mode ==
                                  AdaptiveThemeMode.light
                              ? Colors.white
                              : Colors.black,
                          selectionColor: AdaptiveTheme.of(context).mode ==
                                  AdaptiveThemeMode.light
                              ? Colors.blue
                              : Colors.white,
                          context: context,
                          disableFuture: true);
                  String pickedMonth =
                      DateFormat("MMMM yyyy", "ES_es").format(selectedDate);
                  attendanceService.attendanceHistoryMonth = pickedMonth;
                },
                child: const Text("Seleccionar mes")),
          ],
        ),
        Expanded(
            child: FutureBuilder(
                future: attendanceService.getAttendanceHistory(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length > 0) {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            AttendanceModel attendanceData =
                                snapshot.data[index];
                            return Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 12, left: 20, right: 20, bottom: 10),
                                  height: heightContainer,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          //  color: Colors.white,
                                          : Color.fromARGB(255, 43, 41, 41),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color.fromARGB(
                                                110, 18, 148, 255),
                                            blurRadius: 10,
                                            offset: Offset(2, 2)),
                                      ],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          child: Container(
                                        width: widthSize50,
                                        decoration: const BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: Center(
                                          child: Text(
                                            DateFormat("EE \n dd", "es_ES")
                                                .format(
                                                    attendanceData.createdAt),
                                            style: const TextStyle(
                                                fontSize: fontsize18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )),
                                      Expanded(
                                        child: Column(children: [
                                          Container(
                                            height: 20,
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Nombre:",
                                                    style: TextStyle(
                                                      decorationThickness: 2.2,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: fontsize15,
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.light
                                                          ? Colors.black
                                                          //  color: Colors.white,
                                                          : Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: heightSize10,
                                                  ),
                                                  Text(
                                                    attendanceData.usuario ??
                                                        '--/--',
                                                    style: TextStyle(
                                                      fontSize: fontsize15,
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.light
                                                          ? Colors.black
                                                          //  color: Colors.white,
                                                          : Colors.white,
                                                    ),
                                                  ),
                                                ]),
                                          ),
                                          const SizedBox(
                                            child: Divider(),
                                          ),
                                          Expanded(
                                              child: Row(children: [
                                            Expanded(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.apartment_sharp,
                                                      size: sizeicono,
                                                    ),
                                                    Text(
                                                      attendanceData.obra
                                                              ?.toString() ??
                                                          '--/--',
                                                      style: TextStyle(
                                                        fontSize: fontsize12,
                                                        color: Theme.of(context)
                                                                    .brightness ==
                                                                Brightness.light
                                                            ? Colors.black
                                                            //  color: Colors.white,
                                                            : Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: heightSize10,
                                                  child: Divider(),
                                                ),
                                                Expanded(
                                                    child: Row(children: [
                                                  Expanded(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "Ingreso: ",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  fontsize13,
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? Colors.black
                                                                  //  color: Colors.white,
                                                                  : Colors
                                                                      .white,
                                                            ),
                                                          ),
                                                          Text(
                                                            attendanceData
                                                                    .checkIn
                                                                    ?.toString() ??
                                                                '--/--',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  fontsize12,
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? Colors.black
                                                                  //  color: Colors.white,
                                                                  : Colors
                                                                      .white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: heightSize10,
                                                        width: heightSize80,
                                                        child: Divider(),
                                                      ),
                                                      Expanded(
                                                        child: ReadMoreText(
                                                          attendanceData.lugar_1
                                                                  ?.toString() ??
                                                              '--/--',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  sizeletra),
                                                          trimLines: 5,
                                                          // colorClickableText: Colors.pink,
                                                          trimMode:
                                                              TrimMode.Line,
                                                          trimCollapsedText:
                                                              '...Leer mas',
                                                          trimExpandedText:
                                                              ' Menos',
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                                  //////
                                                  Expanded(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      IconButton(
                                                          icon: Icon(
                                                            Icons.location_on,
                                                            size: sizeicono,
                                                          ),
                                                          onPressed: () {
                                                            var lat = UbiModel.fromJson(
                                                                    attendanceData
                                                                        .checkInLocation!)
                                                                .latitude;
                                                            var lon = UbiModel.fromJson(
                                                                    attendanceData
                                                                        .checkInLocation!)
                                                                .longitude;

                                                            _openmap(
                                                                lat.toString(),
                                                                lon.toString());
                                                          }),
                                                      Container(
                                                        child: attendanceData
                                                                    .pic_in ==
                                                                null
                                                            ? Icon(Icons.photo)
                                                            : attendanceData
                                                                        .pic_in ==
                                                                    "NULL"
                                                                ? const CircularProgressIndicator()
                                                                : Container(
                                                                    height:
                                                                        heightImage115,
                                                                    width:
                                                                        heightImage90,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .rectangle,
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(15)),
                                                                      image:
                                                                          DecorationImage(
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        image:
                                                                            CachedNetworkImageProvider(
                                                                          attendanceData
                                                                              .pic_in
                                                                              .toString(),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                      ),
                                                    ],
                                                  )),

                                                  /////////
                                                  Expanded(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "Salida: ",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  fontsize13,
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? Colors.black
                                                                  //  color: Colors.white,
                                                                  : Colors
                                                                      .white,
                                                            ),
                                                          ),
                                                          Text(
                                                            attendanceData
                                                                    .checkOut
                                                                    ?.toString() ??
                                                                '--/--',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  fontsize12,
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? Colors.black
                                                                  //  color: Colors.white,
                                                                  : Colors
                                                                      .white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                        width: 80,
                                                        child: Divider(),
                                                      ),
                                                      Expanded(
                                                        child: ReadMoreText(
                                                          attendanceData.lugar_2
                                                                  ?.toString() ??
                                                              '--/--',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  sizeletra),
                                                          trimLines: 5,
                                                          // colorClickableText: Colors.pink,
                                                          trimMode:
                                                              TrimMode.Line,
                                                          trimCollapsedText:
                                                              '...Leer mas',
                                                          trimExpandedText:
                                                              ' Menos',
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                                  Expanded(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      IconButton(
                                                          icon: Icon(
                                                            Icons.location_on,
                                                            size: sizeicono,
                                                          ),
                                                          onPressed: () {
                                                            var lat = UbiModel.fromJson(
                                                                    attendanceData
                                                                        .checkOutLocation!)
                                                                .latitude;
                                                            var lon = UbiModel.fromJson(
                                                                    attendanceData
                                                                        .checkOutLocation!)
                                                                .longitude;

                                                            _openmap(
                                                                lat.toString(),
                                                                lon.toString());
                                                          }),
                                                      Container(
                                                        child: attendanceData
                                                                    .pic_out ==
                                                                null
                                                            ? Icon(Icons.photo)
                                                            : attendanceData
                                                                        .pic_out ==
                                                                    "NULL"
                                                                ? const CircularProgressIndicator()
                                                                : Container(
                                                                    height:
                                                                        heightImage115,
                                                                    width:
                                                                        heightImage90,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .rectangle,
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(15)),
                                                                      image:
                                                                          DecorationImage(
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        image:
                                                                            CachedNetworkImageProvider(
                                                                          attendanceData
                                                                              .pic_out
                                                                              .toString(),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                      ),
                                                    ],
                                                  )),
                                                ])),
                                              ],
                                            )),
                                            const SizedBox(
                                              height: 10,
                                              width: 5,
                                            ),
                                            Expanded(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.apartment_sharp,
                                                      size: sizeicono,
                                                    ),
                                                    Text(
                                                      attendanceData.obra2
                                                              ?.toString() ??
                                                          '--/--',
                                                      style: TextStyle(
                                                        fontSize: fontsize12,
                                                        color: Theme.of(context)
                                                                    .brightness ==
                                                                Brightness.light
                                                            ? Colors.black
                                                            //  color: Colors.white,
                                                            : Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                  child: Divider(),
                                                ),
                                                Expanded(
                                                    child: Row(children: [
                                                  Expanded(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "Ingreso: ",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  fontsize13,
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? Colors.black
                                                                  //  color: Colors.white,
                                                                  : Colors
                                                                      .white,
                                                            ),
                                                          ),
                                                          Text(
                                                            attendanceData
                                                                    .checkIn2
                                                                    ?.toString() ??
                                                                '--/--',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  fontsize12,
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? Colors.black
                                                                  //  color: Colors.white,
                                                                  : Colors
                                                                      .white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                        width: 80,
                                                        child: Divider(),
                                                      ),
                                                      Expanded(
                                                        child: ReadMoreText(
                                                          attendanceData.lugar_3
                                                                  ?.toString() ??
                                                              '--/--',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  sizeletra),
                                                          trimLines: 5,
                                                          // colorClickableText: Colors.pink,
                                                          trimMode:
                                                              TrimMode.Line,
                                                          trimCollapsedText:
                                                              '...Leer mas',
                                                          trimExpandedText:
                                                              ' Menos',
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                                  Expanded(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      IconButton(
                                                          icon: Icon(
                                                            Icons.location_on,
                                                            size: sizeicono,
                                                          ),
                                                          onPressed: () {
                                                            var lat = UbiModel.fromJson(
                                                                    attendanceData
                                                                        .checkInLocation2!)
                                                                .latitude;
                                                            var lon = UbiModel.fromJson(
                                                                    attendanceData
                                                                        .checkInLocation2!)
                                                                .longitude;

                                                            _openmap(
                                                                lat.toString(),
                                                                lon.toString());
                                                          }),
                                                      Container(
                                                        child: attendanceData
                                                                    .pic_in2 ==
                                                                null
                                                            ? Icon(Icons.photo)
                                                            : attendanceData
                                                                        .pic_in2 ==
                                                                    "NULL"
                                                                ? const CircularProgressIndicator()
                                                                : Container(
                                                                    height:
                                                                        heightImage115,
                                                                    width:
                                                                        heightImage90,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .rectangle,
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(15)),
                                                                      image:
                                                                          DecorationImage(
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        image:
                                                                            CachedNetworkImageProvider(
                                                                          attendanceData
                                                                              .pic_in2
                                                                              .toString(),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                      ),
                                                    ],
                                                  )),
                                                  Expanded(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "Salida: ",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  fontsize13,
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? Colors.black
                                                                  //  color: Colors.white,
                                                                  : Colors
                                                                      .white,
                                                            ),
                                                          ),
                                                          Text(
                                                            attendanceData
                                                                    .checkOut2
                                                                    ?.toString() ??
                                                                '--/--',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  fontsize12,
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? Colors.black
                                                                  //  color: Colors.white,
                                                                  : Colors
                                                                      .white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                        width: 80,
                                                        child: Divider(),
                                                      ),
                                                      Expanded(
                                                        child: ReadMoreText(
                                                          attendanceData.lugar_4
                                                                  ?.toString() ??
                                                              '--/--',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  sizeletra),
                                                          trimLines: 5,
                                                          // colorClickableText: Colors.pink,
                                                          trimMode:
                                                              TrimMode.Line,
                                                          trimCollapsedText:
                                                              '...Leer mas',
                                                          trimExpandedText:
                                                              ' Menos',
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                                  Expanded(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      IconButton(
                                                          icon: Icon(
                                                            Icons.location_on,
                                                            size: sizeicono,
                                                          ),
                                                          onPressed: () {
                                                            var lat = UbiModel.fromJson(
                                                                    attendanceData
                                                                        .checkOutLocation2!)
                                                                .latitude;
                                                            var lon = UbiModel.fromJson(
                                                                    attendanceData
                                                                        .checkOutLocation2!)
                                                                .longitude;

                                                            _openmap(
                                                                lat.toString(),
                                                                lon.toString());
                                                          }),
                                                      Container(
                                                        child: attendanceData
                                                                    .pic_out2 ==
                                                                null
                                                            ? Icon(Icons.photo)
                                                            : attendanceData
                                                                        .pic_out2 ==
                                                                    "NULL"
                                                                ? const CircularProgressIndicator()
                                                                : Container(
                                                                    height:
                                                                        heightImage115,
                                                                    width:
                                                                        heightImage90,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .rectangle,
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(15)),
                                                                      image:
                                                                          DecorationImage(
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        image:
                                                                            CachedNetworkImageProvider(
                                                                          attendanceData
                                                                              .pic_out2
                                                                              .toString(),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                      ),
                                                    ],
                                                  )),
                                                ])),
                                              ],
                                            )),
                                          ])),
                                        ]),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          });
                    } else {
                      return const Center(
                        child: Text(
                          "Datos no disponibles",
                          style: TextStyle(fontSize: fontsize25),
                        ),
                      );
                    }
                  }
                  return const LinearProgressIndicator(
                    backgroundColor: Colors.white,
                    color: Colors.grey,
                  );
                })),
      ],
    );
  }
}
