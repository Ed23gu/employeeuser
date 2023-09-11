import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:employee_attendance/models/department_model.dart';
import 'package:employee_attendance/services/auth_service.dart';
import 'package:employee_attendance/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:employee_attendance/models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();

  popUpMenu() {
    return PopupMenuButton<int>(
        icon: Icon(Icons.menu),
        itemBuilder: (context) {
          return <PopupMenuEntry<int>>[
            PopupMenuItem(
                child: ListTile(
              leading: Icon(Icons.wb_sunny),
              title: Text("Claro"),
              onTap: () {
                AdaptiveTheme.of(context).setLight();
              },
            )),
            PopupMenuItem(
                child: ListTile(
              leading: Icon(Icons.brightness_2_outlined),
              title: Text("Oscuro"),
              onTap: () {
                AdaptiveTheme.of(context).setDark();
              },
            )),
          ];
        });
  }

  @override
  Widget build(BuildContext context) {
    final dbService = Provider.of<DbService>(context);
    // Using below conditions because build can be called multiple times
    dbService.allDepartments.isEmpty ? dbService.getAllDepartments() : null;
    nameController.text.isEmpty
        ? nameController.text = dbService.userModel?.name ?? ''
        : null;
    return Scaffold(
      body: dbService.userModel == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue),
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("Email: ${dbService.userModel?.email}"),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                          label: Text("Nombre"), border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
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
                                      //style: const TextStyle(fontSize: 20),
                                    ));
                              }).toList(),
                              onChanged: (selectedValue) {
                                dbService.employeeDepartment = selectedValue;
                              },
                            ),
                          ),
                    /*  SizedBox(
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
                                      style: const TextStyle(fontSize: 20),
                                    ));
                              }).toList(),
                              onChanged: (selectedValue) {
                                dbService.employeeDepartment = selectedValue;
                              },
                            ),
                          ),*/
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 50,
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          dbService.updateProfile(
                              nameController.text.trim(), context);
                        },
                        child: const Text(
                          "Actualizar Perfil",
                          // style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
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
                      margin: const EdgeInsets.only(top: 5, left: 5),
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Provider.of<AuthService>(context, listen: false)
                                  .signOut();
                            },
                            icon: const Icon(Icons.logout),
                          ),
                          Text(
                            "     Salir",
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
