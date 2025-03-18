
import 'package:postgrado/Feacture/Perfil/data/repository/PerfilRepository.dart';
import 'package:postgrado/Feacture/Perfil/domain/model/UserProfileModel.dart';

class GetUserProfileUseCase
{
  final PerfilRepository perfilRepository;
  GetUserProfileUseCase(this.perfilRepository);
  Future<UserProfileModel?> execute() async
  {
    return await perfilRepository.getUserProfile();
  }
}