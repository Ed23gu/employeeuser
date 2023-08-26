import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Update Functionality
// Syntax : supabase.from('users').update({'name':'Elon Musk'}).match({'id':10})
// Syntax : supabase.from('users').update({'name':'Elon Musk'}).eq('id',10);

// Delete Functionality

// Syntax : supabase.from('users').delete().match({'id':10});

class EditPage extends StatefulWidget {
  final String editData;
  final int editId;
  const EditPage(this.editData, this.editId, {super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  bool isLoading = false;
  TextEditingController titleController = TextEditingController();
  SupabaseClient supabase = Supabase.instance.client;

  @override
  void dispose() {
    titleController.dispose();
    supabase.dispose();
    super.dispose();
  }

  Future<void> updateData() async {
    if (titleController.text != '') {
      setState(() {
        isLoading = true;
      });

      try {
        await supabase.from('todos').update(
            {'title': titleController.text}).match({'id': widget.editId});
        Navigator.pop(context);
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Something Went Wrong")));
      }
    }
  }

  Future<void> deleteData() async {
    setState(() {
      isLoading = true;
    });

    try {
      await supabase.from('todos').delete().match({'id': widget.editId});
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Something Went Wrong")));
    }
  }

  @override
  void initState() {
    titleController.text = widget.editData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edite su Observación"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: "Enter the title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: updateData,
                         icon: Icon(Icons.update),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        onPressed: deleteData,
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
