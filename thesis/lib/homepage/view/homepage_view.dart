import 'package:flutter/material.dart';
import 'package:thesis/homepage/viewmodel/homepageviewmodel.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends MyHomePageViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => pickPhoto(context),
              child: const Text('Select Photo'),
            ),
            if (isLoading)
              const SizedBox(
                height: 20,
                child: CircularProgressIndicator(),
              ),
            if (!isLoading && isResultShown && processedImage != null) ...[
              const SizedBox(height: 20),
              const Text('Processed Image:'),
              const SizedBox(height: 10),
              Image.file(processedImage!),
            ],
          ],
        ),
      ),
    );
  }
}
