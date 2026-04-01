/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  接口配置模型，定义 API 基础地址与连接超时参数。

class ApiConfig {
  const ApiConfig({required this.baseUrl, this.connectTimeoutMs = 10000});

  final String baseUrl;
  final int connectTimeoutMs;
}
