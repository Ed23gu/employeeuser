import "package:flutter/material.dart";
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class ErrorPage extends StatefulWidget {
  const ErrorPage({super.key});

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  late Future<List<InternetAddress>> _future;

  //////////////////////////////
  @override
  void initState() {
    super.initState();
    _future = InternetAddress.lookup('www.supabase.com');
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<InternetAddress>>(
        future: _future,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const CircularProgressIndicator();
            case ConnectionState.done:
              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    _future = InternetAddress.lookup('www.supabase.com');
                  });
                },
                child: snapshot.hasData
                    ? ListView.builder(
                        itemBuilder: (context, index) => ListTile(
                          title: Text(snapshot.requireData[index].address),
                          subtitle: Text(snapshot.requireData[index].type.name),
                        ),
                        itemCount: snapshot.requireData.length,
                      )
                    : snapshot.hasError
                        ? SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/nocone22.svg',
                                  width: 200,
                                  height: 200,
                                  //color: Colors.red[200],
                                ),
                                Image.asset(
                                  'assets/error.png',
                                  width: 200,
                                  height: 200,
                                  //color: Colors.red[200],
                                ),
                                const SizedBox(height: 25.0),
                                const Text('Ud. se encuentra sin conección.\n',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    )),
                                RichText(
                                    textAlign: TextAlign.left,
                                    text: const TextSpan(
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.black),
                                        children: <TextSpan>[
                                          TextSpan(text: 'Intente:\n'),
                                          TextSpan(
                                            text:
                                                '     - Activar sus Datos mobiles o Wifi.\n     - Buscar un lugar con mejor cobertura. \n',
                                          ),
                                          TextSpan(text: 'y vuelva a '),
                                          TextSpan(
                                              text: 'intentarlo.',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold)),
                                        ])),
                              ],
                            ),
                            /*  child: Text(
                                    '${snapshot.error!.toString()}\n ${snapshot.stackTrace!.toString()}'), */
                          )
                        : const SizedBox(),
              );
          }
        },
      ),
    );
  }
}
