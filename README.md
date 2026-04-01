# Flutter Plugin Architecture Monorepo

面向多 App（矩阵包/多品牌/多场景）孵化的 Flutter 插件化架构仓库，让你快速通过插件化开发flutter app

该仓库核心目标：
- 在同一套基础设施下快速孵化新 App Shell(矩阵包)
- 通过“模块包”组合业务能力，而不是复制整套工程
- 在模块内部应用 Clean Architecture，模块之间保持低耦合
- 品牌差异(不同的app)通过配置驱动，而不是硬编码在业务逻辑中

## 1. 架构原则

本仓库遵循以下约束：
- 使用模块化架构
- 每个业务模块是独立 package
- Clean Architecture 仅在模块内部生效
- 不做全局 data/domain/presentation 大一统拆分
- 模块低耦合，跨模块通过契约/能力交互
- `shared` 只放真正共享的抽象，不放无关代码

## 2. 技术栈

- Flutter
- melos（Monorepo 编排）
- dio（网络基础能力）
- get_it（依赖注入）
- get（路由 + 状态管理）
- injectable（已纳入技术栈约束，可按需引入）

## 3. 目录结构

```text
.
├── apps/
│   ├── app_consumer/
│   └── app_doctor/
├── packages/
│   ├── foundation/        # 启动编排、模块协议、配置模型、DI
│   ├── brands/            # 品牌/环境配置生成
│   ├── design_system/     # 主题与通用 UI 组件
│   ├── shared/            # 跨模块契约与共享路由
│   └── modules/
│       ├── module_auth/
│       ├── module_home/
│       └── module_profile/
└── tooling/               # 脚手架/契约校验/IDE 修复脚本
```

## 4. 启动链路（从 App 到模块装配）

以 `apps/app_consumer/lib/main.dart` 为例，启动流程如下：

1. 读取品牌配置：`BrandProfiles.consumer(env: AppEnv.dev)`
2. 组装模块目录：`moduleCatalog = {'module_auth': ..., ...}`
3. 根据配置启用模块：`ModuleSelector.select(...)`
4. 启动编排：`AppBootstrapper.bootstrap(config, modules)`
5. 拿到注册结果：`ModuleRegistry`（包含路由、模块元信息）
6. 构建 `GetMaterialApp`，注入模块路由和调试页 `/debug/modules`

这条链路实现了“App 壳 + 模块插件化装配”的分层职责。

## 5. 插件化核心组件详解

### 5.1 `AppModule`（模块最小协议）

位于 `packages/foundation/lib/src/app_bootstrap/app_module.dart`。

模块必须声明：
- `moduleName`：模块唯一名
- `descriptor`：版本、依赖、能力声明
- `pages`：模块路由列表
- `registerDependencies(GetIt sl, AppConfig config)`：模块内依赖注册
- `initialize(AppConfig config)`：可选异步初始化

### 5.2 `ModuleDescriptor` 与依赖图

位于 `packages/foundation/lib/src/app_bootstrap/module_descriptor.dart`。

- `ModuleDependency`：声明依赖模块及版本约束
- `ModuleDescriptor`：模块版本、依赖、对外能力

`ModuleRegistry._validateDependencies()` 会在启动阶段校验依赖完整性，缺依赖直接抛错，防止运行期隐式失败。

### 5.3 `ModuleRegistry`（模块注册中心）

位于 `packages/foundation/lib/src/app_bootstrap/module_registry.dart`。

职责：
- 启动前依赖校验
- 逐模块调用 `registerDependencies` 与 `initialize`
- 汇总模块路由 `collectPages()`
- 汇总模块名/描述用于调试页展示
- 协同能力注册（见下）

### 5.4 `ModuleCapabilityProvider` + `CapabilityRegistry`

位于：
- `packages/foundation/lib/src/app_bootstrap/capability/module_capability_provider.dart`
- `packages/foundation/lib/src/app_bootstrap/capability/capability_registry.dart`

