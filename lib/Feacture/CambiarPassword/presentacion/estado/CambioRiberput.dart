
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:postgrado/Core/di/service_locator.dart';
import 'package:postgrado/Feacture/CambiarPassword/domain/cambioUseCAse/CambioUseCase.dart';

final cambioProvider = StateNotifierProvider<CambioNotifier,String?>((ref){
  return CambioNotifier(getIt<CambioUseCase>());
});

class CambioNotifier extends StateNotifier<String?>
{
   final CambioUseCase cambioUseCase;
   CambioNotifier(this.cambioUseCase): super(null);

   Future<bool> CambioPassword(String password,String NewPassword,String NewPassword2)
  async
  {
    try
    {
       final responce = await cambioUseCase.execute(password, NewPassword, NewPassword2);
       if(responce!=null)
       {
           print(" Se cambio la contraseña corectamente");
           return true;
       }
       else
       {
           print("fallo la contraseña if");
           return false;
       }

    }
    catch(e)
    {
      print("Error de cambio de passowrd try ${e}");
      return false;
    }

  }

}
