import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/config_result.dart';

class ApiService {
  // ⚠️ Replace with YOUR worker URL
  static const String base =
    'https://vpn-verifier.xhannyeinmin.workers.dev/api';

  static const timeout = Duration(seconds: 60);

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
  };

  static Future<ConfigResult> verifySingle(
    String config,
  ) async {
    try {
      final res = await http.post(
        Uri.parse('$base/verify'),
        headers: headers,
        body: jsonEncode({'config': config}),
      ).timeout(timeout);
      final data = jsonDecode(res.body);
      if (res.statusCode == 200 &&
          data['success'] == true) {
        return ConfigResult.fromJson(
          data['result'],
        );
      }
      throw Exception(
        data['detail'] ?? 'Failed'
      );
    } catch (e) {
      throw Exception('$e');
    }
  }

  static Future<BulkResult> verifyBulk(
    List<String> configs,
  ) async {
    try {
      final res = await http.post(
        Uri.parse('$base/verify-bulk'),
        headers: headers,
        body: jsonEncode({
          'configs': configs,
        }),
      ).timeout(timeout);
      final data = jsonDecode(res.body);
      if (res.statusCode == 200 &&
          data['success'] == true) {
        return BulkResult.fromJson(data);
      }
      throw Exception(
        data['detail'] ?? 'Failed'
      );
    } catch (e) {
      throw Exception('$e');
    }
  }

  static Future<BulkResult> checkSub(
    String url,
    int limit,
  ) async {
    try {
      final res = await http.post(
        Uri.parse('$base/subscription'),
        headers: headers,
        body: jsonEncode({
          'url': url,
          'max_configs': limit,
        }),
      ).timeout(timeout);
      final data = jsonDecode(res.body);
      if (res.statusCode == 200 &&
          data['success'] == true) {
        return BulkResult.fromJson(data);
      }
      throw Exception(
        data['detail'] ?? 'Failed'
      );
    } catch (e) {
      throw Exception('$e');
    }
  }

  static Future<bool> ping() async {
    try {
      final res = await http.get(
        Uri.parse('$base/health'),
      ).timeout(
        const Duration(seconds: 10)
      );
      return res.statusCode == 200;
    } catch {
      return false;
    }
  }
}

  // Bulk verify
  static Future<BulkResult> verifyBulk(
    List<String> configs,
  ) async {
    final res = await http.post(
      Uri.parse('$base/verify-bulk'),
      headers: headers,
      body: jsonEncode({
        'configs': configs,
        'max_workers': 20,
      }),
    ).timeout(timeout);

    final data = jsonDecode(res.body);
    if (res.statusCode == 200 && 
        data['success'] == true) {
      return BulkResult.fromJson(data);
    }
    throw Exception('Bulk check failed');
  }

  // Subscription check
  static Future<BulkResult> checkSub(
    String url,
    int limit,
  ) async {
    final res = await http.post(
      Uri.parse('$base/subscription'),
      headers: headers,
      body: jsonEncode({
        'url': url,
        'max_configs': limit,
      }),
    ).timeout(timeout);

    final data = jsonDecode(res.body);
    if (res.statusCode == 200 && 
        data['success'] == true) {
      return BulkResult.fromJson(data);
    }
    throw Exception(
      data['detail'] ?? 'Sub check failed'
    );
  }

  // Health check
  static Future<bool> ping() async {
    try {
      final res = await http.get(
        Uri.parse('$base/health'),
      ).timeout(const Duration(seconds: 5));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
