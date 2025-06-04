// 1. ACTUALIZACIÓN EN InscripccionProvider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:postgrado/Core/di/service_locator.dart';
import 'package:postgrado/Feacture/Inscripccion/domain/Case_Use/UploadImagesUseCase.dart';

class InscripcionState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;
  final Map<String, dynamic>? response;

  InscripcionState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
    this.response,
  });

  InscripcionState copyWith({
    bool? isLoading,
    String? error,
    bool? isSuccess,
    Map<String, dynamic>? response,
  }) {
    return InscripcionState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
      response: response ?? this.response,
    );
  }
}

class InscripcionNotifier extends StateNotifier<InscripcionState> {
  final UploadImagesUseCase uploadImagesUseCase;

  InscripcionNotifier(this.uploadImagesUseCase) : super(InscripcionState());

  // MÉTODO ACTUALIZADO - Ahora incluye la fecha de vencimiento
  Future<void> uploadImages({
    required String frontImagePath,
    required String backImagePath,
    required String frontTituloPath,
    required String backTituloPath,
    required String expiryDate, // NUEVO PARÁMETRO
  }) async {
    state = state.copyWith(isLoading: true, error: null, isSuccess: false);

    try {
      final result = await uploadImagesUseCase.execute(
        frontImagePath: frontImagePath,
        backImagePath: backImagePath,
        frontTituloPath: frontTituloPath,
        backTituloPath: backTituloPath,
        expiryDate: expiryDate, // PASAR LA FECHA
      );

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        response: result,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isSuccess: false,
      );
    }
  }

  void resetState() {
    state = InscripcionState();
  }
}

final inscripcionProvider = StateNotifierProvider<InscripcionNotifier, InscripcionState>((ref) {
  return InscripcionNotifier(getIt<UploadImagesUseCase>());
});