能力机制用于跨模块“面向接口”通信：
- 提供方模块实现 `ModuleCapabilityProvider` 并 `registry.register<T>(impl)`
- 使用方模块通过 `CapabilityRegistry.require<T>()` 获取能力
- 若重复注册相同 capability type，系统会记录 warning 并忽略后续重复

这样的目的是：避免模块之间直接 import 彼此实现，降低耦合。

### 5.5 `AppBootstrapper`（启动编排器）

位于 `packages/foundation/lib/src/app_bootstrap/app_bootstrapper.dart`。

负责：
- 重置并初始化 `serviceLocator`
- 注册核心对象（`AppConfig`、`Dio`）
- 创建并注册 `CapabilityRegistry`
- 创建并执行 `ModuleRegistry.registerAll(...)`

## 6. 配置体系详解（每个配置的作用 + 使用方式）

配置模型位于 `packages/foundation/lib/src/app_config/`。

### 6.1 `AppConfig`

聚合应用运行所需的全部配置：
- `appName`
- `env`
- `apiConfig`
- `featureFlags`
- `analyticsConfig`
- `brandConfig`
- `enabledModules`

使用方式：
- 启动时由 `BrandProfiles.xxx(env: ...)` 生成
- 模块在 `registerDependencies` 或 Controller 中通过 `sl<AppConfig>()` / 构造参数读取

### 6.2 `ApiConfig`

作用：定义 API Base URL 和连接超时。

使用方式：
- `AppBootstrapper` 用它初始化全局 `Dio(BaseOptions(...))`

### 6.3 `FeatureFlags`

作用：按品牌控制功能开关。

使用方式：
- 业务用例读取开关并决定是否产出功能数据（如 `LoadHomeEntriesUseCase`）

### 6.4 `AnalyticsConfig`

作用：埋点开关和埋点提供方。

使用方式：
- 页面/用例可读取 provider 做分流策略

### 6.5 `BrandConfig`

作用：品牌标识、品牌名称、主题色。

使用方式：
- `AppThemeFactory.light(config.brandConfig)` 生成主题

### 6.6 `AppEnv`

作用：定义 `dev/staging/prod` 环境。

使用方式：
- `BrandProfiles` 根据环境切换 API 域名

## 7. 品牌配置 `brands` 包使用方式

核心文件：`packages/brands/lib/src/brand_profiles.dart`

当前已提供：
- `BrandProfiles.consumer(...)`
- `BrandProfiles.doctor(...)`

每个 profile 同时决定：
- app 名称
- brand 主题色
- analytics provider
- feature flags
- enabledModules
- 不同 env 的 API 域名

这使“品牌差异”集中在配置层，而业务模块代码保持稳定。

## 8. 现有业务模块说明（作用 + 用法）

### 8.1 `module_auth`

作用：
- 提供登录页面 `/auth/login`
- 注册 `AuthRepository`、`LoginUseCase`、`AuthSessionService`
- 对外暴露能力：`SessionReadable`

用法：
- App 将 `ModuleAuth()` 放入 `moduleCatalog`
- 若 `enabledModules` 含 `module_auth`，则自动加载对应路由和依赖

### 8.2 `module_home`

作用：
- 提供首页 `/home`
- 依赖 `module_auth`（声明式依赖，拒绝直接依赖）
- 根据 `AppConfig` 和 `FeatureFlags` 生成首页条目

用法：
- `ModuleHome()` 加入目录并启用
- Controller 在 `onInit` 调用 `LoadHomeEntriesUseCase`

### 8.3 `module_profile`

作用：
- 提供资料(个人中心)页 `/profile`
- 依赖 `module_auth`（声明式依赖，拒绝直接依赖）
- 对外暴露能力：`ProfileReadable`

用法：
- `ModuleProfile()` 加入目录并启用
- 通过 `LoadProfileUseCase` 聚合品牌/埋点/功能统计

## 9. `shared` 包与契约治理

### 9.1 共享内容

