import 'dart:async';

import 'package:flutter/services.dart';

class FlutterMediaPicker {
  static const MethodChannel _channel = const MethodChannel('flutter_media_picker');

  static Future<Attachment> getMedia({SourceType sourceType, List<AttachmentType> allowedTypes, multiple: false}) async {
    List<String> mediaTypes = [];
    var source = 0;

    allowedTypes.forEach((t) {
      switch (t) {
        case AttachmentType.image:
          mediaTypes.add('public.image');
          break;
        case AttachmentType.movie:
          mediaTypes.add('public.movie');
          break;
        case AttachmentType.other:
          break;
      }
    });

    switch (sourceType) {
      case SourceType.camera:
        source = 1;
        break;
      case SourceType.photoLibrary:
        source = 0;
    }
    final Map _attachment = await _channel.invokeMethod('getMediaFromGallery', {
      'mediaTypes': mediaTypes,
      'source': source
    });
    return Attachment.fromJson(_attachment.cast<String, dynamic>());
  }
}

class Attachment {
  AttachmentType type;
  String path;
  String thumbnail;

  Attachment(this.type, this.path, this.thumbnail);

  Attachment.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'public.image':
        this.type = AttachmentType.image;
        break;
      case 'public.movie':
        this.type = AttachmentType.movie;
        break;
    }
    this.path = json['path'];
    this.thumbnail = Uri.parse(json['thumbnail']).path;
  }
}

enum AttachmentType { image, movie, other }

enum SourceType {
  photoLibrary, camera
}