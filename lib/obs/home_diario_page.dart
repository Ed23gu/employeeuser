import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:employee_attendance/obs/historial_page.dart';
import 'package:employee_attendance/services/obs_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  bool isLoading = false;
  bool isLoadingdel = false;
  TextEditingController titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // final attendanceService = root.Provider.of<ObsService>();
  final ObsService obsfiltro = ObsService();

  @override
  void dispose() {
    titleController.dispose();
    supabase.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _readStream = supabase
        .from('todos')
        .stream(primaryKey: ['id'])
        // .eq('user_id', supabase.auth.currentUser!.id)
        .eq(
          'date',
          DateFormat("dd MMMM yyyy").format(DateTime.now()),
        )
        .order('id', ascending: false);
    super.initState();
  }

  void clearText() {
    titleController.clear();
  }

  Future insertData() async {
    setState(() {
      isLoading = true;
    });
    try {
      String userId = supabase.auth.currentUser!.id;
      await supabase.from('todos').insert({
        'title': titleController.text,
        'user_id': userId,
        'date': DateFormat("dd MMMM yyyy").format(DateTime.now()),
        'horain': DateFormat('HH:mm').format(DateTime.now()),
      });
      setState(() {
        isLoading = false;
      });
      clearText();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Observación guardada"),
          width: 180,
          duration: new Duration(seconds: 1),
          behavior: SnackBarBehavior.floating));
      //  Navigator.pop(context);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Algo ha salido mal")));
    }
  }

  Future<void> _showMyDialog(int editId2) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Borrar esta observación?',
            style: TextStyle(fontSize: 15),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Si'),
              onPressed: () {
                deleteData(editId2);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteData(int editId2) async {
    setState(() {
      isLoadingdel = true;
    });

    try {
      await supabase.from('todos').delete().match({'id': editId2});
      //Navigator.pop(context);z
      isLoadingdel = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Observación borrada"),
          width: 180,
          duration: new Duration(seconds: 1),
          behavior: SnackBarBehavior.floating));
    } catch (e) {
      setState(() {
        isLoadingdel = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Algo ha salido mal!")));
    }
  }

  // Syntax to select data
  Future<List> readData() async {
    final result = await supabase
        .from('todos')
        .select()
        .eq(
          'user_id',
          supabase.auth.currentUser!.id,
        )
        .eq(
          'date',
          DateFormat("dd MMMM yyyy").format(DateTime.now()),
        )
        .order('id', ascending: false);
    return result;
  }

  Future<List> readData2() async {
    final result = await supabase
        .from('todos')
        .select()
        .eq(
          'user_id',
          supabase.auth.currentUser!.id,
        )
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
              onPressed: () {
                setState(() {
                  _readStream = supabase
                      .from('todos:user_id=eq.${supabase.auth.currentUser!.id}')
                      .stream(primaryKey: ['id'])
                      //.eq('user_id', supabase.auth.currentUser!.id)

                      .eq(
                        'date',
                        DateFormat("dd MMMM yyyy").format(DateTime.now()),
                      )
                      .order('id', ascending: false);
                });
              },
              icon: const Icon(Icons.refresh_outlined)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ComentariosHisPage()));
              },
              icon: Image.asset(
                'assets/historial.png',
                width: 30,
                height: 40,
              ))
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
                  stream: _readStream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                            'Error:' +
                                snapshot.error.toString() +
                                '\nRecargue la pagina, por favor.',
                            textAlign: TextAlign.center),
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
                            var data = snapshot.data[index];
                            
                             // {} map
                            return ListTile(
                                title: Container(
                                    // color: Colors.purple,
                                    padding: const EdgeInsets.all(10),
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 9),
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
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )),
                                subtitle: Text(
                                    data['created_at']
                                        .split('.')[0]
                                        .replaceAll("T", "-")
                                        .toString(),
                                    style: TextStyle(
                                        color: AdaptiveTheme.of(context).mode ==
                                                AdaptiveThemeMode.light
                                            ? Colors.black45
                                            : Colors.grey,
                                        fontSize: 12)),
                                trailing: SizedBox(
                                  child: IconButton(
                                    onPressed: () {
                                      _showMyDialog(data['id']);
                                    },
                                    icon: Icon(Icons.delete_outline),
                                  ),
                                ));
                          });
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  })),
          Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: null,
                      controller: titleController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor, rellene este campo.";
                        }
                        return null;
                      },
                      autofocus: false,
                      decoration: InputDecoration(
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.all(8),
                        hintText: "Ingrese aquí su observación.",
                        hintStyle: TextStyle(fontSize: 12),
                        border: const OutlineInputBorder(),
                        suffixIcon: Align(
                          widthFactor: 1.0,
                          heightFactor: 1.0,
                          child: IconButton(
                            icon: isLoading
                                ? CircularProgressIndicator()
                                : const Icon(Icons.send),
                            onPressed: () async {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              ;
                              final isValid = _formKey.currentState?.validate();
                              if (isValid != true) {
                                return;
                              }
                              setState(() {
                                isLoading = true;
                              });
                              await insertData();
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
