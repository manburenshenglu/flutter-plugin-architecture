import 'package:foundation/foundation.dart';
import 'package:get/get.dart';

import '../../application/usecases/load_home_entries_use_case.dart';
import '../../domain/entities/home_entry.dart';

class HomeController extends GetxController {
  HomeController({
    required this.appConfig,
    required LoadHomeEntriesUseCase loadHomeEntriesUseCase,
  }) : _loadHomeEntriesUseCase = loadHomeEntriesUseCase;

  final AppConfig appConfig;
  final LoadHomeEntriesUseCase _loadHomeEntriesUseCase;

  final RxList<HomeEntry> entries = <HomeEntry>[].obs;

  @override
  void onInit() {
    entries.assignAll(_loadHomeEntriesUseCase.execute());
    super.onInit();
  }

  bool get canOpenProfile {
    return appConfig.enabledModules.contains('module_profile');
  }
}
