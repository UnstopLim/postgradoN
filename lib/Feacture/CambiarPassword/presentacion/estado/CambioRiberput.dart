
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:postgrado/Core/di/service_locator.dart';
import 'package:postgrado/Feacture/CambiarPassword/domain/cambioUseCAse/CambioUseCase.dart';


final cambioProvider = StateNotifierProvider<CambioNotifier, AsyncValue<bool>>((ref) {
  return CambioNotifier(getIt<CambioUseCase>());
});

class CambioNotifier extends StateNotifier<AsyncValue<bool>> {
  final CambioUseCase cambioUseCase;

  CambioNotifier(this.cambioUseCase) : super(const AsyncValue.data(false));

  Future<void> cambioPassword({
    required String password,
    required String newPassword,
    required String confirmPassword,
  }) async {
    state = const AsyncValue.loading();

    try {
      await cambioUseCase.execute(
        password: password,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      state = const AsyncValue.data(true);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
}
