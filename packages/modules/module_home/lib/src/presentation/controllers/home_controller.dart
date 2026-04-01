import 'package:foundation/foundation.dart';
import 'package:get/get.dart';

import '../../application/usecases/load_home_entries_use_case.dart';
import '../../domain/entities/home_entry.dart';

/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  首页状态控制器，负责加载首页条目并暴露页面可用能力。

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
