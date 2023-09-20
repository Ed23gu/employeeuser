import 'package:employee_attendance/constants/constants.dart';
import 'package:employee_attendance/models/attendance_model.dart';
import 'package:employee_attendance/models/department_model.dart';
import 'package:employee_attendance/models/user_model.dart';
import 'package:employee_attendance/services/location_service.dart';
import 'package:employee_attendance/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  DepartmentModel? depModel2;
  DepartmentModel? depModel22;
  var ubiModel;
  AttendanceModel? attendanceModel;
  String? employeename;
  String? obra2;
  String? employeename2;
  String? obra22;
  UserModel? userModel;
  UserModel? userModel2;
  UserModel? userModel22;
  AttendanceModel? userModel3;
  int? employeeDepartment;
  int? employeeDepartment2;
  bool bandera = false;

  String address = " ";

  String todayDate = DateFormat("dd MMMM yyyy").format(DateTime.now());

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _attendanceusuario = ' ';

  String get attendanceusuario => _attendanceusuario;

  set attendanceusuario(String value) {
    _attendanceusuario = value;
    notifyListeners();
  }

  String _attendanceHistoryMonth =
      DateFormat('MMMM yyyy').format(DateTime.now());

  String get attendanceHistoryMonth => _attendanceHistoryMonth;

  set attendanceHistoryMonth(String value) {
    _attendanceHistoryMonth = value;
    notifyListeners();
  }

  Future getTodayAttendance() async {
    final List result = await _supabase
        .from(Constants.attendancetable)
        .select()
        .eq("employee_id", _supabase.auth.currentUser!.id)
        .eq('date', todayDate);
    if (result.isNotEmpty) {
      attendanceModel = AttendanceModel.fromJson(result.first);
    }
    notifyListeners();
  }

