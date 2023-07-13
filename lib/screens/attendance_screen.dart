import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
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
import 'package:quickalert/quickalert.dart';
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
  int segundos = 3;
  bool buttonDisabled = false;
  bool buttonDisabled2 = true;
  bool buttonDisabled3 = true;
  bool buttonDisabled4 = true;
  bool buttonDisabled5 = true;
  bool isUploading = false;
  bool isUploading2 = false;
  bool isUploading3 = false;
  bool isUploading4 = false;
  int imageq = 100;
  int qt = 90;
  int per = 15;
  final picker = ImagePicker();
  File? pickedImage;
  File? _imagescom1;
  File? _imagescom2;
  File? _imagescom3;
  File? _imagescom4;
  File? _images;
  File? _images2;
  File? _images3;
  File? _images4;
  Uint8List webImage = Uint8List(8);
  Uint8List webImage2 = Uint8List(8);
  Uint8List webImage3 = Uint8List(8);
  Uint8List webImage4 = Uint8List(8);
  Uint8List webI = Uint8List(8);
  Uint8List webI2 = Uint8List(8);
  Uint8List webI3 = Uint8List(8);
  Uint8List webI4 = Uint8List(8);
  final SupabaseClient supabase = Supabase.instance.client;

  Future limpiaima() async {
    _images = null;
    setState(() {});
  }

  Future limpiaima2() async {
    _images2 = null;
    setState(() {});
  }

  Future limpiaima3() async {
    _images3 = null;
    setState(() {});
  }

  Future limpiaima4() async {
    _images4 = null;
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
        _images = File(pickedFile.path);
        File? imagescom = await customCompressed(imagePathToCompress: _images);
        setState(() {
          isUploading = true;
          _imagescom1 = imagescom;
        });
      }
    } else if (kIsWeb) {
      var pickedFileweb = await picker.pickImage(
          source: ImageSource.camera, imageQuality: imageq);
      if (pickedFileweb != null) {
        var f = await pickedFileweb.readAsBytes();
        _images = File('a');
        setState(() {
          isUploading = true;
          webI = f;
        });
      }
    }
  }

  Future choiceImage2() async {
    if (!kIsWeb) {
      var pickedFile2 = await picker.pickImage(
          source: ImageSource.camera, imageQuality: imageq);
      if (pickedFile2 != null) {
        _images2 = File(pickedFile2.path);
        File? imagescom2 =
            await customCompressed(imagePathToCompress: _images2);
        setState(() {
          isUploading2 = true;
          _imagescom2 = imagescom2;
        });
      }
    } else if (kIsWeb) {
      var pickedFileweb2 = await picker.pickImage(
          source: ImageSource.camera, imageQuality: imageq);
      if (pickedFileweb2 != null) {
        var f2 = await pickedFileweb2.readAsBytes();
        _images2 = File('a');
        setState(() {
          isUploading2 = true;
          webI2 = f2;
        });
      }
    }
  }

  Future choiceImage3() async {
    if (!kIsWeb) {
      var pickedFile3 = await picker.pickImage(
          source: ImageSource.camera, imageQuality: imageq);
      if (pickedFile3 != null) {
        _images3 = File(pickedFile3.path);
        File? imagescom3 =
            await customCompressed(imagePathToCompress: _images3);
        setState(() {
          isUploading3 = true;
          _imagescom3 = imagescom3;
        });
      }
    } else if (kIsWeb) {
      var pickedFileweb3 = await picker.pickImage(
          source: ImageSource.camera, imageQuality: imageq);
      if (pickedFileweb3 != null) {
        var f3 = await pickedFileweb3.readAsBytes();
        _images3 = File('a');
        setState(() {
          isUploading3 = true;
          webI3 = f3;
        });
      }
    }
  }

  Future choiceImage4() async {
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

  Future<void> markasistencia() async {
    final attendanceService2 = route.Provider.of<AttendanceService>(context);
    try {
      print("okkkkkkkk");
      await attendanceService2.markAttendance(context);
      print("okkkkkkkk");
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: const Text("heyeyyyyyyyyyyyyyyyy")));
    }
    return;
  }

