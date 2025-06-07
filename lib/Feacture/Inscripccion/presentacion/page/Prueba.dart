import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:async';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> with WidgetsBindingObserver {

  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isLoading = false;
  XFile? _capturedImage;
  bool _faceDetected = false;
  bool _realPersonDetected = false;
  bool _faceCentered = false; // Nueva variable para centrado
  bool _faceComplete = false; // Nueva variable para rostro completo
  String _detectionStatus = '';

  Timer? _detectionTimer;
  bool _isAnalyzing = false;

  // Dimensiones del marco de referencia
  static const double FRAME_WIDTH = 280.0;
  static const double FRAME_HEIGHT = 350.0;
  static const double CENTER_TOLERANCE = 50.0; // Tolerancia para el centrado
  static const double MIN_FACE_SIZE_RATIO = 0.4; // Mínimo 40% del marco

  // ========== CONFIGURACIÓN DEL DETECTOR FACIAL ML KIT ==========
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
      enableClassification: true,
      enableTracking: true,
      minFaceSize: 0.15, // Aumentado para rostros más grandes
      performanceMode: FaceDetectorMode.accurate, // Cambiado a accurate
    ),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    _detectionTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;

    if (cameraController == null || !cameraController.value.isInitialized) {return;}

    if (state == AppLifecycleState.inactive) {
      _detectionTimer?.cancel();
      cameraController.dispose();
    }
    else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  // ========== INICIALIZACIÓN ==========
  Future<void> _initializeCamera() async {
    try {
      final cameraPermission = await Permission.camera.request();
      if (cameraPermission != PermissionStatus.granted) {
        setState(() {
          _detectionStatus = 'Permiso de cámara denegado';
        });
        return;
      }

      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        setState(() {
          _detectionStatus = 'No se encontraron cámaras';
        });
        return;
      }

      final frontCamera = _cameras!.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high, // Cambiado a high para mejor detección
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController!.initialize();

      setState(() {
        _isCameraInitialized = true;
        _detectionStatus = 'Posiciona tu rostro centrado en el marco';
      });

      _startPeriodicDetection();

    } catch (e) {
      setState(() {
        _detectionStatus = 'Error al inicializar cámara: $e';
      });
    }
  }

  // ========== ANÁLISIS CONTINUO EN TIEMPO REAL ==========
  void _startPeriodicDetection() {
    _detectionTimer = Timer.periodic(Duration(milliseconds: 600), (timer) async {
      if (!_isCameraInitialized || _cameraController == null || _isAnalyzing || _capturedImage != null) {
        return;
      }
      await _analyzeCurrentFrame();
    });
  }

  // ========== ANÁLISIS DE FRAME INDIVIDUAL ==========
  Future<void> _analyzeCurrentFrame() async {
    if (_isAnalyzing) return;

    _isAnalyzing = true;

    try {
      final XFile tempImage = await _cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(tempImage.path);
      final List<Face> faces = await _faceDetector.processImage(inputImage);

      final bool hasFace = faces.isNotEmpty;
      bool isRealPerson = false;
      bool isCentered = false;
      bool isComplete = false;

      if (hasFace) {
        final Face face = faces.first;

        // Obtener dimensiones de la imagen
        final imageSize = await _getImageSize(tempImage.path);

        // Análisis completo del rostro
        isRealPerson = _analyzeRealPerson(face);
        isCentered = _analyzeFaceCentering(face, imageSize);
        isComplete = _analyzeFaceCompleteness(face, imageSize);
      }

      // Actualizar estado solo si hay cambios
      if (_faceDetected != hasFace ||
          _realPersonDetected != isRealPerson ||
          _faceCentered != isCentered ||
          _faceComplete != isComplete) {

        setState(() {
          _faceDetected = hasFace;
          _realPersonDetected = isRealPerson;
          _faceCentered = isCentered;
          _faceComplete = isComplete;

          _detectionStatus = _getDetectionMessage();
        });
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

  // ========== OBTENER TAMAÑO DE IMAGEN ==========
  Future<Size> _getImageSize(String imagePath) async {
    final File imageFile = File(imagePath);
    final bytes = await imageFile.readAsBytes();
    final image = await decodeImageFromList(bytes);
    return Size(image.width.toDouble(), image.height.toDouble());
  }

  // ========== ANÁLISIS DE CENTRADO DEL ROSTRO ==========
  bool _analyzeFaceCentering(Face face, Size imageSize) {
    final boundingBox = face.boundingBox;

    // Calcular el centro del rostro
    final faceCenterX = boundingBox.left + (boundingBox.width / 2);
    final faceCenterY = boundingBox.top + (boundingBox.height / 2);

    // Calcular el centro de la imagen
    final imageCenterX = imageSize.width / 2;
    final imageCenterY = imageSize.height / 2;

    // Calcular la distancia desde el centro
    final distanceX = (faceCenterX - imageCenterX).abs();
    final distanceY = (faceCenterY - imageCenterY).abs();

    // Tolerancia basada en el tamaño de la imagen
    final toleranceX = imageSize.width * 0.15; // 15% de tolerancia horizontal
    final toleranceY = imageSize.height * 0.12; // 12% de tolerancia vertical

    return distanceX < toleranceX && distanceY < toleranceY;
  }

  // ========== ANÁLISIS DE COMPLETITUD DEL ROSTRO ==========
  bool _analyzeFaceCompleteness(Face face, Size imageSize) {
    final boundingBox = face.boundingBox;

    // Verificar que el rostro no esté cortado por los bordes
    const double MARGIN = 20.0; // Margen mínimo desde los bordes

    bool notCutOffLeft = boundingBox.left > MARGIN;
    bool notCutOffRight = boundingBox.right < (imageSize.width - MARGIN);
    bool notCutOffTop = boundingBox.top > MARGIN;
    bool notCutOffBottom = boundingBox.bottom < (imageSize.height - MARGIN);

    // Verificar tamaño mínimo del rostro
    final faceArea = boundingBox.width * boundingBox.height;
    final imageArea = imageSize.width * imageSize.height;
    final faceRatio = faceArea / imageArea;

    bool adequateSize = faceRatio > 0.08; // Al menos 8% de la imagen
    bool notTooLarge = faceRatio < 0.4; // No más del 40% de la imagen

    // Verificar que el rostro tenga proporciones normales
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

  // ========== ANÁLISIS DE PERSONA REAL (MEJORADO) ==========
  bool _analyzeRealPerson(Face face) {
    double confidence = 0.0;
    int checks = 0;

    // Verificar que tenga landmarks importantes
    if (face.landmarks.isNotEmpty) {
      confidence += 0.2;
      checks++;
    }

    // Verificación ojos abiertos (más estricta)
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

    // Verificación sonrisa (opcional pero ayuda)
    if (face.smilingProbability != null) {
      checks++;
      confidence += face.smilingProbability! * 0.1;
    }

    // Verificación rotación de cabeza (debe estar relativamente frontal)
    if (face.headEulerAngleY != null && face.headEulerAngleX != null) {
      checks++;
      final headYaw = face.headEulerAngleY!.abs();
      final headPitch = face.headEulerAngleX!.abs();

      // Penalizar rotaciones extremas
      if (headYaw < 20 && headPitch < 20) {
        confidence += 0.25;
      } else if (headYaw < 35 && headPitch < 35) {
        confidence += 0.1;
      }
    }

    // Verificación de contornos faciales
    if (face.contours.isNotEmpty) {
      confidence += 0.15;
      checks++;
    }

    return checks >= 3 && confidence > 0.5;
  }

  // ========== GENERAR MENSAJE DE ESTADO ==========
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

  // ========== VERIFICAR SI PUEDE TOMAR FOTO ==========
  bool get _canTakePhoto {
    return _faceDetected &&
        _realPersonDetected &&
        _faceCentered &&
        _faceComplete &&
        _isCameraInitialized &&
        !_isLoading;
  }

  // ========== CAPTURA DE IMAGEN FINAL ==========
  Future<void> _takePicture() async {
    if (!_canTakePhoto) return;

    _detectionTimer?.cancel();

    setState(() {
      _isLoading = true;
      _detectionStatus = 'Capturando imagen verificada...';
    });

    try {
      final XFile picture = await _cameraController!.takePicture();

      setState(() {
        _capturedImage = picture;
        _isLoading = false;
        _detectionStatus = '✅ Imagen capturada y verificada correctamente';
      });

    } catch (e) {
      setState(() {
        _isLoading = false;
        _detectionStatus = 'Error al tomar foto: $e';
      });
      _startPeriodicDetection();
    }
  }

  // ========== REINICIAR PROCESO ==========
  void _retakePicture() {
    setState(() {
      _capturedImage = null;
      _faceDetected = false;
      _realPersonDetected = false;
      _faceCentered = false;
      _faceComplete = false;
      _detectionStatus = 'Reiniciando análisis...';
    });

    _startPeriodicDetection();
  }

  // ========== CONSTRUCCIÓN DE LA INTERFAZ ==========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text(
          'Detección Facial AI - Centrado Completo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Status card mejorado
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _canTakePhoto
                      ? Colors.green
                      : _faceDetected
                      ? Colors.orange
                      : Colors.red,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (_canTakePhoto ? Colors.green : _faceDetected ? Colors.orange : Colors.red).withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: _canTakePhoto
                              ? Colors.green
                              : _faceDetected
                              ? Colors.orange
                              : Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _detectionStatus,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (_isAnalyzing)
                        Container(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                          ),
                        ),
                    ],
                  ),

                  // Indicadores de estado
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatusIndicator('Rostro', _faceDetected),
                      _buildStatusIndicator('Completo', _faceComplete),
                      _buildStatusIndicator('Centrado', _faceCentered),
                      _buildStatusIndicator('Verificado', _realPersonDetected),
                    ],
                  ),
                ],
              ),
            ),

            // Camera/Image view
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: _capturedImage != null
                      ? _buildCapturedImage()
                      : _buildCameraPreview(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _capturedImage != null
                  ? _buildImageActions()
                  : _buildCameraActions(),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ========== INDICADOR DE ESTADO ==========
  Widget _buildStatusIndicator(String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: isActive ? Colors.green : Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.green : Colors.grey,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ========== CAMERA PREVIEW WIDGET ==========
  Widget _buildCameraPreview() {
    if (!_isCameraInitialized || _cameraController == null) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.deepPurple),
              SizedBox(height: 16),
              Text(
                'Inicializando cámara y análisis...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRect(
              child: OverflowBox(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * _cameraController!.value.aspectRatio,
                    child: Transform.scale(
                      scaleX: -1,
                      child: CameraPreview(_cameraController!),
                    ),
                  ),
                ),
              ),
            ),

            // Marco de guía mejorado
            Center(
              child: Container(
                width: FRAME_WIDTH,
                height: FRAME_HEIGHT,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _canTakePhoto
                        ? Colors.green
                        : _faceDetected
                        ? Colors.orange
                        : Colors.white70,
                    width: _canTakePhoto ? 4 : 3,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: _canTakePhoto ? [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ] : null,
                ),
                child: _canTakePhoto
                    ? Stack(
                  children: [
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                )
                    : null,
              ),
            ),

            // Líneas de guía para centrado
            if (_faceDetected && !_faceCentered)
              Center(
                child: Container(
                  width: FRAME_WIDTH,
                  height: FRAME_HEIGHT,
                  child: CustomPaint(
                    painter: GuideLinesPainter(),
                  ),
                ),
              ),

            if (_isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 16),
                      Text(
                        'Capturando imagen verificada...',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ========== CAPTURED IMAGE WIDGET ==========
  Widget _buildCapturedImage() {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRect(
            child: OverflowBox(
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  child: Transform.scale(
                    scaleX: -1,
                    child: Image.file(
                      File(_capturedImage!.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_canTakePhoto)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.verified_user,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ========== CAMERA ACTION BUTTONS ==========
  Widget _buildCameraActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 220,
          height: 60,
          child: FloatingActionButton.extended(
            onPressed: _canTakePhoto ? _takePicture : null,
            backgroundColor: _canTakePhoto ? Colors.green : Colors.grey[600],
            elevation: _canTakePhoto ? 8 : 2,
            icon: Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 28,
            ),
            label: Text(
              _canTakePhoto ? 'CAPTURAR FOTO 4x4' : 'POSICIONA TU ROSTRO',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ========== IMAGE ACTION BUTTONS ==========
  Widget _buildImageActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton.extended(
          onPressed: _retakePicture,
          backgroundColor: Colors.orange,
          elevation: 6,
          icon: const Icon(Icons.refresh, color: Colors.white),
          label: const Text(
            'Nueva Foto',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        if (_canTakePhoto)
          FloatingActionButton.extended(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Foto 4x4 capturada correctamente'),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            backgroundColor: Colors.green,
            elevation: 6,
            icon: const Icon(Icons.verified, color: Colors.white),
            label: const Text(
              'FOTO 4x4 OK',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}

// ========== PAINTER PARA LÍNEAS DE GUÍA ==========
class GuideLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Línea vertical central
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );

    // Línea horizontal central
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}