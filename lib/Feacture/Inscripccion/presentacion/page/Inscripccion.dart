// inscripcion_refactored.dart
import 'dart:async';
import 'dart:io';
import 'package:auto_route/annotations.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:postgrado/Feacture/Inscripccion/presentacion/state/InscripccionController.dart';
import 'package:postgrado/Feacture/Inscripccion/presentacion/state/InscripccionProvider.dart';
// Importa tu nuevo provider aquí:
// import 'inscripcion_ui_provider.dart';


@RoutePage()
class Inscripccion extends ConsumerStatefulWidget {
  const Inscripccion({super.key});

  @override
  ConsumerState<Inscripccion> createState() => _InscripccionState();
}

class _InscripccionState extends ConsumerState<Inscripccion> with WidgetsBindingObserver {

  //==================================================0foto 4*4
  // *** NUEVAS VARIABLES PARA FOTO 4X4 ***
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

  // Dimensiones del marco
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Tus inicializaciones existentes aquí si las tienes
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
    if (cameraController == null || !cameraController.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      _detectionTimer?.cancel();
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

// ========== PASO 4: AGREGAR MÉTODOS DE CÁMARA Y DETECCIÓN ==========
// Agrega estos métodos después de tus métodos existentes:

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
        ResolutionPreset.high,
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
        // Ignorar errores
      }
    } catch (e) {
      print('Error en análisis: $e');
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
    return notCutOffLeft && notCutOffRight && notCutOffTop && notCutOffBottom &&
        adequateSize && notTooLarge && normalAspectRatio;
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
    if (!_faceDetected) return '👤 Coloca tu rostro en el marco';
    if (!_faceComplete) return '⚠️ Asegúrate que tu rostro esté completo en el marco';
    if (!_faceCentered) return '🎯 Centra tu rostro en el marco';
    if (!_realPersonDetected) return '🔍 Verificando autenticidad del rostro...';
    return '✅ ¡Perfecto! Rostro centrado y verificado - Puedes tomar la foto';
  }

  bool get _canTakePhoto {
    return _faceDetected && _realPersonDetected && _faceCentered &&
        _faceComplete && _isCameraInitialized && !_isLoading;
  }

  Future<void> _takePicture() async {
    if (!_canTakePhoto || _isCapturing) return;
    _detectionTimer?.cancel();
    _isCapturing = true;

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
      _isCapturing = false;
    } catch (e) {
      _isCapturing = false;
      setState(() {
        _isLoading = false;
        _detectionStatus = 'Error al tomar foto: $e';
      });
      _startPeriodicDetection();
    }
  }

  void _retakePicture() {
    _isCapturing = false;
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

  //==================================================0foto 4*4



  // Función para subir imágenes (mantiene la referencia a tu provider original)
  Future<void> _uploadImages() async {
    final uiState = ref.read(inscripcionUIProvider);

    if (!uiState.canContinue) {
      ref.read(inscripcionUIProvider.notifier).showSnackBar(
          context,
          "Por favor, escanea todas las imágenes y selecciona la fecha de vencimiento"
      );
      return;
    }

    try {
      // Aquí usas tu provider original sin modificarlo
      await ref.read(inscripcionProvider.notifier).uploadImages(
        frontImagePath: uiState.frontImagePath!,
        backImagePath: uiState.backImagePath!,
        frontTituloPath: uiState.fromTituloImage!,
        backTituloPath: uiState.backTituloImage!,
        expiryDate: uiState.formattedExpiryDate,
      );
    } catch (e) {
      ref.read(inscripcionUIProvider.notifier).showSnackBar(
          context,
          "Error al subir imágenes: $e"
      );
    }
  }

  Widget _buildScanCard({
    required String title,
    required VoidCallback onScan,
    required String? imagePath,
    required IconData icon,
  }) {
    return Container(
      margin: ResponsiveHelper.getResponsiveMargin(context),
      padding: ResponsiveHelper.getResponsivePadding(context),
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        border: Border.all(color: Color(0xff00345c)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4)
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                  icon,
                  color: const Color(0xFF003465),
                  size: ResponsiveHelper.getResponsiveFontSize(context, 28)
              ),
              SizedBox(width: MediaQuery.of(context).size.width < 360 ? 8 : 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, 18),
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.width < 360 ? 8 : 10),
          ElevatedButton.icon(
            icon: Icon(
              Icons.camera_alt_outlined,
              size: ResponsiveHelper.getResponsiveFontSize(context, 20),
            ),
            label: Text(
              "Escanear",
              style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16)
              ),
            ),
            onPressed: onScan,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003465),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.width < 360 ? 10 : 12,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.width < 360 ? 10 : 14),
          if (imagePath != null)
            GestureDetector(
              onTap: () => ref.read(inscripcionUIProvider.notifier)
                  .showFullScreenImage(context, imagePath),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(imagePath),
                  height: ResponsiveHelper.getResponsiveImageHeight(context),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              height: ResponsiveHelper.getResponsiveImageHeight(context),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                "Aún no escaneado",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExpiryDateCard() {
    final uiState = ref.watch(inscripcionUIProvider);

    return Container(
      margin: ResponsiveHelper.getResponsiveMargin(context),
      padding: ResponsiveHelper.getResponsivePadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xff01264c)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                  Icons.calendar_today,
                  color: const Color(0xFF003465),
                  size: ResponsiveHelper.getResponsiveFontSize(context, 28)
              ),
              SizedBox(width: MediaQuery.of(context).size.width < 360 ? 8 : 10),
              Expanded(
                child: Text(
                  "Fecha de vencimiento del carnet",
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, 18),
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.width < 360 ? 8 : 10),
          ElevatedButton.icon(
            icon: Icon(
              Icons.date_range_outlined,
              size: ResponsiveHelper.getResponsiveFontSize(context, 20),
            ),
            label: Text(
              "Seleccionar fecha",
              style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16)
              ),
            ),
            onPressed: () => ref.read(inscripcionUIProvider.notifier)
                .selectExpiryDate(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003465),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.width < 360 ? 10 : 12,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.width < 360 ? 10 : 14),
          Container(
            padding: EdgeInsets.all(
                MediaQuery.of(context).size.width < 360 ? 12 : 16
            ),
            decoration: BoxDecoration(
              color: uiState.selectedExpiryDate != null
                  ? Colors.green.shade50
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: uiState.selectedExpiryDate != null
                      ? Colors.green.shade300
                      : Colors.grey.shade300
              ),
            ),
            child: Row(
              children: [
                Icon(
                  uiState.selectedExpiryDate != null
                      ? Icons.check_circle
                      : Icons.schedule,
                  color: uiState.selectedExpiryDate != null
                      ? Colors.green
                      : Colors.grey,
                  size: ResponsiveHelper.getResponsiveFontSize(context, 20),
                ),
                SizedBox(width: MediaQuery.of(context).size.width < 360 ? 8 : 12),
                Expanded(
                  child: Text(
                    uiState.selectedExpiryDate != null
                        ? "Fecha seleccionada: ${uiState.displayExpiryDate}"
                        : "Aún no seleccionada",
                    style: TextStyle(
                      color: uiState.selectedExpiryDate != null
                          ? Colors.green.shade700
                          : Colors.grey,
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
                      fontWeight: uiState.selectedExpiryDate != null
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionTile({
    required String stepNumber,
    required String title,
    required List<Widget> children,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth < 360 ? 12 : 16,
        vertical: screenWidth < 360 ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Color(0xff001d3a)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.white,
              blurRadius: 10,
              offset: Offset(0, 6)
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFFD3A203),
            radius: screenWidth < 360 ? 18 : 20,
            child: Text(
              stepNumber,
              style: TextStyle(
                color: Colors.black,
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
              ),
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 18),
              fontWeight: FontWeight.bold,
              color: Color(0xFF000407),
            ),
          ),
          iconColor: const Color(0xFF0081FF),
          collapsedIconColor: Colors.grey.shade600,
          childrenPadding: EdgeInsets.symmetric(
            vertical: screenWidth < 360 ? 8 : 10,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Escuchar el estado de la inscripción (tu provider original)
    ref.listen<InscripcionState>(inscripcionProvider, (previous, next) {
      if (next.isSuccess) {
        ref.read(inscripcionUIProvider.notifier).showSnackBar(
            context,
            "¡Imágenes enviadas exitosamente!"
        );
      } else if (next.error != null) {
        ref.read(inscripcionUIProvider.notifier).showSnackBar(
            context,
            "Error: ${next.error}"
        );
      }
    });

    final uiState = ref.watch(inscripcionUIProvider);
    final inscripcionState = ref.watch(inscripcionProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                "assets/edificio.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
          ListView(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth < 360 ? 4 : 0,
            ),
            children: [
              Center(
                child: Text(
                  "Inscripccion",
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, 20),
                    height: 3,
                  ),
                ),
              ),
              _buildExpansionTile(
                stepNumber: "1",
                title: "Escanear carnet",
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth < 360 ? 16.0 : 20.0,
                    ),
                    child: Text(
                      "Para continuar con tu inscripción, por favor escanea ambos lados de tu carnet de identidad y selecciona la fecha de vencimiento.",
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth < 360 ? 16 : 20),
                  _buildScanCard(
                    title: "Anverso del carnet",
                    onScan: () => ref.read(inscripcionUIProvider.notifier)
                        .scanDocument(1, context),
                    imagePath: uiState.frontImagePath,
                    icon: Icons.credit_card_rounded,
                  ),
                  _buildScanCard(
                    title: "Reverso del carnet",
                    onScan: () => ref.read(inscripcionUIProvider.notifier)
                        .scanDocument(2, context),
                    imagePath: uiState.backImagePath,
                    icon: Icons.flip_camera_android_rounded,
                  ),
                  _buildExpiryDateCard(),
                  SizedBox(height: screenWidth < 360 ? 20 : 30),
                ],
              ),

//??????????????????????????????????????????????????????????????foto 4*4
              _buildExpansionTile(
                stepNumber: "2",
                title: "Foto 4X4",
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth < 360 ? 16.0 : 20.0),
                    child: Text(
                      "Toma una foto 4x4 para tu inscripción. Posiciona tu rostro centrado en el marco y espera la verificación automática.",
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth < 360 ? 16 : 20),

                  // Status card
                  Container(
                    margin: ResponsiveHelper.getResponsiveMargin(context),
                    padding: ResponsiveHelper.getResponsivePadding(context),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _canTakePhoto ? Colors.green : _faceDetected ? Colors.orange : Colors.red,
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
                                color: _canTakePhoto ? Colors.green : _faceDetected ? Colors.orange : Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _detectionStatus,
                                style: const TextStyle(
                                  color: Colors.black87,
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
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
                                ),
                              ),
                          ],
                        ),
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
                  Container(
                    margin: ResponsiveHelper.getResponsiveMargin(context),
                    height: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: _capturedImage != null ? _buildCapturedImage() : _buildCameraPreview(),
                    ),
                  ),

                  SizedBox(height: screenWidth < 360 ? 16 : 20),

                  // Action buttons
                  Padding(
                    padding: ResponsiveHelper.getResponsivePadding(context),
                    child: _capturedImage != null ? _buildImageActions() : _buildCameraActions(),
                  ),

                  SizedBox(height: screenWidth < 360 ? 20 : 30),
                ],
              ),




              _buildExpansionTile(
                stepNumber: "3",
                title: "Escanear Documentación académica",
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth < 360 ? 16.0 : 20.0,
                    ),
                    child: Text(
                      "Por favor escanea ambos lados de documentacion academica.",
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth < 360 ? 16 : 20),
                  _buildScanCard(
                    title: "Anverso del Titulo",
                    onScan: () => ref.read(inscripcionUIProvider.notifier)
                        .scanDocument(3, context),
                    imagePath: uiState.fromTituloImage,
                    icon: Icons.credit_card_rounded,
                  ),
                  _buildScanCard(
                    title: "Reverso del Titulo",
                    onScan: () => ref.read(inscripcionUIProvider.notifier)
                        .scanDocument(4, context),
                    imagePath: uiState.backTituloImage,
                    icon: Icons.flip_camera_android_rounded,
                  ),
                  SizedBox(height: screenWidth < 360 ? 20 : 30),
                ],
              ),
              SizedBox(height: screenWidth < 360 ? 20 : 30),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth < 360 ? 16.0 : 20.0,
                ),
                child: ElevatedButton.icon(
                  icon: inscripcionState.isLoading
                      ? SizedBox(
                    width: screenWidth < 360 ? 14 : 16,
                    height: screenWidth < 360 ? 14 : 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : Icon(
                    Icons.arrow_forward_rounded,
                    size: ResponsiveHelper.getResponsiveFontSize(context, 20),
                  ),
                  label: Text(
                    inscripcionState.isLoading ? "Enviando..." : "Siguiente",
                    style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16)
                    ),
                  ),
                  onPressed: (uiState.canContinue && !inscripcionState.isLoading)
                      ? _uploadImages
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (uiState.canContinue && !inscripcionState.isLoading)
                        ? const Color(0xFF003465)
                        : Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: screenWidth < 360 ? 14 : 16,
                    ),
                    textStyle: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16)
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenWidth < 360 ? 20 : 30)
            ],
          ),
        ],
      ),
    );
  }


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

  Widget _buildCameraPreview() {
    if (!_isCameraInitialized || _cameraController == null) {
      return Container(
        color: Colors.grey[200],
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF003465)),
              SizedBox(height: 16),
              Text('Inicializando cámara...', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (!_isCameraInitialized) {
          _initializeCamera();
        }
      },
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
          Center(
            child: Container(
              width: FRAME_WIDTH,
              height: FRAME_HEIGHT,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _canTakePhoto ? Colors.green : _faceDetected ? Colors.orange : Colors.white70,
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
              child: _canTakePhoto ? Stack(
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
                      child: Icon(Icons.check, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ) : null,
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
                    Text('Capturando imagen...', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCapturedImage() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Transform.scale(
          scaleX: -1,
          child: Image.file(
            File(_capturedImage!.path),
            fit: BoxFit.cover,
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
              child: const Icon(Icons.verified_user, color: Colors.white, size: 24),
            ),
          ),
      ],
    );
  }

  Widget _buildCameraActions() {
    return Column(
      children: [
        if (!_isCameraInitialized)
          ElevatedButton.icon(
            onPressed: _initializeCamera,
            icon: Icon(Icons.camera_alt, size: 24),
            label: Text('Inicializar Cámara', style: TextStyle(fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003465),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          )
        else
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _canTakePhoto ? _takePicture : null,
              //backgroundColor: _canTakePhoto ? Colors.green : Colors.grey[600],
              icon: Icon(Icons.camera_alt, color: Colors.white, size: 28),
              label: Text(
                _canTakePhoto ? 'CAPTURAR FOTO 4x4' : 'POSICIONA TU ROSTRO',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _retakePicture,
            //backgroundColor: Colors.orange,
            icon: const Icon(Icons.refresh, color: Colors.black),
            label: const Text('Nueva Foto', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        SizedBox(width: 16),
        if (_canTakePhoto)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.black),
                        SizedBox(width: 8),
                        Text('Foto 4x4 guardada correctamente'),
                      ],
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              //backgroundColor: Colors.green,
              icon: const Icon(Icons.verified, color: Colors.black),
              label: const Text('CONFIRMAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
      ],
    );
  }



}