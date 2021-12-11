import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:playit/playit.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ItPlayerController? controller;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () async {
              final path = (await FilePicker.platform.pickFiles())?.paths.first;
              if (path != null) {
                setState(() {
                  controller?.dispose();
                  controller = ItPlayerController(PlayItFileSource(path));
                });
              }
            },
            icon: Icon(Icons.open_in_browser),
          ),
          IconButton(
            onPressed: () async {
              final path =
                  "${(await getTemporaryDirectory()).path}/34rtsw.jpeg";
              await controller?.takeSnapshot(path);
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: Image.file(File(path)),
                  );
                },
              );
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: controller != null ? ItPlayer(controller!) : Container(),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
