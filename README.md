# image_lut

A new Flutter package project.


```
final lut = Lut.loadLut("./lut02.jpg");

final image_file = File("./demo.jpg");
final image = decodeImage(image_file.readAsBytesSync());

final data = lut.filter(image.getBytes());

File file2 = File("./demo-result-2.jpg");
final image2 = Image.fromBytes(image.width, image.height, data);
file2.writeAsBytesSync(encodeJpg(image2));
```

## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
