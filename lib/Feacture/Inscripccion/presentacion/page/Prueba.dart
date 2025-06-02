import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
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
  String _detectionStatus = '';

  // Timer para análisis periódico con capturas temporales
  Timer? _detectionTimer;
  bool _isAnalyzing = false;

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
      enableClassification: true,
      enableTracking: true,
      minFaceSize: 0.15,
      performanceMode: FaceDetectorMode.fast,
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
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _detectionTimer?.cancel();
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

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
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController!.initialize();

      setState(() {
        _isCameraInitialized = true;
        _detectionStatus = 'Posiciona tu rostro en el marco - Analizando...';
      });

      // Iniciar análisis periódico con capturas temporales
      _startPeriodicDetection();

    } catch (e) {
      setState(() {
        _detectionStatus = 'Error al inicializar cámara: $e';
      });
    }
  }

  // MÉTODO ALTERNATIVO: Análisis periódico con capturas temporales
  void _startPeriodicDetection() {
    _detectionTimer = Timer.periodic(Duration(milliseconds: 800), (timer) async {
      if (!_isCameraInitialized ||
          _cameraController == null ||
          _isAnalyzing ||
          _capturedImage != null) {
        return;
      }

      await _analyzeCurrentFrame();
    });
  }

  // MÉTODO PARA CAPTURAR Y ANALIZAR FRAME ACTUAL
  Future<void> _analyzeCurrentFrame() async {
    if (_isAnalyzing) return;

    _isAnalyzing = true;

    try {
      // Capturar imagen temporal para análisis
      final XFile tempImage = await _cameraController!.takePicture();

      // Crear InputImage
      final inputImage = InputImage.fromFilePath(tempImage.path);

      // Detectar rostros
      final List<Face> faces = await _faceDetector.processImage(inputImage);

      // Analizar resultados
      final bool hasFace = faces.isNotEmpty;
      final bool isRealPerson = hasFace ? _analyzeface(faces.first) : false;

      // Actualizar UI solo si cambió el estado
      if (_faceDetected != hasFace || _realPersonDetected != isRealPerson) {
        setState(() {
          _faceDetected = hasFace;
          _realPersonDetected = isRealPerson;

          if (!hasFace) {
            _detectionStatus = '👤 Coloca tu rostro en el marco';
          } else if (!isRealPerson) {
            _detectionStatus = '⚠️ Rostro detectado - Verificando autenticidad...';
          } else {
            _detectionStatus = '✅ Persona real detectada - ¡Puedes tomar la foto!';
          }
        });
      }

      // Eliminar imagen temporal
      try {
        await File(tempImage.path).delete();
      } catch (e) {
        // Ignorar errores de eliminación
      }

    } catch (e) {
      print('Error en análisis de frame: $e');
      // No actualizar UI en caso de error para evitar parpadeo
    } finally {
      _isAnalyzing = false;
    }
  }

  Future<void> _takePicture() async {
    if (!_isCameraInitialized ||
        _cameraController == null ||
        !_realPersonDetected) {
      return;
    }

    // Detener análisis temporal
    _detectionTimer?.cancel();

    setState(() {
      _isLoading = true;
      _detectionStatus = 'Capturando imagen verificada...';
    });

    try {
      final XFile picture = await _cameraController!.takePicture();

      // Verificación final de la imagen capturada
      await _detectFaces(picture);

      setState(() {
        _capturedImage = picture;
        _isLoading = false;
      });

    } catch (e) {
      setState(() {
        _isLoading = false;
        _detectionStatus = 'Error al tomar foto: $e';
      });
      // Reiniciar análisis si hay error
      _startPeriodicDetection();
    }
  }

  Future<void> _detectFaces(XFile imageFile) async {
    try {
      setState(() {
        _detectionStatus = 'Verificación final de la imagen...';
      });

      final inputImage = InputImage.fromFilePath(imageFile.path);
      final List<Face> faces = await _faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        setState(() {
          _faceDetected = false;
          _realPersonDetected = false;
          _detectionStatus = '❌ No se detectó rostro en la imagen capturada';
        });
        return;
      }

      final Face face = faces.first;
      final bool isRealPerson = _analyzeface(face);

      setState(() {
        _faceDetected = faces.isNotEmpty;
        _realPersonDetected = isRealPerson;
        _detectionStatus = isRealPerson
            ? '✅ Verificación completa - Imagen válida con ${faces.length} rostro${faces.length > 1 ? 's' : ''}'
            : '⚠️ Imagen capturada pero la verificación es dudosa';
      });

    } catch (e) {
      setState(() {
        _faceDetected = false;
        _realPersonDetected = false;
        _detectionStatus = 'Error en verificación final: $e';
      });
    }
  }

  bool _analyzeface(Face face) {
    double confidence = 0.0;
    int checks = 0;

    // Verificación de ojos abiertos
    if (face.leftEyeOpenProbability != null) {
      checks++;
      if (face.leftEyeOpenProbability! > 0.1) {
        confidence += 0.25;
      }
    }

    if (face.rightEyeOpenProbability != null) {
      checks++;
      if (face.rightEyeOpenProbability! > 0.1) {
        confidence += 0.25;
      }
    }

    // Verificación de sonrisa (naturalidad)
    if (face.smilingProbability != null) {
      checks++;
      confidence += face.smilingProbability! * 0.15;
    }

    // Verificación de rotación de cabeza (tridimensionalidad)
    if (face.headEulerAngleY != null && face.headEulerAngleX != null) {
      checks++;
      final headMovement = (face.headEulerAngleY!.abs() + face.headEulerAngleX!.abs()) / 2;
      if (headMovement > 2) {
        confidence += 0.2;
      }
    }

    // Verificación del tamaño del rostro (cercanía natural)
    final boundingBox = face.boundingBox;
    final faceArea = boundingBox.width * boundingBox.height;
    if (faceArea > 15000) { // Rostro de tamaño razonable
      confidence += 0.15;
    }

    print('Face analysis - Checks: $checks, Confidence: $confidence');
    print('Left eye: ${face.leftEyeOpenProbability}, Right eye: ${face.rightEyeOpenProbability}');
    print('Smile: ${face.smilingProbability}, Head angles: Y=${face.headEulerAngleY}, X=${face.headEulerAngleX}');

    return checks >= 2 && confidence > 0.35;
  }

  void _retakePicture() {
    setState(() {
      _capturedImage = null;
      _faceDetected = false;
      _realPersonDetected = false;
      _detectionStatus = 'Reiniciando análisis en tiempo real...';
    });

    // Reiniciar análisis periódico
    _startPeriodicDetection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text(
          'Detección Facial AI - Tiempo Real',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Tarjeta de estado mejorada
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _realPersonDetected
                      ? Colors.green
                      : _faceDetected
                      ? Colors.orange
                      : Colors.red,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (_realPersonDetected ? Colors.green : _faceDetected ? Colors.orange : Colors.red).withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Indicador de estado animado
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: _realPersonDetected
                          ? Colors.green
                          : _faceDetected
                          ? Colors.orange
                          : Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (_realPersonDetected ? Colors.green : _faceDetected ? Colors.orange : Colors.red).withOpacity(0.5),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
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
                  // Indicador de análisis
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
            ),

            // Vista principal
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

            // Botones de acción
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
            // Vista previa de cámara
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

            // Marco de guía con estado visual
            Center(
              child: Container(
                width: 280,
                height: 350,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _realPersonDetected
                        ? Colors.green
                        : _faceDetected
                        ? Colors.orange
                        : Colors.white70,
                    width: _realPersonDetected ? 4 : 3,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: _realPersonDetected ? [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ] : null,
                ),
                child: _realPersonDetected
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
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
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

            // Overlay de carga
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
          if (_realPersonDetected)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
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

  Widget _buildCameraActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 200,
          height: 60,
          child: FloatingActionButton.extended(
            onPressed: _isCameraInitialized && !_isLoading && _realPersonDetected
                ? _takePicture
                : null,
            backgroundColor: _realPersonDetected ? Colors.green : Colors.grey[600],
            elevation: _realPersonDetected ? 8 : 2,
            icon: Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 28,
            ),
            label: Text(
              _realPersonDetected ? 'CAPTURAR FOTO' : 'ESPERANDO ROSTRO...',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

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
        if (_realPersonDetected)
          FloatingActionButton.extended(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Verificación exitosa - Imagen válida'),
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
              'VERIFICADO',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}