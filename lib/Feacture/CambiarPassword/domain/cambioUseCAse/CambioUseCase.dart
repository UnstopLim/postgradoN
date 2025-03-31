import 'package:postgrado/Feacture/CambiarPassword/data/repository/CambioRepository.dart';

class CambioUseCase
{
  final CambioRepository cambioRepository;
  CambioUseCase(this.cambioRepository);

  Future<Map<String,dynamic>?> execute(String password,String NewPassword,String NewPassword2)
  async
  {
    return await cambioRepository.UpdatePassword(password, NewPassword, NewPassword2);
  }

}