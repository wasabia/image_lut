import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart';

class Lut {

  Uint8List lutBytes;

  Lut(Uint8List bytes) {
    lutBytes = bytes;
  }

  static loadLut(String file_path) {
    File lut_file = File(file_path);
    final image = decodeImage(lut_file.readAsBytesSync());
    return Lut(image.getBytes());
  }

  Future<Uint8List> filter(Uint8List image) {
    return compute(filterCompute, {"image": image, "lutBytes": lutBytes});
  }

  Uint8List filter2(Uint8List image) {
    int length = image.length;

    for (var i = 0; i < length; i += 4) {
      int r = image[i];
      int g = image[i + 1];
      int b = image[i + 2];
      int a = image[i + 3];

      int ro = (r / 4.0).floor();
      int go = (g / 4.0).floor();
      int bo = (b / 4.0).floor();
 
      int lutX = (bo % 8) * 64 + ro;
      int lutY = (bo / 8.0).floor() * 64 + go;

      int p1 = (lutY * 512 + lutX)*4;

      int c1r = lutBytes[p1];
      int c1g = lutBytes[p1 + 1];
      int c1b = lutBytes[p1 + 2];

      image[i] = c1r;
      image[i+1] = c1g;
      image[i+2] = c1b;
    }

    return image;
  }


}

Uint8List filterCompute(Map<String, Uint8List> options) {
  final image = options["image"];
  final lutBytes = options["lutBytes"];
  int length = image.length;
  final result = Uint8List(length);
  for (var i = 0; i < length; i += 4) {
    int r = image[i];
    int g = image[i + 1];
    int b = image[i + 2];
    int a = image[i + 3];

    double ro = r / 255.0;
    double go = g / 255.0;
    double bo = b / 255.0;

    double blueColor = bo * 63.0;

    int y1 = (blueColor.floor()/8.0).floor();
    int x1 = blueColor.floor() - (y1 * 8.0).floor();
    
    int y2 = (blueColor.ceil()/8.0).floor();
    int x2 = blueColor.ceil() - (y2 * 8.0).floor();

    
    double px1 = (x1 * 0.125) + 0.5/512.0 + ((0.125 - 1.0/512.0) * ro);
    double py1 = (y1 * 0.125) + 0.5/512.0 + ((0.125 - 1.0/512.0) * go);

    double px2 = (x2 * 0.125) + 0.5/512.0 + ((0.125 - 1.0/512.0) * ro);
    double py2 = (y2 * 0.125) + 0.5/512.0 + ((0.125 - 1.0/512.0) * go);

    int p1 = (((py1 * 512).floor() * 512) + (px1 * 512).floor())*4;
    int c1r = lutBytes[p1];
    int c1g = lutBytes[p1 + 1];
    int c1b = lutBytes[p1 + 2];

    int p2 = (((py2 * 512).floor() * 512) + (px2 * 512).floor())*4;
    int c2r = lutBytes[p2];
    int c2g = lutBytes[p2 + 1];
    int c2b = lutBytes[p2 + 2];

    double l = blueColor - blueColor.floor();

    int cr = (c1r * (1 - l) + c2r * l).floor();
    int cg = (c1g * (1 - l) + c2g * l).floor();
    int cb = (c1b * (1 - l) + c2b * l).floor();

    result[i] = cr;
    result[i+1] = cg;
    result[i+2] = cb;
    result[i+3] = a;
  }

  return result;
}