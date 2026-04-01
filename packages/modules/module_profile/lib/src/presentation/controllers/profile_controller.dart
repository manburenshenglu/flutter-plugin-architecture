import 'package:foundation/foundation.dart';
import 'package:get/get.dart';

import '../../application/usecases/load_profile_use_case.dart';
import '../../domain/entities/profile_summary.dart';

class ProfileController extends GetxController {
  ProfileController({
    required this.appConfig,
    required LoadProfileUseCase loadProfileUseCase,
  }) : _loadProfileUseCase = loadProfileUseCase;

  final AppConfig appConfig;
  final LoadProfileUseCase _loadProfileUseCase;

  final Rxn<ProfileSummary> summary = Rxn<ProfileSummary>();

  @override
  void onInit() {
    summary.value = _loadProfileUseCase.execute();
    super.onInit();
  }
}