//////////////////////
  Future<UserModel> getUserData() async {
    final userData = await _supabase
        .from(Constants.employeeTable)
        .select()
        .eq('id', _supabase.auth.currentUser!.id)
        .single();
    userModel = UserModel.fromJson(userData);
    // Since this function can be called multiple times, then it will reset the dartment value
    // That is why we are using condition to assign only at the first time
    employeeDepartment == null
        ? employeeDepartment = userModel?.department
        : null;
    return userModel!;
  }

  Future<bool> markAttendance(BuildContext context) async {
    final userData = await _supabase
        .from(Constants.employeeTable)
        .select()
        .eq('id', _supabase.auth.currentUser!.id)
        .single();
    userModel = UserModel.fromJson(userData);
    employeeDepartment == null
        ? employeeDepartment = userModel?.department
        : null;
    employeename == null ? employeename = userModel?.name : null;

    final List result2 = await _supabase
        .from(Constants.departmentTable)
        .select()
        .eq("id", employeeDepartment);
    depModel2 = DepartmentModel.fromJson(result2.first);

    Position? getLocation = await _determinePosition();
    print(getLocation);
    String ubicacion = await obtenerNombreUbicacion(getLocation);
    if (attendanceModel?.checkIn == null) {
      try {
        await _supabase
            .from(Constants.attendancetable)
            .update({
              //'employee_id': _supabase.auth.currentUser!.id,
              //'date': todayDate,
              'check_in': DateFormat('HH:mm').format(DateTime.now()),
              'check_in_location': getLocation,
              'obraid': depModel2!.title,
              'nombre_asis': userModel!.name,
              'lugar_1': ubicacion
            })
            .eq('employee_id', _supabase.auth.currentUser!.id)
            .eq('date', todayDate);
      } on PostgrestException catch (error) {
        print(error);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
         

          content: Text("$error Algo ha salido mal, intentelo nuevamente"),
          backgroundColor: Colors.red,
        ));
      } catch (e) {
        print("ERRROR DE PUERBADCSVDFKNVKDNVDNV: $e");
        bandera = true;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Algo ha salido mal, intentelo nuevamente"),
          backgroundColor: Colors.red,
        ));
        return bandera;
      }
    } else if (attendanceModel?.checkOut == null) {
      await _supabase
          .from(Constants.attendancetable)
          .update({
            'check_out': DateFormat('HH:mm').format(DateTime.now()),
            'check_out_location': getLocation,
          })
          .eq('employee_id', _supabase.auth.currentUser!.id)
          .eq('date', todayDate);
    } else {
      Utils.showSnackBar("Hora de Salida ya Resgistrada !", context);
    }
    getTodayAttendance();

    return bandera;
  }

  Future markAttendance3(BuildContext context) async {
    getTodayAttendance();
  }

  Future markAttendance2(BuildContext context) async {
    final userData2 = await _supabase
        .from(Constants.employeeTable)
        .select()
        .eq('id', _supabase.auth.currentUser!.id)
        .single();
    userModel2 = UserModel.fromJson(userData2);
    employeeDepartment2 == null
        ? employeeDepartment2 = userModel2?.department
        : null;
    employeename2 == null ? employeename2 = userModel2?.name : null;

    final List result32 = await _supabase
        .from(Constants.departmentTable)
        .select()
        .eq("id", employeeDepartment2);
    depModel22 = DepartmentModel.fromJson(result32.first);

    Map? getLocation =
        await LocationService().initializeAndGetLocation(context);
    print("Location Data2 :");
    print(getLocation);
    if (getLocation != null) {
      if (attendanceModel?.checkIn2 == null) {
        await _supabase
            .from(Constants.attendancetable)
            .update({
              'check_in2': DateFormat('HH:mm').format(DateTime.now()),
              'check_in_location2': getLocation,
              'obraid2': depModel22!.title,
            })
            .eq('employee_id', _supabase.auth.currentUser!.id)
            .eq('date', todayDate);
      } else if (attendanceModel?.checkOut2 == null) {
        await _supabase
            .from(Constants.attendancetable)
            .update({
              'check_out2': DateFormat('HH:mm').format(DateTime.now()),
              'check_out_location2': getLocation,
            })
            .eq('employee_id', _supabase.auth.currentUser!.id)
            .eq('date', todayDate);
      } else {
        Utils.showSnackBar("Hora de Salida ya Resgistrada !", context);
      }
      getTodayAttendance();
    } else {
      Utils.showSnackBar("No se puede obtener su ubicacion", context,
          color: Colors.blue);
      getTodayAttendance();
    }
  }

  Future<List<AttendanceModel>> getAttendanceHistory() async {
    final List data = await _supabase
        .from(Constants.attendancetable)
        .select()
        .eq('employee_id', _supabase.auth.currentUser!.id)
        .textSearch('date', "'$attendanceHistoryMonth'", config: 'english')
        .order('created_at', ascending: false);
    return data
        .map((attendance) => AttendanceModel.fromJson(attendance))
        .toList();
  }

  Future<List<AttendanceModel>> getAttendanceHistory2(context) async {
    final List data = await _supabase
        .from(Constants.attendancetable)
        .select()
        .eq('employee_id', _supabase.auth.currentUser!.id)
        .textSearch('date', "'$attendanceHistoryMonth'", config: 'english')
        .order('created_at', ascending: false);
    return data
        .map((attendance) => AttendanceModel.fromJson(attendance))
        .toList();
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
    
        String? subLocality = placeMark.subLocality;
        String? locality = placeMark.locality;
        //String? administrativeArea = placeMark.administrativeArea;
        String? subadministrativeArea = placeMark.subAdministrativeArea;
        // String? postalCode = placeMark.postalCode;
        //String? country = placeMark.country;
        String? thoroughfare = placeMark.thoroughfare;
        String? street = placeMark2.street;
      

        address =
            "$street,$thoroughfare,$subLocality,$locality,$subadministrativeArea";
      } else {
        address = 'No se pudo obtener el nombre de la ubicación.';
      }
    } catch (e) {
      print("error:$e");
      address = 'Error de conexión.';
    }
    return address;
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('El permiso de ubicaion esta denegado');
      }
    }

    return await Geolocator.getCurrentPosition();
  }
}
