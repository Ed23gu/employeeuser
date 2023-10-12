import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:employee_attendance/constants/gaps.dart';
import 'package:employee_attendance/models/department_model.dart';
import 'package:employee_attendance/perfil/components/avatar.dart';
import 'package:employee_attendance/services/auth_service.dart';
import 'package:employee_attendance/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as route;
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  final _usernameController = TextEditingController();
  final _websiteController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  String? _avatarUrl;
  var _loading = true;
  var anchoPerfil = 80.0;
  var altoPerfil = 80.0;
  var altoBoton50 = 50.0;
  var anchoBoton200 = 200.0;
  var pad16 = 16.0;
  var pad6 = 6.0;

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
      _usernameController.text = (data['name'] ?? '') as String;
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

  /// Called when user taps `Update` button
  Future<void> _updateProfile() async {
    setState(() {
      _loading = true;
    });
    final website = _websiteController.text.trim();
    final user = _supabase.auth.currentUser;
    final updates = {
      'id': user!.id,
      'website': website,
      'updated_at': DateTime.now().toIso8601String(),
    };
    try {
      await _supabase.from('employees').upsert(updates);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Successfully updated profile!'),
        ));
      }
    } on PostgrestException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
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
      //final userId = _supabase.auth.currentUser!.id;
      await _supabase.from('employees').upsert({
        // 'id': userId,
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
    dbService.allDepartments.isEmpty ? dbService.getAllDepartments() : null;
    nameController.text.isEmpty
        ? nameController.text = dbService.userModel?.name ?? ''
        : null;
    return Scaffold(
      body: (_loading == true || dbService.userModel == null)
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
                  // padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                  children: [
                    Avatar(
                      imageUrl: _avatarUrl,
                      onUpload: _onUpload,
                    ),
                    gapH8,
                    Text("Email: ${dbService.userModel?.email}"),
                    gapH16,
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                          label: Text("Nombre"), border: OutlineInputBorder()),
                    ),
                    gapH16,
                    TextField(
                      controller: _websiteController,
                      decoration: const InputDecoration(
                          label: Text("Cargo"), border: OutlineInputBorder()),
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
                              },
                            ),
                          ),
                    gapH8,
                    ElevatedButton(
                      onPressed: () {
                        // _loading ? null : _updateProfile();
                        dbService.updateProfile(nameController.text.trim(),
                            _websiteController.text.trim(), context);
                      },
                      // onPressed: _loading ? null : _updateProfile,
                      child: Text(_loading ? 'Saving...' : 'Actualizar Perfil'),
                    ),
                    gapH4,
                    Divider(),
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
                    gapH8,
                    Divider(),
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
