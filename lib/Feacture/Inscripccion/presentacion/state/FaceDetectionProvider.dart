// face_detection_provider.dart
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:async';

class FaceDetectionProvider extends ChangeNotifier {
  // ========== PROPIEDADES PRIVADAS ==========
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isLoading = false;
  XFile? _capturedImage;
  bool _faceDetected = false;
  bool _realPersonDetected = false;
  bool _faceCentered = false;
  bool _faceComplete = false;
  String _detectionStatus = '';
  Timer? _detectionTimer;
  bool _isAnalyzing = false;
  bool _isCapturing = false;

  // Dimensiones del marco de referencia
  static const double FRAME_WIDTH = 280.0;
  static const double FRAME_HEIGHT = 350.0;
  static const double CENTER_TOLERANCE = 50.0;
  static const double MIN_FACE_SIZE_RATIO = 0.4;

  // Detector facial
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
      enableClassification: true,
      enableTracking: true,
      minFaceSize: 0.15,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );

  // ========== GETTERS PÚBLICOS ==========
  CameraController? get cameraController => _cameraController;
  bool get isCameraInitialized => _isCameraInitialized;
  bool get isLoading => _isLoading;
  XFile? get capturedImage => _capturedImage;
  bool get faceDetected => _faceDetected;
  bool get realPersonDetected => _realPersonDetected;
  bool get faceCentered => _faceCentered;
  bool get faceComplete => _faceComplete;
  String get detectionStatus => _detectionStatus;
  bool get isAnalyzing => _isAnalyzing;
  bool get isCapturing => _isCapturing;

  bool get canTakePhoto {
    return _faceDetected &&
        _realPersonDetected &&
        _faceCentered &&
        _faceComplete &&
        _isCameraInitialized &&
        !_isLoading;
  }

  // ========== MÉTODOS PÚBLICOS ==========

  /// Inicializa la cámara y el detector facial
  Future<void> initializeCamera() async {
    try {
      final cameraPermission = await Permission.camera.request();
      if (cameraPermission != PermissionStatus.granted) {
        _updateDetectionStatus('Permiso de cámara denegado');
        return;
      }

      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        _updateDetectionStatus('No se encontraron cámaras');
        return;
      }

      final frontCamera = _cameras!.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController!.initialize();

      _isCameraInitialized = true;
      _updateDetectionStatus('Posiciona tu rostro centrado en el marco');
      notifyListeners();

      _startPeriodicDetection();
    } catch (e) {
      _updateDetectionStatus('Error al inicializar cámara: $e');
    }
  }

  /// Maneja el ciclo de vida de la aplicación
  void handleAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _detectionTimer?.cancel();
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initializeCamera();
    }
  }

  /// Toma una foto cuando se cumplen todas las condiciones
  Future<void> takePicture() async {
    if (!canTakePhoto || _isCapturing) return;

    _detectionTimer?.cancel();
    _isCapturing = true;
    _isLoading = true;
    _updateDetectionStatus('Capturando imagen verificada...');

    try {
      final XFile picture = await _cameraController!.takePicture();
      _capturedImage = picture;
      _isLoading = false;
      _updateDetectionStatus('✅ Imagen capturada y verificada correctamente');
    } catch (e) {
      _isLoading = false;
      _updateDetectionStatus('Error al tomar foto: $e');
      _startPeriodicDetection();
    } finally {
      _isCapturing = false;
      notifyListeners();
    }
  }

  /// Reinicia el proceso de captura
  void retakePicture() {
    _isCapturing = false;
    _capturedImage = null;
    _faceDetected = false;
    _realPersonDetected = false;
    _faceCentered = false;
    _faceComplete = false;
    _updateDetectionStatus('Reiniciando análisis...');
    _startPeriodicDetection();
  }

  /// Limpia recursos
  void dispose() {
    _detectionTimer?.cancel();
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  // ========== MÉTODOS PRIVADOS ==========

  void _updateDetectionStatus(String status) {
    _detectionStatus = status;
    notifyListeners();
  }

  void _startPeriodicDetection() {
    _detectionTimer = Timer.periodic(Duration(milliseconds: 600), (timer) async {
      if (!_isCameraInitialized || _cameraController == null || _isAnalyzing || _capturedImage != null) {
        return;
      }
      await _analyzeCurrentFrame();
    });
  }

  Future<void> _analyzeCurrentFrame() async {
    if (_isAnalyzing || _isCapturing) return;

    _isAnalyzing = true;

    try {
      if (_isCapturing) {
        _isAnalyzing = false;
        return;
      }

      _isCapturing = true;
      final XFile tempImage = await _cameraController!.takePicture();
      _isCapturing = false;

      final inputImage = InputImage.fromFilePath(tempImage.path);
      final List<Face> faces = await _faceDetector.processImage(inputImage);

      final bool hasFace = faces.isNotEmpty;
      bool isRealPerson = false;
      bool isCentered = false;
      bool isComplete = false;

      if (hasFace) {
        final Face face = faces.first;
        final imageSize = await _getImageSize(tempImage.path);

        isRealPerson = _analyzeRealPerson(face);
        isCentered = _analyzeFaceCentering(face, imageSize);
        isComplete = _analyzeFaceCompleteness(face, imageSize);
      }

      // Actualizar estado solo si hay cambios
      if (_faceDetected != hasFace ||
          _realPersonDetected != isRealPerson ||
          _faceCentered != isCentered ||
          _faceComplete != isComplete) {

        _faceDetected = hasFace;
        _realPersonDetected = isRealPerson;
        _faceCentered = isCentered;
        _faceComplete = isComplete;
        _detectionStatus = _getDetectionMessage();
        notifyListeners();
      }

      try {
        await File(tempImage.path).delete();
      } catch (e) {
        // Ignorar errores de eliminación
      }
    } catch (e) {
      print('Error en análisis de frame: $e');
    } finally {
      _isAnalyzing = false;
    }
  }

  Future<Size> _getImageSize(String imagePath) async {
    final File imageFile = File(imagePath);
    final bytes = await imageFile.readAsBytes();
    final image = await decodeImageFromList(bytes);
    return Size(image.width.toDouble(), image.height.toDouble());
  }

  bool _analyzeFaceCentering(Face face, Size imageSize) {
    final boundingBox = face.boundingBox;

    final faceCenterX = boundingBox.left + (boundingBox.width / 2);
    final faceCenterY = boundingBox.top + (boundingBox.height / 2);

    final imageCenterX = imageSize.width / 2;
    final imageCenterY = imageSize.height / 2;

    final distanceX = (faceCenterX - imageCenterX).abs();
    final distanceY = (faceCenterY - imageCenterY).abs();

    final toleranceX = imageSize.width * 0.15;
    final toleranceY = imageSize.height * 0.12;

    return distanceX < toleranceX && distanceY < toleranceY;
  }

  bool _analyzeFaceCompleteness(Face face, Size imageSize) {
    final boundingBox = face.boundingBox;
    const double MARGIN = 20.0;

    bool notCutOffLeft = boundingBox.left > MARGIN;
    bool notCutOffRight = boundingBox.right < (imageSize.width - MARGIN);
    bool notCutOffTop = boundingBox.top > MARGIN;
    bool notCutOffBottom = boundingBox.bottom < (imageSize.height - MARGIN);

    final faceArea = boundingBox.width * boundingBox.height;
    final imageArea = imageSize.width * imageSize.height;
    final faceRatio = faceArea / imageArea;

    bool adequateSize = faceRatio > 0.08;
    bool notTooLarge = faceRatio < 0.4;

    final aspectRatio = boundingBox.width / boundingBox.height;
    bool normalAspectRatio = aspectRatio > 0.6 && aspectRatio < 1.4;

    return notCutOffLeft &&
        notCutOffRight &&
        notCutOffTop &&
        notCutOffBottom &&
        adequateSize &&
        notTooLarge &&
        normalAspectRatio;
  }

  bool _analyzeRealPerson(Face face) {
    double confidence = 0.0;
    int checks = 0;

    if (face.landmarks.isNotEmpty) {
      confidence += 0.2;
      checks++;
    }

    if (face.leftEyeOpenProbability != null && face.rightEyeOpenProbability != null) {
      checks++;
      final leftEyeOpen = face.leftEyeOpenProbability! > 0.3;
      final rightEyeOpen = face.rightEyeOpenProbability! > 0.3;

      if (leftEyeOpen && rightEyeOpen) {
        confidence += 0.3;
      } else if (leftEyeOpen || rightEyeOpen) {
        confidence += 0.15;
      }
    }

    if (face.smilingProbability != null) {
      checks++;
      confidence += face.smilingProbability! * 0.1;
    }

    if (face.headEulerAngleY != null && face.headEulerAngleX != null) {
      checks++;
      final headYaw = face.headEulerAngleY!.abs();
      final headPitch = face.headEulerAngleX!.abs();

      if (headYaw < 20 && headPitch < 20) {
        confidence += 0.25;
      } else if (headYaw < 35 && headPitch < 35) {
        confidence += 0.1;
      }
    }

    if (face.contours.isNotEmpty) {
      confidence += 0.15;
      checks++;
    }

    return checks >= 3 && confidence > 0.5;
  }

  String _getDetectionMessage() {
    if (!_faceDetected) {
      return '👤 Coloca tu rostro en el marco';
    }

    if (!_faceComplete) {
      return '⚠️ Asegúrate que tu rostro esté completo en el marco';
    }

    if (!_faceCentered) {
      return '🎯 Centra tu rostro en el marco';
    }

    if (!_realPersonDetected) {
      return '🔍 Verificando autenticidad del rostro...';
    }

    return '✅ ¡Perfecto! Rostro centrado y verificado - Puedes tomar la foto';
  }
}