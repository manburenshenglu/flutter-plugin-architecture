/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  接口配置模型，定义 API 基础地址与网络超时参数。

class ApiConfig {
  const ApiConfig({
    required this.baseUrl,
    this.connectTimeoutMs = 10000,
    this.sendTimeoutMs = 15000,
    this.receiveTimeoutMs = 20000,
  });

  final String baseUrl;
  final int connectTimeoutMs;
  final int sendTimeoutMs;
  final int receiveTimeoutMs;
}
