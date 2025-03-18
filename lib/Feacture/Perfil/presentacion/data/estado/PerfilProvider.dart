

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:postgrado/Core/di/service_locator.dart';
import 'package:postgrado/Feacture/Perfil/domain/case_use/GetUserProfileCaseUse.dart';
import 'package:postgrado/Feacture/Perfil/domain/model/UserProfileModel.dart';

final perfilProvider = FutureProvider<UserProfileModel?>((ref)
    async
    {
       return getIt<GetUserProfileUseCase>().execute();
    }
);


