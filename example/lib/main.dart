import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_media_picker/flutter_media_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Attachment> attachments = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: <Widget>[
            IconButton(
              onPressed: _openGallery,
              icon: Icon(Icons.photo),
            ),
            IconButton(
              onPressed: _openCamera,
              icon: Icon(Icons.photo_camera),
            )
          ],
        ),
        body: Wrap(
          children: attachments.map((item) {
            return Container(
              width: 80,
              height: 80,
              child: Image.asset(item.thumbnail),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _openGallery() async {
    try {
      var _attachment = await FlutterMediaPicker.getMedia(sourceType: SourceType.photoLibrary, allowedTypes: [AttachmentType.image]);
      setState(() {
        attachments.add(_attachment);
      });
    } on PlatformException {
      print('PlatformException ');
    }
  }

  void _openCamera() async {
    try {
      var _attachment = await FlutterMediaPicker.getMedia(sourceType: SourceType.camera, allowedTypes: [AttachmentType.image, AttachmentType.movie]);
      setState(() {
        attachments.add(_attachment);
      });
    } on PlatformException {
      print('PlatformException ');
    }
  }
}
