import 'dart:math';

import 'package:employee_attendance/constants/constants.dart';
import 'package:employee_attendance/models/department_model.dart';
import 'package:employee_attendance/models/user_model.dart';
import 'package:employee_attendance/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DbService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  UserModel? userModel;
  UserModel? userModeldep;
  DepartmentModel? depModel2;
  DepartmentModel? depModel;
  DepartmentModel? departmentModel;
  List<DepartmentModel> allDepartments = [];
  List<UserModel> allempleados = [];
  int? employeeDepartment;
  String empleadolista = 'afebcc8c-9b68-4d49-83a5-ca67971eaedb';

  String generateRandomEmployeeId() {
    final random = Random();
    const allChars = "faangFAANG0123456789";
    final randomString =
        List.generate(8, (index) => allChars[random.nextInt(allChars.length)])
            .join();
    return randomString;
  }

  Future insertNewUser(String email, var id) async {
    await _supabase.from(Constants.employeeTable).insert({
      'id': id,
      'name': '',
      'email': email,
      'employee_id': generateRandomEmployeeId(),
      'department': null,
    });
  }

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

  Future<void> getAllDepartments() async {
    final List result =
        await _supabase.from(Constants.departmentTable).select();
    allDepartments = result
        .map((department) => DepartmentModel.fromJson(department))
        .toList();
    notifyListeners();
  }

  Future<void> getAllempleados() async {
    final List result = await _supabase.from(Constants.employeeTable).select();
    allempleados =
        result.map((empleados) => UserModel.fromJson(empleados)).toList();
    notifyListeners();
  }

  ////////

  Future updateProfile(String name, String cargo, BuildContext context) async {
    try {
      await _supabase.from(Constants.employeeTable).upsert({
        'name': name,
        'website': cargo,
        'department': employeeDepartment,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', _supabase.auth.currentUser!.id);
      Utils.showSnackBar("Perfil actualizado correctamente", context,
          color: Colors.green);
    } on PostgrestException catch (error) {
      SnackBar(
        content: Text(error.message),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } catch (error) {
      SnackBar(
        content: const Text('Unexpected error occurred'),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    }
    notifyListeners();
  }

  Future<DepartmentModel> getTodaydep() async {
    final userData = await _supabase
        .from(Constants.employeeTable)
        .select()
        .eq('id', _supabase.auth.currentUser!.id)
        .single();
    userModeldep = UserModel.fromJson(userData);
    employeeDepartment == null
        ? employeeDepartment = userModeldep?.department
        : null;
    final List result = await _supabase
        .from(Constants.departmentTable)
        .select()
        .eq("id", employeeDepartment);
    if (result.isNotEmpty) {
      depModel = DepartmentModel.fromJson(result.first);
    }
    return depModel!;
  }
}
