import 'package:foundation/foundation.dart';

import '../remote/apis/auth_api.dart';
import '../remote/dtos/login_request_dto.dart';
import '../remote/dtos/login_response_dto.dart';
import '../remote/parsers/login_xml_parser.dart';

/// @author xiejl
/// @date 2026/4/2 11:55
/// @description  认证远程数据源，封装 Retrofit API 调用细节。
class AuthRemoteDataSource {
  const AuthRemoteDataSource({
    required AuthApi jsonApi,
    required Dio dio,
    required AppConfig appConfig,
    required LoginXmlParser loginXmlParser,
  }) : _jsonApi = jsonApi,
       _dio = dio,
       _appConfig = appConfig,
       _loginXmlParser = loginXmlParser;

  final AuthApi _jsonApi;
  final Dio _dio;
  final AppConfig _appConfig;
  final LoginXmlParser _loginXmlParser;

  Future<LoginResponseDto> login({
    required String account,
    required String password,
  }) async {
    if (_appConfig.featureFlags.useXmlLoginApi) {
      return _loginByXml(account: account, password: password);
    }
    return _jsonApi.login(
      LoginRequestDto(account: account, password: password),
    );
  }

  Future<LoginResponseDto> _loginByXml({
    required String account,
    required String password,
  }) async {
    // TODO: 替换为真实登录接口路由（）。
    // 注意：这里的 '/auth/login' 只是 XML 登录临时占位路径，
    // 上线前必须替换为后端真实 XML 登录接口地址。
    final response = await _dio.post<String>(
      '/auth/login',
      data: _buildXmlLoginPayload(account: account, password: password),
      options: Options(
        contentType: 'application/xml; charset=utf-8',
        headers: const <String, String>{
          'Accept': 'application/xml, text/xml, application/json',
        },
        responseType: ResponseType.plain,
      ),
    );

    return _loginXmlParser.parse(response.data ?? '');
  }

  String _buildXmlLoginPayload({
    required String account,
    required String password,
  }) {
    // TODO: 按真实接口字段生成 XML，
    // 例如 PhoneNumber/PassWord/DeviceID/IsValid 等，替换当前临时结构。
    // 注意：这里的 XML 请求体结构是临时假设，
    // 请按后端真实协议替换节点名/层级结构/命名空间。
    return '<login>'
        '<account>${_escapeXml(account)}</account>'
        '<password>${_escapeXml(password)}</password>'
        '</login>';
  }

  String _escapeXml(String input) {
    return input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');
  }
}
