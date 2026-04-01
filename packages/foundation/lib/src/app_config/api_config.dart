class ApiConfig {
  const ApiConfig({required this.baseUrl, this.connectTimeoutMs = 10000});

  final String baseUrl;
  final int connectTimeoutMs;
}
