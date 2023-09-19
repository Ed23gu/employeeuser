import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:employee_attendance/models/attendance_model.dart';
import 'package:employee_attendance/services/attendance_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_month_year_picker/simple_month_year_picker.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  var padd0 = 0.0;
  var padd4 = 4.0;

  var padd8 = 8.0;
  var padd12 = 12.0;
  var padd16 = 16.0;
  var altoContainer = 150.0;
  var anchoDia = 50.0;
  @override
  Widget build(BuildContext context) {
    final attendanceService = Provider.of<AttendanceService>(context);
    return Scaffold(
        body: Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(padd8, padd4, padd8, padd4),
          alignment: Alignment.centerLeft,
          child: Text(
            "Registro de Asitencias",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(padd8, padd4, padd8, padd4),
              child: Text(
                attendanceService.attendanceHistoryMonth,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            ElevatedButton(
                style: ButtonStyle(),
                onPressed: () async {
                  final selectedDate =
                      await SimpleMonthYearPicker.showMonthYearPickerDialog(
                          backgroundColor: AdaptiveTheme.of(context).mode ==
                                  AdaptiveThemeMode.light
                              ? Colors.white
                              //  color: Colors.white,
                              : Colors.black,
                          selectionColor: AdaptiveTheme.of(context).mode ==
                                  AdaptiveThemeMode.light
                              ? Colors.blue
                              //  color: Colors.white,
                              : Colors.white,
                          context: context,
                          disableFuture: true);

                  String pickedMonth =
                      DateFormat('MMMM yyyy').format(selectedDate);
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
                            return Container(
                              margin: EdgeInsets.only(
                                  top: padd8,
                                  left: padd16,
                                  right: padd16,
                                  bottom: padd8),
                              height: altoContainer,
                              decoration: BoxDecoration(
                                  color: AdaptiveTheme.of(context).mode ==
                                          AdaptiveThemeMode.light
                                      ? Colors.white
                                      //  color: Colors.white,
                                      : Color.fromARGB(255, 43, 41, 41),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color.fromARGB(110, 18, 148, 255),
                                        blurRadius: 5,
                                        offset: Offset(2, 2)),
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      child: Container(
                                    width: anchoDia,
                                    decoration: BoxDecoration(
                                      color: AdaptiveTheme.of(context).mode ==
                                              AdaptiveThemeMode.light
                                          ? Color(0xFFCDE5FF)
                                          : Color(0xFF00639A),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        DateFormat("EE \n dd", "es_ES")
                                            .format(attendanceData.createdAt),
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: AdaptiveTheme.of(context)
                                                        .mode ==
                                                    AdaptiveThemeMode.light
                                                ? Color(0xFF006689)
                                                : Color(0xFFFFFFFF),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )),
                                  Expanded(
                                    child: Column(children: [
                                      Expanded(
                                          child: Row(children: [
                                        Expanded(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Proyecto",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                              child: Divider(),
                                            ),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  padd4, padd0,  padd4, padd0),
                                              child: Text(
                                                attendanceData.obra
                                                        ?.toString() ??
                                                    '--/--',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
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
                                                  Text(
                                                    "Ingreso",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                    width: 80,
                                                    child: Divider(),
                                                  ),
                                                  Text(
                                                    attendanceData.checkIn
                                                            ?.toString() ??
                                                        '--/--',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  )
                                                ],
                                              )),
                                              Expanded(
                                                  child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Salida",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                    width: 80,
                                                    child: Divider(),
                                                  ),
                                                  Text(
                                                    attendanceData.checkOut
                                                            ?.toString() ??
                                                        '--/--',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  )
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
                                            Text(
                                              "Proyecto",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                              child: Divider(),
                                            ),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  4, 0, 4, 0),
                                              child: Text(
                                                attendanceData.obra2
                                                        ?.toString() ??
                                                    '--/--',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
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
                                                  Text(
                                                    "Ingreso",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                    width: 80,
                                                    child: Divider(),
                                                  ),
                                                  Text(
                                                    attendanceData.checkIn2
                                                            ?.toString() ??
                                                        '--/--',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  )
                                                ],
                                              )),
                                              Expanded(
                                                  child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Salida",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                    width: 80,
                                                    child: Divider(),
                                                  ),
                                                  Text(
                                                    attendanceData.checkOut2
                                                            ?.toString() ??
                                                        '--/--',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  )
                                                ],
                                              )),
                                            ])),
                                          ],
                                        )),
                                      ])),
                                      Row(
                                        children: [
                                          Text(attendanceData.lugar_1
                                              .toString()),
                                          Container(child: Text('d'))
                                        ],
                                      )
                                    ]),
                                  ),
                                ],
                              ),
                            );
                          });
                    } else {
                      return const Center(
                        child: Text(
                          "Datos no disponibles",
                          style: TextStyle(fontSize: 25),
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
    ));
  }
}