/////////////tomar foto y subir//////////////
  Future uploadFile() async {
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
        await markasistencia();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Foto cargada correctamente ! "),
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
          content: Text("Algo ha salido mal"),
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
                "${supabase.auth.currentUser!.id}/$fecharuta$fileName",
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
  }

  Future uploadFile2() async {
    if (!kIsWeb) {
      var pickedFile2 = _imagescom2;
      try {
        _images2 = File(pickedFile2!.path);
        String fecharuta =
            DateFormat("ddMMMMyyyy").format(DateTime.now()).toString();
        DateTime now = DateTime.now();
        String fileName =
            DateFormat('yyyy-MM-dd_HH-mm-ss').format(now) + '.jpg';
        String uploadedUrl = await supabase.storage.from('imageip').upload(
            "${supabase.auth.currentUser!.id}/$fecharuta/$fileName", _images2!);
        String urllisto = uploadedUrl.replaceAll("imageip/", "");
        final getUrl = supabase.storage.from('imageip').getPublicUrl(urllisto);
        await supabase
            .from('attendance')
            .update({
              'pic_out': getUrl,
            })
            .eq('employee_id', supabase.auth.currentUser!.id)
            .eq('date', DateFormat("dd MMMM yyyy").format(DateTime.now()));
        setState(() {
          isUploading2 = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Foto cargada correctamente !"),
          backgroundColor: Colors.green,
        ));
      } catch (e) {
        //  print("ERRROR : $e");
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
    } else if (kIsWeb) {
      setState(() {
        webImage2 = webI2;
      });
      var pickedFile = webImage2;
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
        await supabase
            .from('attendance')
            .update({
              'pic_out': getUrl,
            })
            .eq('employee_id', supabase.auth.currentUser!.id)
            .eq('date', DateFormat("dd MMMM yyyy").format(DateTime.now()));
        setState(() {
          isUploading2 = false;
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

  Future uploadFile3() async {
    if (!kIsWeb) {
      var pickedFile3 = _imagescom3;
      try {
        _images3 = File(pickedFile3!.path);
        String fecharuta =
            DateFormat("ddMMMMyyyy").format(DateTime.now()).toString();
        DateTime now = DateTime.now();
        String fileName =
            DateFormat('yyyy-MM-dd_HH-mm-ss').format(now) + '.jpg';
        String uploadedUrl = await supabase.storage.from('imageip').upload(
            "${supabase.auth.currentUser!.id}/$fecharuta/$fileName", _images3!);
        String urllisto = uploadedUrl.replaceAll("imageip/", "");
        final getUrl = supabase.storage.from('imageip').getPublicUrl(urllisto);
        await supabase
            .from('attendance')
            .update({
              'pic_in2': getUrl,
            })
            .eq('employee_id', supabase.auth.currentUser!.id)
            .eq('date', DateFormat("dd MMMM yyyy").format(DateTime.now()));
        setState(() {
          isUploading3 = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Foto cargada correctamente !"),
          backgroundColor: Colors.green,
        ));
      } catch (e) {
        //  print("ERRROR : $e");
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
    } else if (kIsWeb) {
      setState(() {
        webImage3 = webI3;
      });
      var pickedFile = webImage3;
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
        await supabase
            .from('attendance')
            .update({
              'pic_in2': getUrl,
            })
            .eq('employee_id', supabase.auth.currentUser!.id)
            .eq('date', DateFormat("dd MMMM yyyy").format(DateTime.now()));
        setState(() {
          isUploading3 = false;
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

  Future uploadFile4() async {
    if (!kIsWeb) {
      var pickedFile4 = _imagescom4;
      try {
        _images4 = File(pickedFile4!.path);
        String fecharuta =
            DateFormat("ddMMMMyyyy").format(DateTime.now()).toString();
        DateTime now = DateTime.now();
        String fileName =
            DateFormat('yyyy-MM-dd_HH-mm-ss').format(now) + '.jpg';
        String uploadedUrl = await supabase.storage.from('imageip').upload(
            "${supabase.auth.currentUser!.id}/$fecharuta/$fileName", _images4!);
        String urllisto = uploadedUrl.replaceAll("imageip/", "");
        final getUrl = supabase.storage.from('imageip').getPublicUrl(urllisto);
        await supabase
            .from('attendance')
            .update({
              'pic_out2': getUrl,
            })
            .eq('employee_id', supabase.auth.currentUser!.id)
            .eq('date', DateFormat("dd MMMM yyyy").format(DateTime.now()));
        setState(() {
          isUploading4 = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Foto cargada correctamente !"),
          backgroundColor: Colors.green,
        ));
      } catch (e) {
        //  print("ERRROR : $e");
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
    } else if (kIsWeb) {
      setState(() {
        webImage4 = webI4;
      });
      var pickedFile = webImage4;
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
        await supabase.from('attendance').update({
          'pic_out2': getUrl,
        });
        setState(() {
          isUploading4 = false;
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

  void disableButton() {
    setState(() {
      buttonDisabled = true;
    });
  }

  void disableButton2() {
    setState(() {
      buttonDisabled2 = true;
    });
  }

  void disableButton3() {
    setState(() {
      buttonDisabled3 = true;
    });
  }

  void disableButton4() {
    setState(() {
      buttonDisabled4 = true;
    });
  }

  void disableButton5() {
    setState(() {
      buttonDisabled5 = true;
    });
  }

  //////////////////////////////
  Future<void> deleteImage(String imageName) async {
    try {
      await supabase.storage
          .from('imageip')
          .remove([supabase.auth.currentUser!.id + "/" + imageName]);
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: const Text("Algo ha salido mal !")));
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
      appBar: AppBar(
        title: Text(
          "ArtConsGroup",
          style: TextStyle(fontSize: 25),
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
                              fontSize: 20, fontWeight: FontWeight.bold),
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
                          style: const TextStyle(fontSize: 15),
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

            StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  return Container(
                    alignment: Alignment.center,
                    child: Text(
                      DateFormat("HH:mm:ss").format(DateTime.now()),
                      style: const TextStyle(fontSize: 30),
                    ),
                  );
                }),
            Container(
              alignment: Alignment.center,
              child: Text(
                DateFormat("dd MMMM yyyy").format(DateTime.now()),
                style: const TextStyle(fontSize: 15),
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
              height: 225,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Ingreso:  ",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                /*color: Colors.black5*/
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            (_images == null &&
                                    attendanceService
                                            .attendanceModel?.checkIn ==
                                        null)
                                ? IconButton(
                                    icon: Icon(Icons.add_a_photo),
                                    onPressed: () {
                                      choiceImage();
                                      disableButton5();
                                    })
                                : AbsorbPointer(
                                    absorbing: buttonDisabled5,
                                    child: IconButton(
                                        icon: Icon(Icons.add_a_photo),
                                        onPressed: () {
                                          choiceImage();
                                          disableButton5();
                                        }),
                                  ),
                            attendanceService.attendanceModel?.checkIn == null
                                ? IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () {
                                      limpiaima();
                                      // disableButton();
                                    })
                                : AbsorbPointer(
                                    absorbing: buttonDisabled5,
                                    child: IconButton(
                                        icon: Icon(Icons.delete),
                                        color: Colors.red,
                                        onPressed: () {
                                          limpiaima();
                                          disableButton5();
                                        }),
                                  ),
                          ],
                        ),
                        Container(
                            child: (attendanceService.attendanceModel?.pic_in ==
                                    null)
                                ? _images == null
                                    ? Icon(Icons.photo)
                                    : kIsWeb == true
                                        ? Image.memory(webI, height: 120)
                                        : Image.file(
                                            _images!,
                                            height: 120,
                                          )
                                : Image.network(
                                    attendanceService.attendanceModel?.pic_in
                                        as String,
                                    height: 120))

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            (_images2 == null &&
                                        attendanceService
                                                .attendanceModel?.checkOut ==
                                            null) &&
                                    attendanceService
                                            .attendanceModel?.checkIn !=
                                        null
                                ? IconButton(
                                    icon: Icon(Icons.add_a_photo),
                                    onPressed: () {
                                      choiceImage2();
                                      disableButton2();
                                    })
                                : AbsorbPointer(
                                    absorbing: buttonDisabled2,
                                    child: IconButton(
                                        icon: Icon(Icons.add_a_photo),
                                        onPressed: () {
                                          choiceImage2();
                                          disableButton2();
                                        })),
                            attendanceService.attendanceModel?.checkOut == null
                                ? IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () {
                                      limpiaima2();
                                      // disableButton();
                                    })
                                : AbsorbPointer(
                                    absorbing: buttonDisabled2,
                                    child: IconButton(
                                        icon: Icon(Icons.delete),
                                        color: Colors.red,
                                        onPressed: () {
                                          limpiaima2();
                                          disableButton2();
                                        }),
                                  ),
                          ],
                        ),
                        Container(
                            child: (attendanceService
                                        .attendanceModel?.pic_out ==
                                    null)
                                ? _images2 == null
                                    ? Icon(Icons.photo)
                                    : kIsWeb == true
                                        ? Image.memory(webI2, height: 120)
                                        : Image.file(
                                            _images2!,
                                            height: 120,
                                          )
                                : Image.network(
                                    attendanceService.attendanceModel?.pic_out
                                        as String,
                                    height: 120))
                      ],
                    )),
                  ]),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Builder(builder: (context) {
                return SlideAction(
                  text: (attendanceService.attendanceModel?.checkIn != null &&
                          attendanceService.attendanceModel?.checkOut != null)
                      ? "Registro Exitoso. Gracias"
                      : (attendanceService.attendanceModel?.checkIn == null)
                          ? "Registrar el ingreso"
                          : "Registrar la salida",
                  //alignment: Alignment.topCenter,

                  textStyle: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white),
                  outerColor: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Color(0xFF2B2929),
                  innerColor: Colors.blue,
                  key: key,
                  onSubmit: () async {
                    if (attendanceService.attendanceModel?.checkIn != null &&
                        attendanceService.attendanceModel?.checkOut != null) {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.warning,
                        title: ' ',
                        text: 'Registro Completado',
                      );
                    } else if (attendanceService.attendanceModel?.checkIn ==
                            null &&
                        _images != null &&
                        attendanceService.attendanceModel?.pic_in == null) {
                      uploadFile();
                      // await uploadFile().then((_) async {
                      //   await attendanceService.markAttendance(context);
                      //   setState(() {});
                      // });
                      //if (attendanceService.attendanceModel?.pic_in != null) {
                      //   await attendanceService.markAttendance(context);
                      //  }
                      //await attendanceService.markAttendance(context);
                    } else if (attendanceService.attendanceModel?.checkIn ==
                        null) {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.warning,
                        title: 'Suba',
                        text: 'una foto por favor',
                      );
                    } else if (_images2 != null) {
                      uploadFile2();
                      await attendanceService.markAttendance(context);
                    } else {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.warning,
                        title: 'Suba',
                        text: 'una foto por favor',
                      );
                    }
                    key.currentState!.reset();
                  },
                  /*onSubmit: () async {
                    if (attendanceService.attendanceModel?.checkIn != null &&
                        attendanceService.attendanceModel?.checkOut != null) {
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.warning,
                          title: ' ',
                          text: 'Registro Completado');
                    } else {
                      (attendanceService.attendanceModel?.checkIn == null
                          ? (_images != null
                          ? (await attendanceService
                          .markAttendance(context))
                          : QuickAlert.show(
                          context: context,
                          type: QuickAlertType.warning,
                          title: 'Suba',
                          text: 'una foto por favor'))
                          : _images2 != null
                          ? (await attendanceService
                          .markAttendance(context))
                          : QuickAlert.show(
                          context: context,
                          type: QuickAlertType.warning,
                          title: 'Suba',
                          text: 'una foto por favor'));
                      attendanceService.attendanceModel?.checkIn == null
                          ? (_images != null
                          ? uploadFile()
                          : _images2 != null
                          ? uploadFile2()
                          : print("mal1"))
                          : _images2 != null
                          ? uploadFile2()
                          : print("mal2");
                    }
                    key.currentState!.reset();
                  },*/
                );
              }),
            ),
            Container(
              height: 10,
            ),
            /*  Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 10),
              child: const Text(
                "Registro de la tarde",
                style: TextStyle(fontSize: 18),
              ),
            ),*/
            Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.only(top: 5, bottom: 10),
              height: 225,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Entrada:  ",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                /*color: Colors.black5*/
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            (_images3 == null &&
                                        attendanceService
                                                .attendanceModel?.checkIn2 ==
                                            null) &&
                                    attendanceService
                                            .attendanceModel?.checkOut !=
                                        null
                                ? IconButton(
                                    icon: Icon(Icons.add_a_photo),
                                    onPressed: () {
                                      choiceImage3();
                                      disableButton3();
                                    })
                                : AbsorbPointer(
                                    absorbing: buttonDisabled3,
                                    child: IconButton(
                                        icon: Icon(Icons.add_a_photo),
                                        onPressed: () {
                                          choiceImage3();
                                          disableButton3();
                                        }),
                                  ),
                            attendanceService.attendanceModel?.checkIn2 == null
                                ? IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () {
                                      limpiaima3();
                                      // disableButton();
                                    })
                                : AbsorbPointer(
                                    absorbing: buttonDisabled3,
                                    child: IconButton(
                                        icon: Icon(Icons.delete),
                                        color: Colors.red,
                                        onPressed: () {
                                          limpiaima3();
                                          disableButton3();
                                        }),
                                  ),
                          ],
                        ),
                        Container(
                            child: (attendanceService
                                        .attendanceModel?.pic_in2 ==
                                    null)
                                ? _images3 == null
                                    ? Icon(Icons.photo)
                                    : kIsWeb == true
                                        ? Image.memory(webI3, height: 120)
                                        : Image.file(
                                            _images3!,
                                            height: 120,
                                          )
                                : Image.network(
                                    attendanceService.attendanceModel?.pic_in2
                                        as String,
                                    height: 120))
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            (_images4 == null &&
                                        attendanceService
                                                .attendanceModel?.checkOut2 ==
                                            null) &&
                                    attendanceService
                                            .attendanceModel?.checkIn2 !=
                                        null
                                ? IconButton(
                                    icon: Icon(Icons.add_a_photo),
                                    onPressed: () {
                                      choiceImage4();
                                      disableButton4();
                                    })
                                : AbsorbPointer(
                                    absorbing: buttonDisabled4,
                                    child: IconButton(
                                        icon: Icon(Icons.add_a_photo),
                                        onPressed: () {
                                          choiceImage4();
                                          disableButton4();
                                        }),
                                  ),
                            attendanceService.attendanceModel?.checkOut2 == null
                                ? IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () {
                                      limpiaima4();
                                      // disableButton2();
                                    })
                                : AbsorbPointer(
                                    absorbing: buttonDisabled4,
                                    child: IconButton(
                                        icon: Icon(Icons.delete),
                                        color: Colors.red,
                                        onPressed: () {
                                          limpiaima4();
                                          disableButton4();
                                        }),
                                  ),
                          ],
                        ),
                        Container(
                            child: (attendanceService
                                        .attendanceModel?.pic_out2 ==
                                    null)
                                ? _images4 == null
                                    ? Icon(Icons.photo)
                                    : kIsWeb == true
                                        ? Image.memory(webI4, height: 120)
                                        : Image.file(
                                            _images4!,
                                            height: 120,
                                          )
                                : Image.network(
                                    attendanceService.attendanceModel?.pic_out2
                                        as String,
                                    height: 120))
                      ],
                    )),
                  ]),
            ),
            ///////////////////////////////////fotos//////////////
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Builder(builder: (context) {
                return SlideAction(
                  text: (attendanceService.attendanceModel?.checkIn2 != null &&
                          attendanceService.attendanceModel?.checkOut2 != null)
                      ? "Registro Exitoso Gracias"
                      : (attendanceService.attendanceModel?.checkIn2 == null)
                          ? "Registrar el ingreso"
                          : "Registrar la salida",
                  //alignment: Alignment.topCenter,

                  textStyle: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white),
                  outerColor: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Color(0xFF2B2929),
                  innerColor: Colors.blue,
                  key: key2,
                  onSubmit: () async {
                    if (attendanceService.attendanceModel?.checkIn2 != null &&
                        attendanceService.attendanceModel?.checkOut2 != null) {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.warning,
                        title: ' ',
                        text: 'Registro Completado',
                      );
                    } else if (attendanceService.attendanceModel?.checkIn2 ==
                            null &&
                        _images3 != null) {
                      uploadFile3();
                      await attendanceService.markAttendance2(context);
                    } else if (attendanceService.attendanceModel?.checkIn2 ==
                        null) {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.warning,
                        title: 'Suba',
                        text: 'una foto por favor',
                      );
                    } else if (_images4 != null) {
                      uploadFile4();
                      await attendanceService.markAttendance2(context);
                    } else {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.warning,
                        title: 'Suba',
                        text: 'una foto por favor',
                      );
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

// flutter custom card button
Card buildButton({
  required onTap,
  required title,
  required text,
  required leadingIcon,
}) {
  return Card(
    shape: const StadiumBorder(),
    margin: const EdgeInsets.symmetric(
      horizontal: 20,
    ),
    clipBehavior: Clip.antiAlias,
    elevation: 1,
    child: ListTile(
      onTap: onTap,
      leading: leadingIcon,
      title: Text(title ?? ""),
      subtitle: Text(text ?? ""),
      trailing: const Icon(
        Icons.keyboard_arrow_right_rounded,
      ),
    ),
  );
}
