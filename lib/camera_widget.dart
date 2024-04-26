// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';

// class CameraWidget extends StatefulWidget {
//   final Function(Uint8List) onImageChange;
//   const CameraWidget({super.key, required this.onImageChange});
//   @override
//   _CameraWidgetState createState() => _CameraWidgetState();
// }

// class _CameraWidgetState extends State<CameraWidget> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }

//   Future<void> _initializeCamera() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     final cameras = await availableCameras();
//     final firstCamera = cameras.first;
//     _controller = CameraController(
//       firstCamera,
//       ResolutionPreset.medium,
//     );
//     _initializeControllerFuture = _controller.initialize();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Future<void> _takePicture() async {
//     try {
//       await _initializeControllerFuture;
//       final image = await _controller.takePicture();
//       // Do something with the captured image
//       print('Image path: ${image.path}');
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           content: Image.file(File(image.path)),
//         ),
//       );
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Camera Example"),
//       ),
//       body: FutureBuilder<void>(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return CameraPreview(_controller);
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _takePicture,
//         child: Icon(Icons.camera),
//       ),
//     );
//   }
// }


import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraWidget extends StatefulWidget {
  final Function(Uint8List) onImageChange;
  const CameraWidget({super.key, required this.onImageChange});

  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  late CameraController _controller;
  Future<void> _initializeControllerFuture = Future.value();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }
  
  
  Future<void> _initializeCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
     final cameras = await availableCameras();
     final firstCamera =  cameras.first;
      _controller =  CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );
     _initializeControllerFuture =  _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      // Do something with the captured image
      print('Image path: ${image.path}');
      widget.onImageChange(Uint8List.fromList(await File(image.path).readAsBytes()));
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Image.file(File(image.path)),
        ),
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera Example"),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        child: Icon(Icons.camera),
      ),
    );
  }
}
