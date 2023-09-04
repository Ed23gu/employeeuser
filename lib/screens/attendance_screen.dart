import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:employee_attendance/models/department_model.dart';
import 'package:employee_attendance/models/user_model.dart';
import 'package:employee_attendance/services/attendance_service.dart';
import 'package:employee_attendance/services/db_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart' as route;
import 'package:slide_to_act/slide_to_act.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../pages/home_page.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final GlobalKey<SlideActionState> key = GlobalKey<SlideActionState>();
  final GlobalKey<SlideActionState> key2 = GlobalKey<SlideActionState>();
  String todayDate = DateFormat("dd MMMM yyyy").format(DateTime.now());
  String getUrl = "INICIAL";
  int segundos = 1;
  bool flagborrar = false;
  bool buttonDisabled = false;
  bool buttonDisabled2 = true;
  bool buttonDisabled3 = true;
  bool buttonDisabled4 = true;
  bool buttonDisabled5 = true;
  bool isUploading = false;
  bool isUploading2 = false;
  bool isUploading3 = false;
  bool isUploading4 = false;
  bool flat = false;
  int imageq = 100;
  int qt = 85;
  int per = 15;
  final picker = ImagePicker();
  File? pickedImage;
  File? _images;
  Uint8List webImage = Uint8List(8);
  Uint8List webImage2 = Uint8List(8);
  Uint8List webImage3 = Uint8List(8);
  Uint8List webImage4 = Uint8List(8);
  Uint8List webI = Uint8List(8);
  Uint8List webI2 = Uint8List(8);
  Uint8List webI3 = Uint8List(8);
  Uint8List webI4 = Uint8List(8);
  final SupabaseClient supabase = Supabase.instance.client;
  final AttendanceService subirubi = AttendanceService();

  Future borrar(String tipoimagen, String imageName) async {
    if (imageName != "NULL") {
      String url2 = imageName.split('/')[9].toString();
      String url3 = imageName.split('/')[10].toString();
      try {
        await supabase.storage
            .from('imageip')
            .remove([supabase.auth.currentUser!.id + "/" + url2 + "/" + url3]);
        print(supabase.auth.currentUser!.id + "/" + url2 + "/" + url3);
        await supabase
            .from('attendance')
            .update({
              '$tipoimagen': "NULL",
            })
            .eq('employee_id', supabase.auth.currentUser!.id)
            .eq('date', todayDate);
        setState(() {
          flagborrar = true;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text("Algo ha salido mal !")));
      }
    }
    setState(() {});
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

  Future<File> customCompressed2({
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

  Future<File> customCompressed3({
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

  Future<File> customCompressed4({
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
          source: ImageSource.camera, imageQuality: imageq);
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
            String uploadedUrl = await supabase.storage.from('imageip').upload(
                "${supabase.auth.currentUser!.id}/$fecharuta/$fileName",
                _images!);
            String urllisto = uploadedUrl.replaceAll("imageip/", "");
            getUrl = supabase.storage.from('imageip').getPublicUrl(urllisto);
            await supabase.from('attendance').insert({
              'employee_id': supabase.auth.currentUser!.id,
              'date': DateFormat("dd MMMM yyyy").format(DateTime.now()),
              'pic_in': getUrl,
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
              Future.delayed(
                Duration(seconds: segundos),
                () => key.currentState?.reset(),
              );
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
            String uploadedUrl = await supabase.storage.from('imageip').upload(
                "${supabase.auth.currentUser!.id}/$fecharuta/$fileName",
                _images!);
            String urllisto = uploadedUrl.replaceAll("imageip/", "");
            getUrl = supabase.storage.from('imageip').getPublicUrl(urllisto);
            await supabase
                .from('attendance')
                .update({
                  'pic_in': getUrl,
                })
                .eq("employee_id", supabase.auth.currentUser!.id)
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
              Future.delayed(
                Duration(seconds: segundos),
                () => key.currentState?.reset(),
              );
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
          source: ImageSource.camera, imageQuality: imageq);
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
              .from('imageip')
              .uploadBinary(
                  "${supabase.auth.currentUser!.id}/$fecharuta/$fileName",
                  pickedFile);
          String urllisto = uploadedUrl.replaceAll("imageip/", "");
          final getUrl =
              supabase.storage.from('imageip').getPublicUrl(urllisto);
          await supabase.from('attendance').insert({
            'employee_id': supabase.auth.currentUser!.id,
            'date': DateFormat("dd MMMM yyyy").format(DateTime.now()),
            'pic_in': getUrl,
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

            Future.delayed(
              Duration(seconds: segundos),
              () => key.currentState?.reset(),
            );
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
              .from('imageip')
              .uploadBinary(
                  "${supabase.auth.currentUser!.id}/$fecharuta/$fileName",
                  pickedFile);
          String urllisto = uploadedUrl.replaceAll("imageip/", "");
          final getUrl =
              supabase.storage.from('imageip').getPublicUrl(urllisto);
          await supabase
              .from('attendance')
              .update({
                'pic_in': getUrl,
              })
              .eq("employee_id", supabase.auth.currentUser!.id)
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
            Future.delayed(
              Duration(seconds: segundos),
              () => key.currentState?.reset(),
            );
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Algo ha salido mal"),
            backgroundColor: Colors.red,
          ));
        }
      }
    }
  }

  Future choiceImage2() async {
    if (!kIsWeb) {
      var pickedFile = await picker.pickImage(
          source: ImageSource.camera, imageQuality: imageq);
      if (pickedFile != null) {
        await subirubi.markAttendance3(context);
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
            isUploading2 = true;
          });
          String fecharuta =
              DateFormat("ddMMMMyyyy").format(DateTime.now()).toString();
          DateTime now = DateTime.now();
          String fileName =
              DateFormat('yyyy-MM-dd_HH-mm-ss').format(now) + '.jpg';
          try {
            String uploadedUrl = await supabase.storage.from('imageip').upload(
                "${supabase.auth.currentUser!.id}/$fecharuta/$fileName",
                _images!);
            String urllisto = uploadedUrl.replaceAll("imageip/", "");
            getUrl = supabase.storage.from('imageip').getPublicUrl(urllisto);
            await supabase
                .from('attendance')
                .update({
                  // 'employee_id': supabase.auth.currentUser!.id,
                  // 'date': DateFormat("dd MMMM yyyy").format(DateTime.now()),
                  'pic_out': getUrl,
                })
                .eq("employee_id", supabase.auth.currentUser!.id)
                .eq('date', todayDate);
            setState(() {
              isUploading2 = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Foto cargada correctamente"),
              backgroundColor: Colors.green,
            ));
          } catch (e) {
            print("ERRROR : $e");
            setState(() {
              isUploading2 = false;
              Future.delayed(
                Duration(seconds: segundos),
                () => key.currentState?.reset(),
              );
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Algo ha salido, intentelo nuevamente"),
              backgroundColor: Colors.red,
            ));
          }
        } else {
          _images = File(pickedFile.path);
          File? imagescom =
              await customCompressed(imagePathToCompress: _images);
          _images = File(imagescom.path);
          setState(() {
            isUploading2 = true;
          });
          String fecharuta =
              DateFormat("ddMMMMyyyy").format(DateTime.now()).toString();
          DateTime now = DateTime.now();
          String fileName =
              DateFormat('yyyy-MM-dd_HH-mm-ss').format(now) + '.jpg';
          try {
            String uploadedUrl = await supabase.storage.from('imageip').upload(
                "${supabase.auth.currentUser!.id}/$fecharuta/$fileName",
                _images!);
            String urllisto = uploadedUrl.replaceAll("imageip/", "");
            getUrl = supabase.storage.from('imageip').getPublicUrl(urllisto);
            await supabase
                .from('attendance')
                .update({
                  'pic_out': getUrl,
                })
                .eq("employee_id", supabase.auth.currentUser!.id)
                .eq('date', todayDate);

            setState(() {
              isUploading2 = false;
              flagborrar = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Foto cargada correctamente"),
              backgroundColor: Colors.green,
            ));
          } catch (e) {
            print("ERRROR : $e");
            setState(() {
              isUploading2 = false;
              Future.delayed(
                Duration(seconds: segundos),
                () => key.currentState?.reset(),
              );
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Algo ha salido mal, intentelo nuevamente"),
              backgroundColor: Colors.red,
            ));
          }
        }
      }
    } else if (kIsWeb) {
      var pickedFileweb = await picker.pickImage(
          source: ImageSource.camera, imageQuality: imageq);
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
            isUploading2 = true;
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
              .from('imageip')
              .uploadBinary(
                  "${supabase.auth.currentUser!.id}/$fecharuta/$fileName",
                  pickedFile);
          String urllisto = uploadedUrl.replaceAll("imageip/", "");
          final getUrl =
              supabase.storage.from('imageip').getPublicUrl(urllisto);
          await supabase
              .from('attendance')
              .update({
                //'employee_id': supabase.auth.currentUser!.id,
                // 'date': DateFormat("dd MMMM yyyy").format(DateTime.now()),
                'pic_out': getUrl,
              })
              .eq("employee_id", supabase.auth.currentUser!.id)
              .eq('date', todayDate);

          setState(() {
            isUploading2 = false;
            flagborrar = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Foto cargada correctamente !"),
            backgroundColor: Colors.green,
          ));
        } catch (e) {
          // print("ERRROR : $e");
          setState(() {
            isUploading2 = false;

            Future.delayed(
              Duration(seconds: segundos),
              () => key.currentState?.reset(),
            );
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
              .from('imageip')
              .uploadBinary(
                  "${supabase.auth.currentUser!.id}/$fecharuta/$fileName",
                  pickedFile);
          String urllisto = uploadedUrl.replaceAll("imageip/", "");
          final getUrl =
              supabase.storage.from('imageip').getPublicUrl(urllisto);
          await supabase
              .from('attendance')
              .update({
                'pic_out': getUrl,
              })
              .eq("employee_id", supabase.auth.currentUser!.id)
              .eq('date', todayDate);

          setState(() {
            isUploading2 = false;
            flagborrar = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Foto cargada correctamente !"),
            backgroundColor: Colors.green,
          ));
        } catch (e) {
          // print("ERRROR : $e");
          setState(() {
            isUploading2 = false;
            Future.delayed(
              Duration(seconds: segundos),
              () => key.currentState?.reset(),
            );
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Algo ha salido mal"),
            backgroundColor: Colors.red,
          ));
        }
      }
    }
  }

  Future choiceImage3() async {
    if (!kIsWeb) {
      var pickedFile = await picker.pickImage(
          source: ImageSource.camera, imageQuality: imageq);
      if (pickedFile != null) {
        await subirubi.markAttendance3(context);
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
            isUploading3 = true;
          });
          String fecharuta =
              DateFormat("ddMMMMyyyy").format(DateTime.now()).toString();
          DateTime now = DateTime.now();
          String fileName =
              DateFormat('yyyy-MM-dd_HH-mm-ss').format(now) + '.jpg';
          try {
            String uploadedUrl = await supabase.storage.from('imageip').upload(
                "${supabase.auth.currentUser!.id}/$fecharuta/$fileName",
                _images!);
            String urllisto = uploadedUrl.replaceAll("imageip/", "");
            getUrl = supabase.storage.from('imageip').getPublicUrl(urllisto);
            await supabase
                .from('attendance')
                .update({
                  // 'employee_id': supabase.auth.currentUser!.id,
                  // 'date': DateFormat("dd MMMM yyyy").format(DateTime.now()),
                  'pic_in2': getUrl,
                })
                .eq("employee_id", supabase.auth.currentUser!.id)
                .eq('date', todayDate);
            setState(() {
              isUploading3 = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Foto cargada correctamente"),
              backgroundColor: Colors.green,
            ));
          } catch (e) {
            print("ERRROR : $e");
            setState(() {
              isUploading3 = false;
              Future.delayed(
                Duration(seconds: segundos),
                () => key.currentState?.reset(),
              );
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Algo ha salido, intentelo nuevamente"),
              backgroundColor: Colors.red,
            ));
          }
        } else {
          _images = File(pickedFile.path);
          File? imagescom =
              await customCompressed(imagePathToCompress: _images);
          _images = File(imagescom.path);
          setState(() {
            isUploading3 = true;
          });
          String fecharuta =
              DateFormat("ddMMMMyyyy").format(DateTime.now()).toString();
          DateTime now = DateTime.now();
          String fileName =
              DateFormat('yyyy-MM-dd_HH-mm-ss').format(now) + '.jpg';
          try {
            String uploadedUrl = await supabase.storage.from('imageip').upload(
                "${supabase.auth.currentUser!.id}/$fecharuta/$fileName",
                _images!);
            String urllisto = uploadedUrl.replaceAll("imageip/", "");
            getUrl = supabase.storage.from('imageip').getPublicUrl(urllisto);
            await supabase
                .from('attendance')
                .update({
                  'pic_in2': getUrl,
                })
                .eq("employee_id", supabase.auth.currentUser!.id)
                .eq('date', todayDate);

            setState(() {
              isUploading3 = false;
              flagborrar = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Foto cargada correctamente"),
              backgroundColor: Colors.green,
            ));
          } catch (e) {
            print("ERRROR : $e");
            setState(() {
              isUploading3 = false;
              Future.delayed(
                Duration(seconds: segundos),
                () => key2.currentState?.reset(),
              );
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Algo ha salido mal, intentelo nuevamente"),
              backgroundColor: Colors.red,
            ));
          }
        }
      }
    } else if (kIsWeb) {
      var pickedFileweb = await picker.pickImage(
          source: ImageSource.camera, imageQuality: imageq);
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
            isUploading3 = true;
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
              .from('imageip')
              .uploadBinary(
                  "${supabase.auth.currentUser!.id}/$fecharuta/$fileName",
                  pickedFile);
          String urllisto = uploadedUrl.replaceAll("imageip/", "");
          final getUrl =
              supabase.storage.from('imageip').getPublicUrl(urllisto);
          await supabase
              .from('attendance')
              .update({
                //'employee_id': supabase.auth.currentUser!.id,
                // 'date': DateFormat("dd MMMM yyyy").format(DateTime.now()),
                'pic_in2': getUrl,
              })
              .eq("employee_id", supabase.auth.currentUser!.id)
              .eq('date', todayDate);

          setState(() {
            isUploading3 = false;
            flagborrar = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Foto cargada correctamente !"),
            backgroundColor: Colors.green,
          ));
        } catch (e) {
          // print("ERRROR : $e");
          setState(() {
            isUploading3 = false;
            Future.delayed(
              Duration(seconds: segundos),
              () => key2.currentState?.reset(),
            );
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
              .from('imageip')
              .uploadBinary(
                  "${supabase.auth.currentUser!.id}/$fecharuta/$fileName",
                  pickedFile);
          String urllisto = uploadedUrl.replaceAll("imageip/", "");
          final getUrl =
              supabase.storage.from('imageip').getPublicUrl(urllisto);
          await supabase
              .from('attendance')
              .update({
                'pic_in2': getUrl,
              })
              .eq("employee_id", supabase.auth.currentUser!.id)
              .eq('date', todayDate);

          setState(() {
            isUploading3 = false;
            flagborrar = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Foto cargada correctamente !"),
            backgroundColor: Colors.green,
          ));
        } catch (e) {
          // print("ERRROR : $e");
          setState(() {
            isUploading3 = false;
            Future.delayed(
              Duration(seconds: segundos),
              () => key2.currentState?.reset(),
            );
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Algo ha salido mal"),
            backgroundColor: Colors.red,
          ));
        }
      }
    }
  }

  Future choiceImage4() async {
    if (!kIsWeb) {
      var pickedFile = await picker.pickImage(
          source: ImageSource.camera, imageQuality: imageq);
      if (pickedFile != null) {
        await subirubi.markAttendance3(context);
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
            isUploading4 = true;
          });
          String fecharuta =
              DateFormat("ddMMMMyyyy").format(DateTime.now()).toString();
          DateTime now = DateTime.now();
          String fileName =
              DateFormat('yyyy-MM-dd_HH-mm-ss').format(now) + '.jpg';
          try {
            String uploadedUrl = await supabase.storage.from('imageip').upload(
                "${supabase.auth.currentUser!.id}/$fecharuta/$fileName",
                _images!);
            String urllisto = uploadedUrl.replaceAll("imageip/", "");
            getUrl = supabase.storage.from('imageip').getPublicUrl(urllisto);
            await supabase
                .from('attendance')
                .update({
                  // 'employee_id': supabase.auth.currentUser!.id,
                  // 'date': DateFormat("dd MMMM yyyy").format(DateTime.now()),
                  'pic_out2': getUrl,
                })
                .eq("employee_id", supabase.auth.currentUser!.id)
                .eq('date', todayDate);
            setState(() {
              isUploading4 = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Foto cargada correctamente"),
              backgroundColor: Colors.green,
            ));
          } catch (e) {
            print("ERRROR : $e");
            setState(() {
              isUploading4 = false;
              Future.delayed(
                Duration(seconds: segundos),
                () => key2.currentState?.reset(),
              );
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Algo ha salido, intentelo nuevamente"),
              backgroundColor: Colors.red,
            ));
          }
        } else {
          _images = File(pickedFile.path);
          File? imagescom =
              await customCompressed(imagePathToCompress: _images);
          _images = File(imagescom.path);
          setState(() {
            isUploading4 = true;
          });
          String fecharuta =
              DateFormat("ddMMMMyyyy").format(DateTime.now()).toString();
          DateTime now = DateTime.now();
          String fileName =
              DateFormat('yyyy-MM-dd_HH-mm-ss').format(now) + '.jpg';
          try {
            String uploadedUrl = await supabase.storage.from('imageip').upload(
                "${supabase.auth.currentUser!.id}/$fecharuta/$fileName",
                _images!);
            String urllisto = uploadedUrl.replaceAll("imageip/", "");
            getUrl = supabase.storage.from('imageip').getPublicUrl(urllisto);
            await supabase
                .from('attendance')
                .update({
                  'pic_out2': getUrl,
                })
                .eq("employee_id", supabase.auth.currentUser!.id)
                .eq('date', todayDate);

            setState(() {
              isUploading4 = false;
              flagborrar = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Foto cargada correctamente"),
              backgroundColor: Colors.green,
            ));
          } catch (e) {
            print("ERRROR : $e");
            setState(() {
              isUploading4 = false;
              Future.delayed(
                Duration(seconds: segundos),
                () => key2.currentState?.reset(),
              );
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Algo ha salido mal, intentelo nuevamente"),
              backgroundColor: Colors.red,
            ));
          }
        }
      }
    } else if (kIsWeb) {
      var pickedFileweb = await picker.pickImage(
          source: ImageSource.camera, imageQuality: imageq);
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
            isUploading4 = true;
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
              .from('imageip')
              .uploadBinary(
                  "${supabase.auth.currentUser!.id}/$fecharuta/$fileName",
                  pickedFile);
          String urllisto = uploadedUrl.replaceAll("imageip/", "");
          final getUrl =
              supabase.storage.from('imageip').getPublicUrl(urllisto);
          await supabase
              .from('attendance')
              .update({
                //'employee_id': supabase.auth.currentUser!.id,
                // 'date': DateFormat("dd MMMM yyyy").format(DateTime.now()),
                'pic_out2': getUrl,
              })
              .eq("employee_id", supabase.auth.currentUser!.id)
              .eq('date', todayDate);

          setState(() {
            isUploading4 = false;
            flagborrar = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Foto cargada correctamente !"),
            backgroundColor: Colors.green,
          ));
        } catch (e) {
          // print("ERRROR : $e");
          setState(() {
            isUploading4 = false;

            Future.delayed(
              Duration(seconds: segundos),
              () => key.currentState?.reset(),
            );
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
              .from('imageip')
              .uploadBinary(
                  "${supabase.auth.currentUser!.id}/$fecharuta/$fileName",
                  pickedFile);
          String urllisto = uploadedUrl.replaceAll("imageip/", "");
          final getUrl =
              supabase.storage.from('imageip').getPublicUrl(urllisto);
          await supabase
              .from('attendance')
              .update({
                'pic_out2': getUrl,
              })
              .eq("employee_id", supabase.auth.currentUser!.id)
              .eq('date', todayDate);

          setState(() {
            isUploading4 = false;
            flagborrar = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Foto cargada correctamente !"),
            backgroundColor: Colors.green,
          ));
        } catch (e) {
          // print("ERRROR : $e");
          setState(() {
            isUploading4 = false;
            Future.delayed(
              Duration(seconds: segundos),
              () => key2.currentState?.reset(),
            );
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Algo ha salido mal"),
            backgroundColor: Colors.red,
          ));
        }
      }
    }
  }

  /*  Future choiceImage4() async {
    if (!kIsWeb) {
      var pickedFile4 = await picker.pickImage(
          source: ImageSource.camera, imageQuality: imageq);
      if (pickedFile4 != null) {
        _images4 = File(pickedFile4.path);
        File? imagescom4 =
            await customCompressed(imagePathToCompress: _images4);
        setState(() {
          isUploading4 = true;
          _imagescom4 = imagescom4;
        });
      }
    } else if (kIsWeb) {
      var pickedFileweb4 = await picker.pickImage(
          source: ImageSource.camera, imageQuality: imageq);
      if (pickedFileweb4 != null) {
        var f4 = await pickedFileweb4.readAsBytes();
        _images4 = File('a');
        setState(() {
          isUploading4 = true;
          webI4 = f4;
        });
      }
    }
  }
 */

