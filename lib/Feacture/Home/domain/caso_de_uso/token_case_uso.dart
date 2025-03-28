import 'package:postgrado/Feacture/Home/data/repository/tokenRepository.dart';
import 'package:postgrado/Feacture/Home/domain/models/token_models.dart';
import 'package:postgrado/Feacture/Perfil/data/repository/PerfilRepository.dart';

class GetTokenCaseUse
{
  final tokenRepository TokenRepository;
  GetTokenCaseUse(this.TokenRepository);

  Future<Data?> execute()
  async
  {
    return await TokenRepository.getTokenUser();
  }
}