- `AppRoutes`：跨模块统一路由常量
- `SessionReadable` / `ProfileReadable`：跨模块能力契约
- `ContractVersions`：契约版本号

### 9.2 契约变更守卫

相关脚本：
- `tooling/check_contract_compatibility.sh`
- `tooling/update_contract_lock.sh`
- `tooling/contracts_manifest.txt`
- `tooling/contracts.lock`

规则：
- 接口文件哈希变化但 major 未升级 -> 校验失败
- 版本变化但接口哈希未变化 -> 校验失败

推荐流程：
1. 修改契约接口
2. 同步更新 `ContractVersions`（必要时 major）
3. 执行 `./tooling/check_contract_compatibility.sh`
4. 确认后执行 `./tooling/update_contract_lock.sh`

## 10. 快速开始

### 10.1 安装依赖

```bash
melos run bootstrap
```

### 10.2 运行现有 App

```bash
cd apps/app_consumer
flutter run

# 或
cd apps/app_doctor
flutter run
```

### 10.3 质量检查

```bash
melos run contract:check
melos run analyze
melos run test
```

一键 CI 本地预演：

```bash
melos run ci
```

## 11. 孵化新 App（插件化）实战示例

下面给出一个“新增孵化 App：`app_pharmacy`”的完整示例，新增更多app：app_d、app_e、app_f。。。同理。

### 11.1 方案 A：用脚手架快速生成 App Shell（推荐）

```bash
./tooling/create_app_shell.sh app_pharmacy consumer dev
```

说明：
- 参数 1：新 App 名（会创建 `apps/app_pharmacy`）
- 参数 2：品牌模板（当前脚本默认支持 `consumer` / `doctor`）
- 参数 3：环境（可选，默认 `dev`）

然后：

```bash
cd apps/app_pharmacy
flutter pub get
flutter run
```

脚手架自动生成：
- app 级 `main.dart`（含 `BrandProfiles + ModuleSelector + AppBootstrapper`）
- 认证/首页/资料模块依赖
- 模块调试页路由接入

### 11.2 方案 B：新增品牌配置后再孵化（推荐用于新业务线）

若要“药房品牌”而不是复用 consumer/doctor，可先在 `BrandProfiles` 增加 `pharmacy`：

```dart
static AppConfig pharmacy({required AppEnv env}) {
  return AppConfig(
    appName: 'Pharmacy App',
    env: env,
    apiConfig: ApiConfig(baseUrl: _apiByEnv(env, consumer: true)),
    analyticsConfig: const AnalyticsConfig(enabled: true, provider: 'firebase'),
    brandConfig: const BrandConfig(
      brandId: 'pharmacy',
      brandName: 'Life Pharmacy',
      seedColor: Color(0xFF5B8C00),
    ),
    featureFlags: const FeatureFlags(
      enablePayment: true,
      enableSubscription: false,
      enableMedication: true,
      enableDietarySupplements: false,
    ),
    enabledModules: const <String>[
      'module_auth',
      'module_home',
      'module_profile',
    ],
  );
}
```

然后在新 App `main.dart` 中使用：

```dart
final config = BrandProfiles.pharmacy(env: AppEnv.staging);
```

### 11.3 App 级插件装配示例（关键代码）

```dart
final moduleCatalog = <String, AppModule>{
  'module_auth': ModuleAuth(),
  'module_home': ModuleHome(),
  'module_profile': ModuleProfile(),
  // 'module_orders': ModuleOrders(), // 新模块按需接入
};

final modules = ModuleSelector.select(
  catalog: moduleCatalog,
  enabledModules: config.enabledModules,
);

final registry = await AppBootstrapper.bootstrap(
  config: config,
  modules: modules,
);
```

要点：
- `moduleCatalog` 代表“App 可安装插件全集”
- `enabledModules` 代表“当前品牌/环境启用集”
- 两者交集即运行时模块集

### 11.4 新增孵化 App 后的验收清单

```bash
melos run bootstrap
melos run analyze
melos run test
```

