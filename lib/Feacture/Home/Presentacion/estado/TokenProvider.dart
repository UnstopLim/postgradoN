import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:postgrado/Core/di/service_locator.dart';
import 'package:postgrado/Feacture/Home/domain/caso_de_uso/token_case_uso.dart';
import 'package:postgrado/Feacture/Home/domain/models/token_models.dart';

final TokenProvider = FutureProvider<TokenModels?>((ref)
  async
  {
     return getIt<GetTokenCaseUse>().execute();
  }
);