/////////////tomar foto y subir//////////////
  /* Future uploadFile(BuildContext context) async {
    if (!kIsWeb) {
      var pickedFile = _imagescom1;
      try {
        _images = File(pickedFile!.path);
        String fecharuta =
            DateFormat("ddMMMMyyyy").format(DateTime.now()).toString();
        DateTime now = DateTime.now();
        String fileName =
            DateFormat('yyyy-MM-dd_HH-mm-ss').format(now) + '.jpg';
        String uploadedUrl = await supabase.storage.from('imageip').upload(
            "${supabase.auth.currentUser!.id}/$fecharuta/$fileName", _images!);
        String urllisto = uploadedUrl.replaceAll("imageip/", "");
        final getUrl = supabase.storage.from('imageip').getPublicUrl(urllisto);
        await supabase.from('attendance').insert({
          'employee_id': supabase.auth.currentUser!.id,
          'date': DateFormat("dd MMMM yyyy").format(DateTime.now()),
          'pic_in': getUrl,
        });
        setState(() {
          isUploading = false;
        });
        // await markasistencia(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Foto cargada correctamente"),
          backgroundColor: Colors.green,
        ));
        await subirubi.markAttendance(context);
      } catch (e) {
        //print("ERRROR : $e");
        setState(() {
          isUploading = false;
          Future.delayed(
            Duration(seconds: segundos),
            () => key.currentState?.reset(),
          );
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Algo ha salido malen carga"),
          backgroundColor: Colors.red,
        ));
      }
    } else if (kIsWeb) {
      setState(() {
        webImage = webI;
      });
      var pickedFile = webImage;
      try {
        String fecharuta =
            DateFormat("ddMMMMyyyy").format(DateTime.now()).toString();
        DateTime now = DateTime.now();
        String fileName =
            DateFormat('yyyy-MM-dd_HH-mm-ss').format(now) + '.jpg';
        String uploadedUrl = await supabase.storage
            .from('imageip')
            .uploadBinary(
                "${supabase.auth.currentUser!.id}/$fecharuta/$fileName",
                pickedFile);
        String urllisto = uploadedUrl.replaceAll("imageip/", "");
        final getUrl = supabase.storage.from('imageip').getPublicUrl(urllisto);
        await supabase.from('attendance').insert({
          'employee_id': supabase.auth.currentUser!.id,
          'date': DateFormat("dd MMMM yyyy").format(DateTime.now()),
          'pic_in': getUrl,
        });

        setState(() {
          isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Foto cargada correctamente !"),
          backgroundColor: Colors.green,
        ));
      } catch (e) {
        // print("ERRROR : $e");
        setState(() {
          isUploading = false;
          Future.delayed(
            Duration(seconds: segundos),
            () => key.currentState?.reset(),
          );
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Algo ha salido mal"),
          backgroundColor: Colors.red,
        ));
      }
    }
  } */

  /* void disableButton() {
    setState(() {
      buttonDisabled = true;
    });
  }
 */

  @override
  void initState() {
    route.Provider.of<AttendanceService>(context, listen: false)
        .getTodayAttendance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final attendanceService = route.Provider.of<AttendanceService>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context) {
          return Container(
            child: Image(
              image: AssetImage('assets/icon/icon.png'),
              height: 20,
            ),
          );
        }),
        title: Text(
          "ArtConsGroup.",
          style: TextStyle(fontSize: 23),
        ),
        actions: [
          Row(
            children: [
              Icon(
                Icons.brightness_2_outlined,
                size: 18, // Icono para tema claro
                color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light
                    ? Colors.grey
                    : Colors.white,
              ),
              Switch(
                  value:
                      AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light,
                  onChanged: (bool value) {
                    if (value) {
                      AdaptiveTheme.of(context).setLight();
                    } else {
                      AdaptiveTheme.of(context).setDark();
                    }
                  }),
              Icon(
                Icons.brightness_low_rounded,
                size: 20, // Icono para tema oscuro
                color: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light
                    ? Colors.white
                    : Colors.grey,
              ),
              SizedBox(width: 10)
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            route.Consumer<DbService>(builder: (context, dbServie, child) {
              return FutureBuilder(
                  future: dbServie.getUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      UserModel user = snapshot.data!;
                      return Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          user.name != ''
                              ? "Hola " + user.name + ","
                              : "Hola" + "#${user.employeeId}" + ",",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                    return const SizedBox(
                      width: 60,
                      child: LinearProgressIndicator(),
                    );
                  });
            }),
            const SizedBox(
              child: Divider(
                thickness: 1,
              ),
            ),
            route.Consumer<DbService>(builder: (context, dbServie, child) {
              return FutureBuilder(
                  future: dbServie.getTodaydep(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      DepartmentModel user2 = snapshot.data!;
                      return Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          user2.title != "" ? user2.title.toString() : " ",
                          style: const TextStyle(fontSize: 13),
                        ),
                      );
                    }

                    return const SizedBox(
                      width: 60,
                      child: LinearProgressIndicator(),
                    );
                  });
            }), //

            const SizedBox(
              child: Divider(
                thickness: 1,
              ),
            ),
            ///////////////fecha/////////////////////
            Container(
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ComentariosPage()));
                  },
                  child: const Text(
                    "¿Has tenido inconvenientes al momento de registrarte?Dejanoslo saber.",
                  )),
            ),
            StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  return Container(
                    alignment: Alignment.center,
                    child: Text(
                      DateFormat("HH:mm:ss").format(DateTime.now()),
                      style: const TextStyle(fontSize: 27),
                    ),
                  );
                }),
            Container(
              alignment: Alignment.center,
              child: Text(
                DateFormat("dd MMMM yyyy").format(DateTime.now()),
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(
              width: 90,
              child: Divider(
                thickness: 1,
              ),
            ),
            //////

            ///////////////hora/////////////////////
            Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.only(top: 5, bottom: 5),
              height: 170,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Ingreso:  ",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              attendanceService.attendanceModel?.checkIn ??
                                  '--/--',
                              style: TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                          width: 80,
                          child: Divider(),
                        ),
                        const SizedBox(
                          height: 7,
                          width: 80,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                    icon: Icon(Icons.add_a_photo),
                                    onPressed: () async {
                                      if (attendanceService
                                              .attendanceModel?.pic_in !=
                                          null) {
                                        getUrl = attendanceService
                                            .attendanceModel!.pic_in
                                            .toString();
                                      }
                                      attendanceService
                                                  .attendanceModel?.checkIn ==
                                              null
                                          ? attendanceService.attendanceModel
                                                          ?.pic_in ==
                                                      null ||
                                                  attendanceService
                                                          .attendanceModel
                                                          ?.pic_in
                                                          .toString() ==
                                                      "NULL"
                                              ? await choiceImage() // foto 1
                                              : await attendanceService
                                                  .markAttendance3(context)
                                          : await attendanceService
                                              .markAttendance3(context);
                                      await attendanceService
                                          .markAttendance3(context);
                                    }),
                                IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.grey,
                                    onPressed: () async {
                                      setState(() {
                                        getUrl = attendanceService
                                            .attendanceModel!.pic_in
                                            .toString();
                                      });

                                      if (attendanceService
                                                  .attendanceModel?.checkIn ==
                                              null &&
                                          attendanceService
                                                  .attendanceModel?.pic_in !=
                                              null) {
                                        await borrar('pic_in', getUrl);
                                        setState(() {
                                          attendanceService
                                              .markAttendance3(context);
                                        });
                                      }
                                      setState(() {
                                        attendanceService
                                            .markAttendance3(context);
                                      });

                                      print("borrarrr"); // disableButton();
                                    }),
                              ],
                            ),
                            Container(
                              child: attendanceService
                                          .attendanceModel?.pic_in ==
                                      null
                                  ? Icon(Icons.photo)
                                  : attendanceService.attendanceModel?.pic_in ==
                                          "NULL"
                                      ? isUploading == true
                                          ? const CircularProgressIndicator()
                                          : Icon(Icons.photo)
                                      : isUploading == true
                                          ? const CircularProgressIndicator()
                                          : Container(
                                              height: 115,
                                              width: 90,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)),
                                                image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image:
                                                      CachedNetworkImageProvider(
                                                    attendanceService
                                                        .attendanceModel!.pic_in
                                                        .toString(),
                                                  ),
                                                ),
                                              ),
                                            ),
                            ),
                          ],
                        )
                        //container
                      ],
                    )), //expanded
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Salida:  ",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                /*color: Colors.black5*/
                              ),
                            ),
                            Text(
                              attendanceService.attendanceModel?.checkOut ??
                                  '--/--',
                              style: TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                          width: 80,
                          child: Divider(),
                        ),
                        const SizedBox(
                          height: 6,
                          width: 80,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                    icon: Icon(Icons.add_a_photo),
                                    onPressed: () async {
                                      getUrl = attendanceService
                                          .attendanceModel!.pic_out
                                          .toString();
                                      attendanceService.attendanceModel
                                                      ?.checkIn !=
                                                  null &&
                                              attendanceService.attendanceModel
                                                      ?.checkOut ==
                                                  null
                                          ? attendanceService.attendanceModel
                                                          ?.pic_out ==
                                                      null ||
                                                  attendanceService
                                                          .attendanceModel
                                                          ?.pic_out
                                                          .toString() ==
                                                      "NULL"
                                              ? await choiceImage2()
                                              : attendanceService
                                                  .markAttendance3(context)
                                          : attendanceService
                                              .markAttendance3(context);
                                      attendanceService
                                          .markAttendance3(context);
                                    }),
                                IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.grey,
                                    onPressed: () async {
                                      setState(() {
                                        getUrl = attendanceService
                                            .attendanceModel!.pic_out
                                            .toString();
                                      });

                                      if (attendanceService
                                                  .attendanceModel?.checkOut ==
                                              null &&
                                          attendanceService
                                                  .attendanceModel?.pic_out !=
                                              null) {
                                        await borrar('pic_out', getUrl);
                                        setState(() {
                                          attendanceService
                                              .markAttendance3(context);
                                        });
                                      }
                                      attendanceService
                                          .markAttendance3(context);
                                      print("borrarrr");
                                    }),
                              ],
                            ),
                            Container(
                              child: attendanceService
                                          .attendanceModel?.pic_out ==
                                      null
                                  ? Icon(Icons.photo)
                                  : attendanceService
                                              .attendanceModel?.pic_out ==
                                          "NULL"
                                      ? isUploading2 == true
                                          ? const CircularProgressIndicator()
                                          : Icon(Icons.photo)
                                      : isUploading2 == true
                                          ? const CircularProgressIndicator()
                                          : Container(
                                              height: 115,
                                              width: 90,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)),
                                                image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image:
                                                      CachedNetworkImageProvider(
                                                    attendanceService
                                                        .attendanceModel!
                                                        .pic_out
                                                        .toString(),
                                                  ),
                                                ),
                                              ),
                                            ),
                            ),
                          ],
                        ),
                      ],
                    )),
                  ]),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Builder(builder: (context) {
                return SlideAction(
                  height: 60,
                  text: (attendanceService.attendanceModel?.checkIn != null &&
                          attendanceService.attendanceModel?.checkOut != null)
                      ? "Registro Exitoso. Gracias"
                      : (attendanceService.attendanceModel?.checkIn == null)
                          ? "Registrar el ingreso"
                          : "Registrar la salida",
                  //alignment: Alignment.topCenter,
                  animationDuration: Duration(milliseconds: 200),
                  textStyle: TextStyle(
                    fontSize: 16,
                    // color: Theme.of(context).brightness == Brightness.light
                    //     ? Colors.black
                    //     : Colors.white
                  ),
                  outerColor: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Color(0xFF2B2929),

                  //   innerColor: Colors.red,
                  key: key,
                  onSubmit: () async {
                    if (attendanceService.attendanceModel?.checkIn != null &&
                        attendanceService.attendanceModel?.checkOut != null) {
                      _mostrarAlerta(
                          context, "Asistencia exitosamente subida.");
                    } else if (attendanceService.attendanceModel?.checkIn ==
                            null &&
                        attendanceService.attendanceModel?.pic_in != "NULL" &&
                        attendanceService.attendanceModel?.pic_in != null) {
                      final bool flat =
                          await attendanceService.markAttendance(context);
                      flat == true
                          ? key.currentState!.reset()
                          : key.currentState;
                    } else if (attendanceService.attendanceModel?.pic_in ==
                        null) {
                      _mostrarAlerta(context, "Suba una foto por favor.");
                    } else if (attendanceService.attendanceModel?.pic_out !=
                            null &&
                        attendanceService.attendanceModel?.pic_out != "NULL") {
                      await attendanceService.markAttendance(context);
                    } else {
                      _mostrarAlerta(context, "Suba una foto por favor.");
                    }

                    key.currentState!.reset();
                  },
                );
              }),
            ),
            Container(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.only(top: 5, bottom: 10),
              height: 170,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  //     ? Colors.white
                  //     //  color: Colors.white,
                  //     : Color.fromARGB(255, 43, 41, 41),
                  // boxShadow: [
                  //   BoxShadow(
                  //       color: Color.fromARGB(110, 18, 148, 255),
                  //       blurRadius: 5,
                  //       offset: Offset(1, 1)),
                  // ],
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Entrada:  ",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              attendanceService.attendanceModel?.checkIn2 ??
                                  '--/--',
                              style: TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                          width: 80,
                          child: Divider(),
                        ),
                        const SizedBox(
                          height: 5,
                          width: 80,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                    icon: Icon(Icons.add_a_photo),
                                    onPressed: () async {
                                      getUrl = attendanceService
                                          .attendanceModel!.pic_in2
                                          .toString();
                                      (attendanceService.attendanceModel
                                                      ?.checkOut !=
                                                  null &&
                                              attendanceService.attendanceModel
                                                      ?.checkIn2 ==
                                                  null)
                                          ? attendanceService.attendanceModel
                                                          ?.pic_in2 ==
                                                      null ||
                                                  attendanceService
                                                          .attendanceModel
                                                          ?.pic_in2
                                                          .toString() ==
                                                      "NULL"
                                              ? await choiceImage3()
                                              : attendanceService
                                                  .markAttendance3(context)
                                          : attendanceService
                                              .markAttendance3(context);

                                      attendanceService
                                          .markAttendance3(context);
                                    }),
                                IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.grey,
                                    onPressed: () async {
                                      setState(() {
                                        getUrl = attendanceService
                                            .attendanceModel!.pic_in2
                                            .toString();
                                      });

                                      if (attendanceService
                                                  .attendanceModel?.checkIn2 ==
                                              null &&
                                          attendanceService
                                                  .attendanceModel?.pic_in2 !=
                                              null) {
                                        await borrar('pic_in2', getUrl);
                                        setState(() {
                                          attendanceService
                                              .markAttendance3(context);
                                        });
                                      }
                                      attendanceService
                                          .markAttendance3(context);
                                      print("borrarrr"); // disableButton();
                                    })
                              ],
                            ),
                            Container(
                              child: attendanceService
                                          .attendanceModel?.pic_in2 ==
                                      null
                                  ? Icon(Icons.photo)
                                  : attendanceService
                                              .attendanceModel?.pic_in2 ==
                                          "NULL"
                                      ? isUploading3 == true
                                          ? const CircularProgressIndicator()
                                          : Icon(Icons.photo)
                                      : isUploading3 == true
                                          ? const CircularProgressIndicator()
                                          : Container(
                                              height: 115,
                                              width: 90,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)),
                                                image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image:
                                                      CachedNetworkImageProvider(
                                                    attendanceService
                                                        .attendanceModel!
                                                        .pic_in2
                                                        .toString(),
                                                  ),
                                                ),
                                              ),
                                            ),
                            ),
                          ],
                        )
                      ],
                    )),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Salida:  ",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                /*color: Colors.black5*/
                              ),
                            ),
                            Text(
                              attendanceService.attendanceModel?.checkOut2 ??
                                  '--/--',
                              style: TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                          width: 80,
                          child: Divider(),
                        ),
                        const SizedBox(
                          height: 5,
                          width: 80,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                    icon: Icon(Icons.add_a_photo),
                                    onPressed: () async {
                                      getUrl = attendanceService
                                          .attendanceModel!.pic_out2
                                          .toString();
                                      (attendanceService.attendanceModel
                                                      ?.checkIn2 !=
                                                  null &&
                                              attendanceService.attendanceModel
                                                      ?.checkOut2 ==
                                                  null)
                                          ? attendanceService.attendanceModel
                                                          ?.pic_out2 ==
                                                      null ||
                                                  attendanceService
                                                          .attendanceModel
                                                          ?.pic_out2
                                                          .toString() ==
                                                      "NULL"
                                              ? await choiceImage4()
                                              : attendanceService
                                                  .markAttendance3(context)
                                          : attendanceService
                                              .markAttendance3(context);

                                      attendanceService
                                          .markAttendance3(context);
                                    }),
                                IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.grey,
                                    onPressed: () async {
                                      setState(() {
                                        getUrl = attendanceService
                                            .attendanceModel!.pic_out2
                                            .toString();
                                      });

                                      if (attendanceService
                                                  .attendanceModel?.checkOut2 ==
                                              null &&
                                          attendanceService
                                                  .attendanceModel?.pic_out2 !=
                                              null) {
                                        await borrar('pic_out2', getUrl);
                                        setState(() {
                                          attendanceService
                                              .markAttendance3(context);
                                        });
                                      }
                                      attendanceService
                                          .markAttendance3(context);
                                      print("borrarrr"); // disableButton();
                                    })
                              ],
                            ),
                            Container(
                              child: attendanceService
                                          .attendanceModel?.pic_out2 ==
                                      null
                                  ? Icon(Icons.photo)
                                  : attendanceService
                                              .attendanceModel?.pic_out2 ==
                                          "NULL"
                                      ? isUploading4 == true
                                          ? const CircularProgressIndicator()
                                          : Icon(Icons.photo)
                                      : isUploading4 == true
                                          ? const CircularProgressIndicator()
                                          : Container(
                                              height: 115,
                                              width: 90,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)),
                                                image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image:
                                                      CachedNetworkImageProvider(
                                                    attendanceService
                                                        .attendanceModel!
                                                        .pic_out2
                                                        .toString(),
                                                  ),
                                                ),
                                              ),
                                            ),
                            ),
                          ],
                        )
                      ],
                    )),
                  ]),
            ),
            ///////////////////////////////////fotos//////////////
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Builder(builder: (context) {
                return SlideAction(
                  animationDuration: Duration(milliseconds: 200),
                  text: (attendanceService.attendanceModel?.checkIn2 != null &&
                          attendanceService.attendanceModel?.checkOut2 != null)
                      ? "Registro Exitoso Gracias"
                      : (attendanceService.attendanceModel?.checkIn2 == null)
                          ? "Registrar el ingreso"
                          : "Registrar la salida",
                  //alignment: Alignment.topCenter,
                  height: 60,
                  textStyle: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white),
                  outerColor: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Color(0xFF2B2929),
                  // innerColor: ,
                  key: key2,
                  onSubmit: () async {
                    if (attendanceService.attendanceModel?.checkIn2 != null &&
                        attendanceService.attendanceModel?.checkOut2 != null) {
                      _mostrarAlerta(
                          context, "Asistencia subida exitosamente.");
                    } else if (attendanceService.attendanceModel?.checkIn2 ==
                            null &&
                        attendanceService.attendanceModel?.pic_in2 != null) {
                      await attendanceService.markAttendance2(context);
                    } else if (attendanceService.attendanceModel?.checkIn2 ==
                        null) {
                      _mostrarAlerta(context, "Suba una foto por favor.");
                    } else if (attendanceService.attendanceModel?.pic_out2 !=
                        null) {
                      await attendanceService.markAttendance2(context);
                    } else {
                      _mostrarAlerta(context, "Suba una foto por favor.");
                    }
                    key2.currentState!.reset();
                  },
                  /* onSubmit: () async {
                     if (attendanceService.attendanceModel?.checkIn2 != null &&
                        attendanceService.attendanceModel?.checkOut2 != null) {
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.warning,
                          title: 'Suba',
                          text: 'una foto por favor');
                    } else {
                      (attendanceService.attendanceModel?.checkIn2 == null
                          ? (_images3 != null
                              ? (await attendanceService
                                  .markAttendance2(context))
                              : QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.warning,
                                  title: 'Suba',
                                  text: 'una foto por favor'))
                          : _images4 != null
                              ? (await attendanceService
                                  .markAttendance2(context))
                              : QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.warning,
                                  title: 'Suba ',
                                  text: 'una foto por favor'));
                      attendanceService.attendanceModel?.checkIn2 == null
                          ? (_images3 != null
                              ? uploadFile3()
                              : _images4 != null
                                  ? uploadFile4()
                                  : print("mal11"))
                          : _images4 != null
                              ? uploadFile4()
                              : print("mal22");
                    }
                    key2.currentState!.reset();
                  },*/
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

void _mostrarAlerta(BuildContext context, String titulo) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
            // elevation: 1,
            // alignment: Alignment.center,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17.0),
            ),
            title: Text(titulo, textAlign: TextAlign.center),
            actions: [
              TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          ));
}
