import 'dart:io';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

@RoutePage()
class Paso2Page extends StatefulWidget {
  const Paso2Page({super.key});

  @override
  State<Paso2Page> createState() => _Paso2PageState();
}

class _Paso2PageState extends State<Paso2Page> {
  CameraController? _cameraController;
  XFile? _capturedImage;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    setState(() {});
  }

  Future<void> _takePicture() async {
    if (!_cameraController!.value.isInitialized) return;

    final image = await _cameraController!.takePicture();
    setState(() {
      _capturedImage = image;
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Paso 2: Subir imágenes")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _initializeCamera,
              child: const Text("Abrir cámara"),
            ),
            const SizedBox(height: 10),
            if (_cameraController != null &&
                _cameraController!.value.isInitialized)
              Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1, // Cuadro 4x4 (cuadrado)
                    child: CameraPreview(_cameraController!),
                  ),
                  ElevatedButton(
                    onPressed: _takePicture,
                    child: const Text("Tomar foto"),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            if (_capturedImage != null)
              Column(
                children: [
                  const Text("Foto capturada:"),
                  Image.file(File(_capturedImage!.path)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
