// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/config_result.dart';

class ApiService {
  // ⚠️ Replace with YOUR Cloudflare Worker URL
  static const String base =
      'https://vpn-verifier.xhannyeinmin.workers.dev/api';

  static const Duration timeout =
      Duration(seconds: 60);

  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
      };

  // ----------------------------------------
  // VERIFY SINGLE CONFIG
  // ----------------------------------------
  static Future<ConfigResult> verifySingle(
    String config,
  ) async {
    try {
      final res = await http
          .post(
            Uri.parse('$base/verify'),
            headers: headers,
            body: jsonEncode({
              'config': config,
            }),
          )
          .timeout(timeout);

      final data = jsonDecode(res.body);

      if (res.statusCode == 200 &&
          data['success'] == true) {
        return ConfigResult.fromJson(
          data['result'],
        );
      }

      throw Exception(
        data['detail'] ?? 'Verify failed',
      );
    } catch (e) {
      throw Exception('$e');
    }
  }

  // ----------------------------------------
  // QUICK FORMAT CHECK
  // ----------------------------------------
  static Future<Map<String, dynamic>>
      quickCheck(
    String config,
  ) async {
    try {
      final res = await http
          .post(
            Uri.parse('$base/validate-format'),
            headers: headers,
            body: jsonEncode({
              'config': config,
            }),
          )
          .timeout(
            const Duration(seconds: 10),
          );

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }

      throw Exception('Check failed');
    } catch (e) {
      throw Exception('$e');
    }
  }

  // ----------------------------------------
  // VERIFY BULK CONFIGS
  // ----------------------------------------
  static Future<BulkResult> verifyBulk(
    List<String> configs,
  ) async {
    try {
      final res = await http
          .post(
            Uri.parse('$base/verify-bulk'),
            headers: headers,
            body: jsonEncode({
              'configs': configs,
            }),
          )
          .timeout(timeout);

      final data = jsonDecode(res.body);

      if (res.statusCode == 200 &&
          data['success'] == true) {
        return BulkResult.fromJson(data);
      }

      throw Exception(
        data['detail'] ?? 'Bulk check failed',
      );
    } catch (e) {
      throw Exception('$e');
    }
  }

  // ----------------------------------------
  // CHECK SUBSCRIPTION URL
  // ----------------------------------------
  static Future<BulkResult> checkSub(
    String url,
    int limit,
  ) async {
    try {
      final res = await http
          .post(
            Uri.parse('$base/subscription'),
            headers: headers,
            body: jsonEncode({
              'url': url,
              'max_configs': limit,
            }),
          )
          .timeout(timeout);

      final data = jsonDecode(res.body);

      if (res.statusCode == 200 &&
          data['success'] == true) {
        return BulkResult.fromJson(data);
      }

      throw Exception(
        data['detail'] ?? 'Sub check failed',
      );
    } catch (e) {
      throw Exception('$e');
    }
  }

  // ----------------------------------------
  // HEALTH CHECK / PING
  // ----------------------------------------
  static Future<bool> ping() async {
    try {
      final res = await http
          .get(
            Uri.parse('$base/health'),
          )
          .timeout(
            const Duration(seconds: 10),
          );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
