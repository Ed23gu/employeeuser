import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  bool isLoading = false;
  TextEditingController titleController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();
  // Syntax to insert a record
  // await supabase.from('todos').insert({'title':'dummy value','date':'value'});

  @override
  void dispose() {
    titleController.dispose();
    supabase.dispose();
    super.dispose();
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
      Navigator.pop(context);
    } catch (e) {
      print("Error inserting data : $e");
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Something Went Wrong")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Observaciones"),
      ),
      body: SingleChildScrollView(
        child: Form(
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
                    autofocus: true,
                    decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.all(8),
                      hintText: "Ingrese aquí su observación",
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            final isValid = _formKey.currentState?.validate();
                            if (isValid != true) {
                              return;
                            }
                            setState(() {
                              isLoading = true;
                            });
                            await insertData();
                          },
                          child: const Text("Guardar")),
                ],
              ),
            )),
      ),
    );
  }
}
