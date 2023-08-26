import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:employee_attendance/pages/upload_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'create_page.dart';
import 'edit_page.dart';
import 'package:intl/intl.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
// Filters

// 1. Equal to : supabase.from('users').select().eq('name','The Rock');
// 2. Not Equal to : supabase.from('users').select().neq('name','Bill Gates');
// 3. Greater than : supabase.from('users').select().gt('age',18);
// 4. Greater than or Equal : supabase.from('users').select().gte('followers',10000);
// 5. Less than : lt() and Less than Equal : lte()
// 6. Column matches a pattern (case sensitive) : supabase.from('users').select().like('name','%The%');
// 7. Column matches a case insensitive pattern : supabase.from('users').select().ilike('name','%the%');
// 8. Column is in the array : supabase.from('users').select().in_('status',['ONLINE','OFFLINE']);

// Modifiers

// 1. Order : supabase.from('users').select().order('id',ascending:false);
// 2. Limit the query : suapbase.from('users').select().limit(10);

// RealTime database
// Syntax : supabase.from('users').stream(primaryKey:['id']).listen((List data){ ..... });
// Using Streambuilder - stream : supabase.from('users').stream(primaryKey: ['id']);

class ComentariosPage extends StatefulWidget {
  const ComentariosPage({Key? key}) : super(key: key);

  @override
  State<ComentariosPage> createState() => _ComentariosPageState();
}

class _ComentariosPageState extends State<ComentariosPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  late Stream<List<Map<String, dynamic>>> _readStream;

  @override
  void initState() {
    _readStream = supabase
        .from('todos')
        .stream(primaryKey: ['id'])
        .eq('user_id', supabase.auth.currentUser!.id)
        .order('id', ascending: false);
    super.initState();
  }

  // Syntax to select data
  Future<List> readData() async {
    final result = await supabase
        .from('todos')
        .select()
        .eq('user_id', supabase.auth.currentUser!.id)
        .order('id', ascending: false);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Observaciones"),
        actions: [
          IconButton(
              /* onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UploadPage()));
              }, */

              onPressed: () {
                setState(() {
                  _readStream = supabase
                      .from('todos')
                      .stream(primaryKey: ['id'])
                      .eq('user_id', supabase.auth.currentUser!.id)
                      .order('id', ascending: false);
                });
              },
              icon: const Icon(Icons.refresh_outlined)),

        ],
      ),
      body: StreamBuilder(
          stream: _readStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text( 'Error:'+ snapshot.error.toString()+'\nRecargue la pagina, por favor.', textAlign : TextAlign.center),
              );
            }

            if (snapshot.hasData) {
              if (snapshot.data.length == 0) {
                return const Center(
                  child: Text("Aun no ha subido observaciones"),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, int index) {
                    var data = snapshot.data[index]; // {} map
                    return ListTile(
                      title: SizedBox(

                        child: CupertinoContextMenu(actions: <Widget>[
                    CupertinoContextMenuAction(
                      child: Text('ddd')
                        , trailingIcon: CupertinoIcons.delete_simple,)
                          
                        ], child: Container(
                          // color: Colors.purple,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.lightBlue,
                              borderRadius: BorderRadius.circular(11),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.cyan.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: const Offset(2, 4)),
                              ],
                            ),
                            child: Text(
                              data['title'],
                              style: const TextStyle(color: Colors.white),
                            )
                        ),) ,
                      ),
                      // Container(
                      //     // color: Colors.purple,
                      //     padding: const EdgeInsets.all(10),
                      //     margin: const EdgeInsets.symmetric(vertical: 10),
                      //     decoration: BoxDecoration(
                      //       color: Colors.lightBlue,
                      //       borderRadius: BorderRadius.circular(11),
                      //       boxShadow: [
                      //         BoxShadow(
                      //             color: Colors.cyan.withOpacity(0.2),
                      //             spreadRadius: 2,
                      //             blurRadius: 4,
                      //             offset: const Offset(2, 4)),
                      //       ],
                      //     ),
                      //     child: Text(
                      //       data['title'],
                      //       style: const TextStyle(color: Colors.white),
                      //     )
                      // ),
                      subtitle: Text(
                          data['created_at']
                              .split('.')[0]
                              .replaceAll("T", "-")
                              .toString(),
                          style: TextStyle(
                              color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light
                                  ? Colors.black45
                                  : Colors.grey
                              , fontSize: 12)),
                      trailing: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditPage(data['title'], data['id'])));
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.red,
                          )),
                    );
                  });
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton:
      FloatingActionButton.small(
        backgroundColor: Colors.lightBlue,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreatePage()));
        },
      ),
    );
  }
}
