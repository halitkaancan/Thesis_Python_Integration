// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:path_provider/path_provider.dart';

// void main() {
//   runApp(const MaterialApp(
//     home: MyHomePage(),
//   ));
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final ImagePicker _picker = ImagePicker();
//   File? processedImage;
//   bool _isLoading = false;
//   bool _isResultShown = false;

//   Future<void> sendPhoto(File photo) async {
//     setState(() {
//       _isLoading = true;
//     });

//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse('http://10.0.2.2:5000/'),
//     );
//     request.files.add(await http.MultipartFile.fromPath('photo', photo.path));

//     try {
//       var response = await request.send();
//       if (response.statusCode == 200) {
//         var responseString = await response.stream.bytesToString();
//         var jsonResponse = jsonDecode(responseString);
//         var processedBytes = base64Decode(jsonResponse['result']);

//         final directory = await getApplicationDocumentsDirectory();
//         final pathOfImage = '${directory.path}/processed_image.png';
//         final imageFile = File(pathOfImage);
//         imageFile.writeAsBytesSync(processedBytes);

//         setState(() {
//           processedImage = imageFile;
//           _isResultShown = true;
//         });
//         print('Photo processed successfully.');
//       } else {
//         print('Error: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error: $e');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _pickPhoto(BuildContext context) async {
//     final pickedFile = await _picker.pickImage(
//       source: ImageSource.gallery,
//     );
//     if (pickedFile != null) {
//       File photo = File(pickedFile.path);
//       File compressedImage = await compressImage(photo);
//       await sendPhoto(compressedImage);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Photo processed successfully.')),
//       );
//     } else {
//       print('No image selected.');
//     }
//   }

//   Future<File> compressImage(File image) async {
//     final tempDir = await Directory.systemTemp;
//     String targetPath =
//         '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
//     var result = await FlutterImageCompress.compressAndGetFile(
//       image.path,
//       targetPath,
//       quality: 90,
//       format: CompressFormat.jpeg,
//       minHeight: 1920,
//       minWidth: 1080,
//     );
//     return File(result!.path);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Photo Upload'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () => _pickPhoto(context),
//               child: const Text('Select Photo'),
//             ),
//             if (_isLoading)
//               const SizedBox(
//                 height: 20,
//                 child: CircularProgressIndicator(),
//               ),
//             if (!_isLoading && _isResultShown && processedImage != null) ...[
//               const SizedBox(height: 20),
//               const Text('Processed Image:'),
//               const SizedBox(height: 10),
//               Image.file(processedImage!),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
