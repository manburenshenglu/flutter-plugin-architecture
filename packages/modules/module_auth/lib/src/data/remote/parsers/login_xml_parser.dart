import 'dart:convert';

import 'package:xml2json/xml2json.dart';

import '../dtos/login_response_dto.dart';

/// @author xiejl
/// @date 2026/4/2 17:20
/// @description  XML 登录响应解析器，负责将 xml2json 的结果映射到登录 DTO。
class LoginXmlParser {
  const LoginXmlParser();

  LoginResponseDto parse(String xmlPayload) {
    // 兼容空响应，避免上层再做重复判空。
    if (xmlPayload.trim().isEmpty) {
      return const LoginResponseDto(
        success: false,
        message: 'XML 响应为空',
      );
    }

    // 统一先把 XML 转成 Map，后续用同一套取值逻辑处理多种历史结构。
    final converter = Xml2Json()..parse(xmlPayload);
    final dynamic decoded = jsonDecode(converter.toParker());
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('XML 登录响应结构不合法');
    }

    // TODO: 将下面的通用候选字段替换为真实登录 XML 字段：
    // ReturnFlag/ReturnText/MemberID/PortPassword 等，按真实协议做 1:1 映射与成功判定。
    // success 字段优先；若缺失则回退到 code/status 等历史字段推断。
    final success = _toBool(
      _findValue(decoded, const <String>['success', 'isSuccess', 'ok']),
    );
    final code = _findValue(decoded, const <String>['code', 'status', 'ret']);
    final resolvedSuccess = success ?? _isSuccessCode(code) ?? false;

    return LoginResponseDto(
      success: resolvedSuccess,
      userId: _toStringValue(
        _findValue(decoded, const <String>['userId', 'uid', 'memberId']),
      ),
      message: _toStringValue(
        _findValue(decoded, const <String>['message', 'msg', 'desc']),
      ),
    );
  }

  dynamic _findValue(dynamic node, List<String> candidates) {
    // 先标准化 key，再做递归查找，兼容大小写和分隔符差异。
    final wanted = candidates.map(_normalizeKey).toSet();
    return _findValueRecursive(node, wanted);
  }

  dynamic _findValueRecursive(dynamic node, Set<String> wanted) {
    if (node is Map<String, dynamic>) {
      for (final entry in node.entries) {
        if (wanted.contains(_normalizeKey(entry.key))) {
          return entry.value;
        }
      }
      for (final value in node.values) {
        final found = _findValueRecursive(value, wanted);
        if (found != null) {
          return found;
        }
      }
    } else if (node is List<dynamic>) {
      for (final item in node) {
        final found = _findValueRecursive(item, wanted);
        if (found != null) {
          return found;
        }
      }
    }
    return null;
  }

  String _normalizeKey(String key) {
    final buffer = StringBuffer();
    for (final rune in key.runes) {
      final lower = String.fromCharCode(rune).toLowerCase();
      final isAlphaNum =
          (lower.codeUnitAt(0) >= 48 && lower.codeUnitAt(0) <= 57) ||
          (lower.codeUnitAt(0) >= 97 && lower.codeUnitAt(0) <= 122);
      if (isAlphaNum) {
        buffer.write(lower);
      }
    }
    return buffer.toString();
  }

  bool? _toBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1' || normalized == 'y') {
        return true;
      }
      if (normalized == 'false' || normalized == '0' || normalized == 'n') {
        return false;
      }
    }
    return null;
  }

  bool? _isSuccessCode(dynamic code) {
    final normalized = _toStringValue(code)?.trim().toLowerCase();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }
    if (normalized == '0' || normalized == '200' || normalized == 'success') {
      return true;
    }
    return false;
  }

  String? _toStringValue(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    return value.toString();
  }
}
