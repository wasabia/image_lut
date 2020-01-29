import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart';

import 'package:image_lut/image_lut.dart';
import 'package:image_lut/src/lut.dart';

void main() {
  test('adds one to input values', () async {
    // final calculator = Calculator();
    // expect(calculator.addOne(2), 3);
    // expect(calculator.addOne(-7), -6);
    // expect(calculator.addOne(0), 1);
    // expect(() => calculator.addOne(null), throwsNoSuchMethodError);

    final lut = Lut.loadLut("./lut02.jpg");

    final image_file = File("./demo.jpg");
    final image = decodeImage(image_file.readAsBytesSync());
    print("s: ${DateTime.now().millisecondsSinceEpoch}");
    final data = await lut.filter(image.getBytes());
    print("ss: ${DateTime.now().millisecondsSinceEpoch}");

    File file2 = File("./demo-result-2.jpg");
    final image2 = Image.fromBytes(image.width, image.height, data);
    file2.writeAsBytesSync(encodeJpg(image2));
  });
}
