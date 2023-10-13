import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:employee_attendance/constants/gaps.dart';
import 'package:employee_attendance/models/department_model.dart';
import 'package:employee_attendance/screens/perfil/avatar.dart';
import 'package:employee_attendance/services/auth_service.dart';
import 'package:employee_attendance/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as route;
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:employee_attendance/models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  TextEditingController nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _websiteController = TextEditingController();

  var anchoPerfil = 80.0;
  var altoPerfil = 80.0;
  var altoBoton50 = 50.0;
  var anchoBoton200 = 200.0;
  var pad16 = 16.0;
  var pad6 = 6.0;
  String? _avatarUrl;
  var _loading = true;
  int? employeeDepartment;

  /// Called once a user id is received within `onAuthenticated()`
  Future<void> _getProfile() async {
    setState(() {
      _loading = true;
    });

    try {
      final userId = _supabase.auth.currentUser!.id;
      final data = await _supabase
          .from('employees')
          .select<Map<String, dynamic>>()
          .eq('id', userId)
          .single();
      _usernameController.text = (data['username'] ?? '') as String;
      _websiteController.text = (data['website'] ?? '') as String;
      _avatarUrl = (data['avatar_url'] ?? '') as String;
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
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  /// Called when image has been uploaded to Supabase storage from within Avatar widget
  Future<void> _onUpload(String imageUrl) async {
    try {
      final userId = _supabase.auth.currentUser!.id;
      await _supabase.from('employees').upsert({
        'id': userId,
        'avatar_url': imageUrl,
      });
      if (mounted) {
        const SnackBar(
          content: Text('Updated your profile image!'),
        );
      }
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
    if (!mounted) {
      return;
    }

    setState(() {
      _avatarUrl = imageUrl;
    });
  }

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dbService = route.Provider.of<DbService>(context);
    // Using below conditions because build can be called multiple times
    dbService.allDepartments.isEmpty ? dbService.getAllDepartments() : null;
    nameController.text.isEmpty
        ? nameController.text = dbService.userModel?.name ?? ''
        : null;
    return Scaffold(
      body: dbService.userModel == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                gapH52,
                const Center(
                  child: CircularProgressIndicator(),
                ),
                gapH52,
                Container(
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          dbService.allDepartments.isEmpty
                              ? dbService.getAllDepartments()
                              : null;
                          nameController.text.isEmpty
                              ? nameController.text =
                                  dbService.userModel?.name ?? ''
                              : null;
                        });
                      },
                      icon: const Icon(
                        Icons.refresh_outlined,
                        size: 50,
                      )),
                ),
              ],
            )
          : Padding(
              padding: EdgeInsets.all(pad16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
// Todo: Zona de perfil

                    Avatar(
                      imageUrl: _avatarUrl,
                      onUpload: _onUpload,
                    ),
                    ////////////////////////
                    gapH8,
                    Text("Email: ${dbService.userModel?.email}"),
                    gapH16,
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                          label: Text("Nombre"), border: OutlineInputBorder()),
                    ),
                    gapH16,
                    dbService.allDepartments.isEmpty
                        ? const LinearProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            child: DropdownButtonFormField(
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder()),
                              value: dbService.employeeDepartment ??
                                  dbService.allDepartments.first.id,
                              items: dbService.allDepartments
                                  .map((DepartmentModel item) {
                                return DropdownMenuItem(
                                    value: item.id,
                                    child: Text(
                                      item.title,
                                    ));
                              }).toList(),
                              onChanged: (selectedValue) {
                                dbService.employeeDepartment = selectedValue;
                                employeeDepartment = selectedValue;
                              },
                            ),
                          ),
                    gapH16,
                    SizedBox(
                      height: altoBoton50,
                      width: anchoBoton200,
                      child: ElevatedButton(
                        onPressed: () {
                          dbService.updateProfile(nameController.text.trim(),
                              _websiteController.text.trim(), context);
                        },
                        child: const Text(
                          "Actualizar Perfil",
                          // style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                    gapH16,
                    ExpansionTile(
                      leading: Icon(Icons.brightness_6_outlined),
                      title: Text(
                        "Tema",
                        textAlign: TextAlign.left,
                      ),
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.wb_sunny),
                          title: Text("Claro"),
                          onTap: () {
                            AdaptiveTheme.of(context).setLight();
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.brightness_2_outlined),
                          title: Text("Oscuro"),
                          onTap: () {
                            AdaptiveTheme.of(context).setDark();
                          },
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(left: pad6),
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              route.Provider.of<AuthService>(context,
                                      listen: false)
                                  .signOut();
                            },
                            icon: const Icon(Icons.logout),
                          ),
                          Text(
                            "Salir",
                            style: TextStyle(fontSize: 17),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class Item {
  Item({
    required this.headerText,
    required this.expandedText,
    this.isExpanded = false,
  });
  String headerText;
  String expandedText;
  bool isExpanded;
}
