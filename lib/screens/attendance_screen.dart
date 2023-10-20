import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:employee_attendance/constants/gaps.dart';
import 'package:employee_attendance/examples/value_notifier/warning_widget_value_notifier.dart';
import 'package:employee_attendance/models/department_model.dart';
import 'package:employee_attendance/models/user_model.dart';
import 'package:employee_attendance/screens/observaciones/observaciones_page.dart';
import 'package:employee_attendance/services/attendance_service.dart';
import 'package:employee_attendance/services/db_service.dart';
import 'package:employee_attendance/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart' as route;
import 'package:slide_to_act/slide_to_act.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final GlobalKey<SlideActionState> key = GlobalKey<SlideActionState>();
  final GlobalKey<SlideActionState> key2 = GlobalKey<SlideActionState>();
  String todayDate = DateFormat("dd MMMM yyyy", "es_ES").format(DateTime.now());
  final SupabaseClient supabase = Supabase.instance.client;
  final AttendanceService subirubi = AttendanceService();
  bool _estacargandofoto = false;
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
  var pad16 = 16.0;
  var pad8 = 8.0;
  var pad4 = 4.0;
  var lineSizeancho = 60.0;
  var grosorDivider = 1.0;
  var margenSuperior = 5.0;
  var margenInferior = 5.0;
  var margenPanelfotos2 = 0.0;
  var anchoSizedivider = 80.0;
  var altoSlider = 55.0;
  var elevacion = 3.0;
  var altoImagen = 126.0;
  int imageq = 100;
  int qt = 85;
  int per = 15;
  final picker = ImagePicker();
  dynamic _images;
  Uint8List webImage = Uint8List(8);

  Future borrar(String tipoimagen, String imageName) async {
    if (imageName != "NULL") {
      String url2 = imageName.split('/')[9].toString();
      String url3 = imageName.split('/')[10].toString();
      try {
        await supabase.storage
            .from('imageip')
            .remove([supabase.auth.currentUser!.id + "/" + url2 + "/" + url3]);

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

  Future choiceImage() async {
    if (!kIsWeb) {
      var pickedFile = await picker.pickImage(
          source: ImageSource.camera, imageQuality: imageq);
      setState(() => _estacargandofoto = true);
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
          setState(() => isUploading = true);
          String fecharuta = DateFormat("ddMMMMyyyy", "es_ES")
              .format(DateTime.now())
              .toString();
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
              'date':
                  DateFormat("dd MMMM yyyy", "es_ES").format(DateTime.now()),
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
            //print("ERRROR : $e");
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
          String fecharuta = DateFormat("ddMMMMyyyy", "es_ES")
              .format(DateTime.now())
              .toString();
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
            //  print("ERRROR : $e");
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
        setState(() => _estacargandofoto = false);
      }
      setState(() => _estacargandofoto = false);
    } else if (kIsWeb) {
      var pickedFileweb = await picker.pickImage(
          source: ImageSource.camera, imageQuality: imageq);
      setState(() => _estacargandofoto = true);
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
            DateFormat("ddMMMMyyyy", "es_ES").format(DateTime.now()).toString();
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
            'date': DateFormat("dd MMMM yyyy", "es_ES").format(DateTime.now()),
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
            DateFormat("ddMMMMyyyy", "es_ES").format(DateTime.now()).toString();
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

      setState(() => _estacargandofoto = false);
    }
    setState(() => _estacargandofoto = false);
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
          String fecharuta = DateFormat("ddMMMMyyyy", "es_ES")
              .format(DateTime.now())
              .toString();
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
            // print("ERRROR : $e");
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
          String fecharuta = DateFormat("ddMMMMyyyy", "es_ES")
              .format(DateTime.now())
              .toString();
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
            // print("ERRROR : $e");
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
            DateFormat("ddMMMMyyyy", "es_ES").format(DateTime.now()).toString();
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
            DateFormat("ddMMMMyyyy", "es_ES").format(DateTime.now()).toString();
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
      await subirubi.markAttendance3(context);
      if (getUrl == "NULL") {
        setState(() {
          flagborrar = true;
        });
      }
      if (pickedFile != null) {
        if (flagborrar == false) {
          _images = File(pickedFile.path);
          File? imagescom =
              await customCompressed(imagePathToCompress: _images);
          _images = File(imagescom.path);
          setState(() {
            isUploading3 = true;
          });
          String fecharuta = DateFormat("ddMMMMyyyy", "es_ES")
              .format(DateTime.now())
              .toString();
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
            // print("ERRROR : $e");
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
          String fecharuta = DateFormat("ddMMMMyyyy", "es_ES")
              .format(DateTime.now())
              .toString();
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
            //print("ERRROR : $e");
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
            DateFormat("ddMMMMyyyy", "es_ES").format(DateTime.now()).toString();
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
            DateFormat("ddMMMMyyyy", "es_ES").format(DateTime.now()).toString();
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
          String fecharuta = DateFormat("ddMMMMyyyy", "es_ES")
              .format(DateTime.now())
              .toString();
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
            // print("ERRROR : $e");
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
          String fecharuta = DateFormat("ddMMMMyyyy", "es_ES")
              .format(DateTime.now())
              .toString();
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
            // print("ERRROR : $e");
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
            DateFormat("ddMMMMyyyy", "es_ES").format(DateTime.now()).toString();
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
            DateFormat("ddMMMMyyyy", "es_ES").format(DateTime.now()).toString();
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
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(pad16, pad4, pad16, pad4),
          child: Column(
            children: [
              WarningWidgetValueNotifier(),
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
                                ? 'Hola ${user.name},'
                                : 'Hola #${user.employeeId},',
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                      return SizedBox(
                        width: lineSizeancho,
                        child: LinearProgressIndicator(),
                      );
                    });
              }),
              gapH8,
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
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      }
                      return SizedBox(
                        width: lineSizeancho,
                        child: LinearProgressIndicator(),
                      );
                    });
              }), //
              Divider(),
              StreamBuilder(
                  stream: Stream.periodic(const Duration(seconds: 1)),
                  builder: (context, snapshot) {
                    return Container(
                      alignment: Alignment.center,
                      child: Text(
                        DateFormat("HH:mm:ss").format(DateTime.now()),
                        style: TextStyle(
                            fontSize: sizeiconobar27,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    );
                  }),
              Container(
                alignment: Alignment.center,
                child: Text(
                  DateFormat("dd MMMM yyyy", "es_ES").format(DateTime.now()),
                  style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
              /* Container(
                alignment: Alignment.topRight,
                child: TextButton.icon(
                    onPressed: () async {
                      attendanceService.markAttendance3(context);
                      key.currentState!.reset();
                      print('ed');
                      String supabaseUrl =
                          'https://glknpzlrktillummmbrr.supabase.co';
                      String supabaseKey =
                          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imdsa25wemxya3RpbGx1bW1tYnJyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODM1MjE4MzMsImV4cCI6MTk5OTA5NzgzM30.gKrH4NNsIPZeDqys4BbQz0IU187EXU-g0WGXbxqAaKU';
+
                          url: supabaseUrl, anonKey: supabaseKey);
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text("Salir")),
              ), */
              gapH4,
              Container(
                margin: EdgeInsets.only(
                    top: margenSuperior,
                    bottom: margenInferior,
                    left: margenPanelfotos2,
                    right: margenPanelfotos2),
                height: altoContainer,
                decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        //  color: Colors.white,
                        : Color.fromARGB(255, 43, 41, 41),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(110, 18, 148, 255),
                          blurRadius: 5,
                          offset: Offset(1, 1)),
                    ],
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
                          gapH4,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Ingreso:  ",
                                style: TextStyle(
                                  fontSize: sizesalin,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                attendanceService.attendanceModel?.checkIn ??
                                    '--/--',
                                style: TextStyle(fontSize: sizeresul17),
                              ),
                            ],
                          ),
                          gapH4,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                      icon: Icon(Icons.add_a_photo),
                                      onPressed: _estacargandofoto
                                          ? null
                                          : () async {
                                              if (attendanceService
                                                      .attendanceModel
                                                      ?.pic_in !=
                                                  null) {
                                                getUrl = attendanceService
                                                    .attendanceModel!.pic_in
                                                    .toString();
                                              }
                                              attendanceService.attendanceModel
                                                          ?.checkIn ==
                                                      null
                                                  ? attendanceService
                                                                  .attendanceModel
                                                                  ?.pic_in ==
                                                              null ||
                                                          attendanceService
                                                                  .attendanceModel
                                                                  ?.pic_in
                                                                  .toString() ==
                                                              "NULL"
                                                      ? await choiceImage()
                                                      : await attendanceService
                                                          .markAttendance3(
                                                              context)
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
                                      }),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: attendanceService
                                            .attendanceModel?.pic_in ==
                                        null
                                    ? Icon(Icons.photo)
                                    : attendanceService
                                                .attendanceModel?.pic_in ==
                                            "NULL"
                                        ? isUploading == true
                                            ? const CircularProgressIndicator()
                                            : Icon(Icons.photo)
                                        : isUploading == true
                                            ? const CircularProgressIndicator()
                                            : CachedNetworkImage(
                                                imageUrl: attendanceService
                                                    .attendanceModel!.pic_in
                                                    .toString(),
                                                height: altoImagen,
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
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
                          gapH4,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Salida:  ",
                                style: TextStyle(
                                  fontSize: sizesalin,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                attendanceService.attendanceModel?.checkOut ??
                                    '--/--',
                                style: TextStyle(fontSize: sizeresul17),
                              ),
                            ],
                          ),
                          gapH4,
                          Row(
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
                                                attendanceService
                                                        .attendanceModel
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

                                        if (attendanceService.attendanceModel
                                                    ?.checkOut ==
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
                                      }),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
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
                                            : CachedNetworkImage(
                                                imageUrl: attendanceService
                                                    .attendanceModel!.pic_out
                                                    .toString(),
                                                height: altoImagen,
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                              ),
                            ],
                          ),
                        ],
                      )),
                    ]),
              ),

              gapH4,
              Container(
                margin: EdgeInsets.only(bottom: margenInferior),
                child: Builder(builder: (context) {
                  return SlideAction(
                    sliderButtonIconSize: slideiconsize15,
                    innerColor: Theme.of(context).colorScheme.primary,
                    elevation: elevacion,
                    height: altoSlider,
                    text: (attendanceService.attendanceModel?.checkIn != null &&
                            attendanceService.attendanceModel?.checkOut != null)
                        ? "Gracias por completar el registro"
                        : (attendanceService.attendanceModel?.checkIn == null)
                            ? "Registre el ingreso"
                            : "Registre la salida",
                    //alignment: Alignment.topCenter,
                    animationDuration: Duration(milliseconds: 200),
                    textStyle: TextStyle(
                        fontSize: sizecomentarios16,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white),
                    outerColor: Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : Color(0xFF2B2929),
                    //   innerColor: Colors.red,
                    key: key,
                    onSubmit: () async {
                      try {
                        if (attendanceService.attendanceModel?.checkIn !=
                                null &&
                            attendanceService.attendanceModel?.checkOut !=
                                null) {
                          _mostrarAlerta(
                              context, "Asistencia exitosamente subida.");
                        } else if (attendanceService.attendanceModel?.checkIn ==
                                null &&
                            attendanceService.attendanceModel?.pic_in !=
                                "NULL" &&
                            attendanceService.attendanceModel?.pic_in != null) {
                          await attendanceService.markAttendance(context);
                        } else if (attendanceService.attendanceModel?.pic_in ==
                            null) {
                          _mostrarAlerta(context, "Suba una foto por favor.");
                        } else if (attendanceService.attendanceModel?.pic_out !=
                                null &&
                            attendanceService.attendanceModel?.pic_out !=
                                "NULL") {
                          await attendanceService.markAttendance(context);
                        } else {
                          _mostrarAlerta(context, "Suba una foto por favor.");
                        }
                        key.currentState!.reset();
                      } catch (e) {
                        Utils.showSnackBar("$e", context);
                      }
                    },
                  );
                }),
              ),
              gapH4,
              Container(
                margin: EdgeInsets.only(
                    top: margenSuperior,
                    bottom: margenInferior,
                    left: margenPanelfotos2,
                    right: margenPanelfotos2),
                height: altoContainer,
                decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.white //  color: Colors.white,
                        : Color.fromARGB(255, 43, 41, 41),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(110, 18, 148, 255),
                          blurRadius: 5,
                          offset: Offset(1, 1)),
                    ],
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
                          gapH4,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Ingreso:  ",
                                style: TextStyle(
                                  fontSize: sizesalin,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                attendanceService.attendanceModel?.checkIn2 ??
                                    '--/--',
                                style: TextStyle(fontSize: sizeresul17),
                              ),
                            ],
                          ),
                          gapH4,
                          Row(
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
                                                attendanceService
                                                        .attendanceModel
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

                                        if (attendanceService.attendanceModel
                                                    ?.checkIn2 ==
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
                                        // disableButton();
                                      })
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
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
                                            : CachedNetworkImage(
                                                imageUrl: attendanceService
                                                    .attendanceModel!.pic_in2
                                                    .toString(),
                                                height: altoImagen,
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
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
                          gapH4,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Salida:  ",
                                style: TextStyle(
                                  fontSize: sizesalin,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                attendanceService.attendanceModel?.checkOut2 ??
                                    '--/--',
                                style: TextStyle(fontSize: sizeresul17),
                              ),
                            ],
                          ),
                          gapH4,
                          Row(
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
                                                attendanceService
                                                        .attendanceModel
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

                                        if (attendanceService.attendanceModel
                                                    ?.checkOut2 ==
                                                null &&
                                            attendanceService.attendanceModel
                                                    ?.pic_out2 !=
                                                null) {
                                          await borrar('pic_out2', getUrl);
                                          setState(() {
                                            attendanceService
                                                .markAttendance3(context);
                                          });
                                        }
                                        attendanceService
                                            .markAttendance3(context);
                                        // disableButton();
                                      })
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
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
                                            : CachedNetworkImage(
                                                imageUrl: attendanceService
                                                    .attendanceModel!.pic_out2
                                                    .toString(),
                                                height: altoImagen,
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                              ),
                            ],
                          )
                        ],
                      )),
                    ]),
              ),
              ///////////////////////////////////fotos//////////////

              gapH4,
              Container(
                margin: EdgeInsets.only(bottom: margenInferior),
                child: Builder(builder: (context) {
                  return SlideAction(
                    elevation: elevacion,
                    innerColor: Theme.of(context).colorScheme.primary,
                    sliderButtonIconSize: slideiconsize15,
                    animationDuration: Duration(milliseconds: 200),
                    text: (attendanceService.attendanceModel?.checkIn2 !=
                                null &&
                            attendanceService.attendanceModel?.checkOut2 !=
                                null)
                        ? "Gracias por completar el registro"
                        : (attendanceService.attendanceModel?.checkIn2 == null)
                            ? "Registre el ingreso"
                            : "Registre la salida",
                    //alignment: Alignment.topCenter,
                    height: altoSlider,
                    textStyle: TextStyle(
                        fontSize: sizecomentarios16,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white),
                    outerColor: Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : Color(0xFF2B2929),
                    // innerColor: ,
                    key: key2,
                    onSubmit: () async {
                      try {
                        if (attendanceService.attendanceModel?.checkIn2 !=
                                null &&
                            attendanceService.attendanceModel?.checkOut2 !=
                                null) {
                          _mostrarAlerta(
                              context, "Asistencia subida exitosamente.");
                        } else if (attendanceService
                                    .attendanceModel?.checkIn2 ==
                                null &&
                            attendanceService.attendanceModel?.pic_in2 !=
                                null) {
                          await attendanceService.markAttendance2(context);
                        } else if (attendanceService
                                .attendanceModel?.checkIn2 ==
                            null) {
                          _mostrarAlerta(context, "Suba una foto por favor.");
                        } else if (attendanceService
                                .attendanceModel?.pic_out2 !=
                            null) {
                          await attendanceService.markAttendance2(context);
                        } else {
                          _mostrarAlerta(context, "Suba una foto por favor.");
                        }
                        key2.currentState!.reset();
                      } catch (e) {
                        Utils.showSnackBar("$e", context);
                      }
                    },
                  );
                }),
              ),
            ],
          ),
        ),
        floatingActionButton: SpeedDial(
          //Speed dial menus
          // marginBottom: 10, //margin bottom
          icon: Icons.message_outlined, //icon on Floating action button
          activeIcon: Icons.close, //icon when menu is expanded on button
          //backgroundColor: Colors.deepOrangeAccent, //background color of button
          // foregroundColor: Colors.white, //font color, icon color in button
          activeBackgroundColor:
              Colors.deepPurpleAccent, //background color when menu is expanded
          activeForegroundColor: Colors.white,
          //buttonSize: Size(45, 45), //button size
          visible: true,
          closeManually: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          elevation: 8.0, //shadow elevation of button
          shape: CircleBorder(), //shape of button

          children: [
            SpeedDialChild(
              //speed dial child
              child: Icon(Icons.message),
              //  backgroundColor: Colors.red,
              // foregroundColor: Colors.white,
              label:
                  '¿Has tenido inconvenientes \n al momento de registrarte? \n Dejanoslo saber.',
              labelStyle: TextStyle(fontSize: inconvenientessize18),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ComentariosPage()));
              },
              /*  onLongPress: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ComentariosPage()));
              }, */
            ),

            //add more menu item childs here
          ],
        ));
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
            title: Text(
              titulo,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: inconvenientessize18),
            ),
            actions: [
              TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          ));
}