并手动启动新 App 验证：
- 登录页可进入
- 首页展示正常
- `/debug/modules` 可看到模块、路由、能力、告警

## 12. 新增业务模块（插件）示例

### 12.1 生成模块骨架

```bash
./tooling/create_module.sh module_orders
```

会自动生成：
- `module_orders.dart` 对外导出
- `src/module_orders_module.dart`（实现 `AppModule`）
- application/domain/presentation 基础目录

### 12.2 接入到某个 App

1. 在 App `pubspec.yaml` 添加 path 依赖：

```yaml
module_orders:
  path: ../../packages/modules/module_orders
```

2. 在 App `main.dart` 添加 import 与 catalog：

```dart
import 'package:module_orders/module_orders.dart';

final moduleCatalog = <String, AppModule>{
  'module_auth': ModuleAuth(),
  'module_home': ModuleHome(),
  'module_profile': ModuleProfile(),
  'module_orders': ModuleOrders(),
};
```

3. 在品牌配置 `enabledModules` 中按需启用：

```dart
enabledModules: const <String>[
  'module_auth',
  'module_home',
  'module_orders',
],
```

### 12.3 声明依赖关系（防止错误组合）

在模块 `descriptor` 里声明：

```dart
ModuleDescriptor get descriptor => const ModuleDescriptor(
  moduleName: 'module_orders',
  version: '0.1.0',
  dependencies: <ModuleDependency>[
    ModuleDependency(moduleName: 'module_auth', versionConstraint: '>=0.1.0'),
  ],
);
```

若 App 启用了 `module_orders` 却没启用 `module_auth`，启动时会被 `ModuleRegistry` 拦截并抛错。

## 13. 跨模块能力使用示例

### 13.1 提供能力（Provider 模块）

`module_profile` 示例：

```dart
class ModuleProfile implements AppModule, ModuleCapabilityProvider {
  @override
  void registerCapabilities(
    CapabilityRegistry registry,
    GetIt serviceLocator,
    AppConfig config,
  ) {
    registry.register<ProfileReadable>(serviceLocator<ProfileReadService>());
  }
}
```

### 13.2 消费能力（Consumer 模块）

示例（伪代码）：

```dart
final capabilityRegistry = serviceLocator<CapabilityRegistry>();
final profileReadable = capabilityRegistry.tryGet<ProfileReadable>();
if (profileReadable != null) {
  final name = await profileReadable.displayName();
  // 使用能力结果
}
```

建议：
- 优先 `tryGet<T>()` 做可选能力，避免强依赖
- 必须依赖时用 `require<T>()` 并在模块依赖里显式声明前置模块

## 14. 调试与排障

### 14.1 模块调试页

路由：`/debug/modules`

可查看：
- 当前 App 配置
- 已启用模块
- 模块描述与依赖
- 注册路由
- 已注册 capability
- 启动告警（含重复 capability 注册）

### 14.2 常见问题

1. 启动时报模块依赖缺失
- 检查品牌 `enabledModules`
- 检查模块 `descriptor.dependencies`

2. 路由找不到
- 检查模块是否被启用
- 检查模块 `pages` 是否正确暴露

3. capability 获取失败
- 检查提供方是否实现 `ModuleCapabilityProvider`
- 检查是否在 `registerCapabilities` 注册

4. Android Studio 运行配置错乱

```bash
./tooling/repair_flutter_ide.sh
```

## 15. 常用命令速查

```bash
melos run bootstrap
melos run analyze
melos run test
melos run format
melos run contract:check
melos run contract:update-lock
melos run scaffold:app
melos run scaffold:module
melos run repair:ide
melos run ci
```

## 16. 开发建议（结合本仓库约束）

- 优先最小可运行实现，再逐步抽象
- 模块边界清晰优先于“公共代码复用率”
- 共享包只放稳定契约/通用能力
- 品牌差异统一放 `brands` 配置层
- 每次变更前后执行：导入检查、依赖关系检查、双 Demo App 启动验证

