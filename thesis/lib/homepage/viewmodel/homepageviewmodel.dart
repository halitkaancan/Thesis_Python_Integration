import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import '../view/homepage_view.dart';

abstract class MyHomePageViewModel extends State<MyHomePage> {
  final ImagePicker _picker = ImagePicker();
  File? processedImage;
  bool isLoading = false;
  bool isResultShown = false;
  final int minHeight = 1920;
  final int minWidth = 1080;
  final String snackBarMessage = "Photo processed successfully.";

  Future<void> sendPhoto(File photo) async {
    setState(() {
      isLoading = true;
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.0.2.2:5000/'),
    );
    request.files.add(await http.MultipartFile.fromPath('photo', photo.path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseString = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseString);
        var processedBytes = base64Decode(jsonResponse['result']);

        final directory = await getApplicationDocumentsDirectory();
        final pathOfImage = '${directory.path}/processed_image.png';
        final imageFile = File(pathOfImage);
        imageFile.writeAsBytesSync(processedBytes);

        setState(() {
          processedImage = imageFile;
          isResultShown = true;
        });
        // ignore: avoid_print
        print('Photo processed successfully.');
      } else {
        // ignore: avoid_print
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> pickPhoto(BuildContext context) async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      File photo = File(pickedFile.path);
      File compressedImage = await compressImage(photo);
      await sendPhoto(compressedImage);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(snackBarMessage)),
      );
    } else {
      print('No image selected.');
    }
  }

  Future<File> compressImage(File image) async {
    final tempDir = await Directory.systemTemp;
    String targetPath =
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    var result = await FlutterImageCompress.compressAndGetFile(
      image.path,
      targetPath,
      quality: 90,
      format: CompressFormat.jpeg,
      minHeight: minHeight,
      minWidth: minWidth,
    );
    return File(result!.path);
  }
}
