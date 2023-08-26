import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

//import 'package:cached_network_image/cached_network_image.dart';
import 'package:employee_attendance/services/attendance_service.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

// Syntax to fetch Images
// final List<FileObject> results = await supabase.storage.from('bucketName').list();

// Syntax to remove file
// final List<FileObject> result = await supabase.storage.from('bucketName').remove(['folderName/image1.png']);

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  bool isUploading = false;
  late final File? pickedImage;
  final picker = ImagePicker();
  final SupabaseClient supabase = Supabase.instance.client;

  String todayDate = DateFormat("dd MMMM yyyy").format(DateTime.now());
  String getUrl = "INICIAL";
  int segundos = 1;
  bool flagborrar = false;

  int imageq = 100;
  int qt = 85;
  int per = 15;

  File? _images;
  Uint8List webImage = Uint8List(8);
  Uint8List webImage2 = Uint8List(8);
  Uint8List webImage3 = Uint8List(8);
  Uint8List webImage4 = Uint8List(8);
  Uint8List webI = Uint8List(8);
  Uint8List webI2 = Uint8List(8);
  Uint8List webI3 = Uint8List(8);
  Uint8List webI4 = Uint8List(8);
  final AttendanceService subirubi = AttendanceService();

  Future getMyFiles() async {
    String fecharuta =
        DateFormat("ddMMMMyyyy").format(DateTime.now()).toString();
    DateTime now = DateTime.now();
    String fileName = '${DateFormat('yyyy-MM-dd_HH-mm-ss').format(now)}.jpg';
    final List<FileObject> result = await supabase.storage
        .from('obimagen')
        .list(
            path: '{supabase.auth.currentUser!.id}' +
                "/" +
                "$fecharuta" +
                "/" +
                "$fileName");
    List<Map<String, String>> myImages = [];

    for (var image in result) {
      final getUrl = supabase.storage.from('obimagen').getPublicUrl(
          "${supabase.auth.currentUser!.id}//$fecharuta/$fileName/${image.name}");
      myImages.add({'name': image.name, 'url': getUrl});
    }
    return myImages;
  }

  Future<void> deleteImage(String imageName) async {
    try {
      await supabase.storage
          .from('obimagen')
          .remove([supabase.auth.currentUser!.id + "/" + imageName]);
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Something went wrong !")));
    }
  }

  Future<File> customCompressed({
    @required File? imagePathToCompress,
    quality = 100,
    percentage = 15,
  }) async {
    var path = await FlutterNativeImage.compressImage(
      imagePathToCompress!.absolute.path,
      quality: qt,
      percentage: per,
    );
    return path;
  }

  Future choiceImage() async {
    if (!kIsWeb) {
      var pickedFile = await picker.pickImage(
          source: ImageSource.gallery, imageQuality: imageq);
      if (pickedFile != null) {
        await subirubi.getTodayAttendance();
        if (getUrl == "NULL") {
          setState(() {
            flagborrar = true;
          });
        }

        if (flagborrar == false) {
          _images = File(pickedFile.path);
          File? imagescom =
              await customCompressed(imagePathToCompress: _images);
          _images = File(imagescom.path);
          setState(() {
            isUploading = true;
          });
          String fecharuta =
              DateFormat("ddMMMMyyyy").format(DateTime.now()).toString();
          DateTime now = DateTime.now();
          String fileName =
              DateFormat('yyyy-MM-dd_HH-mm-ss').format(now) + '.jpg';
          try {
            String uploadedUrl = await supabase.storage.from('obimagen').upload(
                "${supabase.auth.currentUser!.id}/$fecharuta/$fileName",
                _images!);
            String urllisto = uploadedUrl.replaceAll("obimagen/", "");
            getUrl = supabase.storage.from('obimagen').getPublicUrl(urllisto);
            await supabase.from('todos').insert({
              'user_id': supabase.auth.currentUser!.id,
              'date': DateFormat("dd MMMM yyyy").format(DateTime.now()),
              'imagenadjunta': getUrl,
            });
            setState(() {
              isUploading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Foto cargada correctamente"),
              backgroundColor: Colors.green,
            ));
          } catch (e) {
            print("ERRROR : $e");
            setState(() {
              isUploading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Algo ha salido mal, intentelo nuevamente"),
              backgroundColor: Colors.red,
            ));
          }
        } else {
          _images = File(pickedFile.path);
          File? imagescom =
              await customCompressed(imagePathToCompress: _images);
          _images = File(imagescom.path);
          setState(() {
            isUploading = true;
          });
          String fecharuta =
              DateFormat("ddMMMMyyyy").format(DateTime.now()).toString();
          DateTime now = DateTime.now();
          String fileName =
              DateFormat('yyyy-MM-dd_HH-mm-ss').format(now) + '.jpg';
          try {
            String uploadedUrl = await supabase.storage.from('obimagen').upload(
                "${supabase.auth.currentUser!.id}/$fecharuta/$fileName",
                _images!);
            String urllisto = uploadedUrl.replaceAll("obimagen/", "");
            getUrl = supabase.storage.from('obimagen').getPublicUrl(urllisto);
            await supabase
                .from('todos')
                .update({
                  'imagenadjunta': getUrl,
                })
                .eq('user_id', supabase.auth.currentUser!.id)
                .eq('date', todayDate);

            setState(() {
              isUploading = false;
              flagborrar = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Foto cargada correctamente"),
              backgroundColor: Colors.green,
            ));
          } catch (e) {
            print("ERRROR : $e");
            setState(() {
              isUploading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Algo ha salido, intentelo nuevamente"),
              backgroundColor: Colors.red,
            ));
          }
        }
      }
    } else if (kIsWeb) {
      var pickedFileweb = await picker.pickImage(
          source: ImageSource.gallery, imageQuality: imageq);
      if (pickedFileweb != null) {
        await subirubi.markAttendance3(context);
        if (getUrl == "NULL") {
          setState(() {
            flagborrar = true;
          });
        }
        if (flagborrar == false) {
          var f = await pickedFileweb.readAsBytes();
          _images = File('a');
          setState(() {
            isUploading = true;
            webImage = f;
          });
        }
        var pickedFile = webImage;
        String fecharuta =
            DateFormat("ddMMMMyyyy").format(DateTime.now()).toString();
        DateTime now = DateTime.now();
        String fileName =
            DateFormat('yyyy-MM-dd_HH-mm-ss').format(now) + '.jpg';
        try {
          String uploadedUrl = await supabase.storage
              .from('obimagen')
              .uploadBinary(
                  "${supabase.auth.currentUser!.id}/$fecharuta/$fileName",
                  pickedFile);
          String urllisto = uploadedUrl.replaceAll("obimagen", "");
          final getUrl =
              supabase.storage.from('obimagen').getPublicUrl(urllisto);
          await supabase.from('todos').insert({
            'user_id': supabase.auth.currentUser!.id,
            'date': DateFormat("dd MMMM yyyy").format(DateTime.now()),
            'imagenadjunta': getUrl,
          });

          setState(() {
            isUploading = false;
            flagborrar = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Foto cargada correctamente !"),
            backgroundColor: Colors.green,
          ));
        } catch (e) {
          // print("ERRROR : $e");
          setState(() {
            isUploading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Algo ha salido mal"),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        var pickedFile = webImage;
        String fecharuta =
            DateFormat("ddMMMMyyyy").format(DateTime.now()).toString();
        DateTime now = DateTime.now();
        String fileName =
            DateFormat('yyyy-MM-dd_HH-mm-ss').format(now) + '.jpg';
        try {
          String uploadedUrl = await supabase.storage
              .from('obimagen')
              .uploadBinary(
                  "${supabase.auth.currentUser!.id}/$fecharuta/$fileName",
                  pickedFile);
          String urllisto = uploadedUrl.replaceAll("obimagen/", "");
          final getUrl =
              supabase.storage.from('obimagen').getPublicUrl(urllisto);
          await supabase
              .from('todos')
              .update({
                'imagenadjunta': getUrl,
              })
              .eq('user_id', supabase.auth.currentUser!.id)
              .eq('date', todayDate);

          setState(() {
            isUploading = false;
            flagborrar = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Foto cargada correctamente !"),
            backgroundColor: Colors.green,
          ));
        } catch (e) {
          // print("ERRROR : $e");
          setState(() {
            isUploading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Algo ha salido mal"),
            backgroundColor: Colors.red,
          ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Supabase Storage"),
      ),
      body: FutureBuilder(
        future: getMyFiles(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0) {
              return const Center(
                child: Text("No Image available"),
              );
            }
            return ListView.separated(
                itemCount: snapshot.data.length,
                padding: const EdgeInsets.symmetric(vertical: 10),
                separatorBuilder: (context, index) {
                  return const Divider(
                    thickness: 2,
                    color: Colors.black,
                  );
                },
                itemBuilder: (context, index) {
                  Map imageData = snapshot.data[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 200,
                        width: 300,
                        child: Image.network(
                          imageData['url'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          deleteImage(imageData['name']);
                        },
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                      )
                    ],
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: isUploading
          ? const CircularProgressIndicator()
          : FloatingActionButton(
              onPressed: choiceImage,
              child: const Icon(Icons.add_a_photo),
            ),
    );
  }
}
