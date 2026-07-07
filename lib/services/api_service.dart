import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/config_result.dart';

class ApiService {
  // ⚠️ Change this to your server IP later
  static const String base = 
      'http://10.0.2.2:8000/api';
  
  static const timeout = Duration(seconds: 120);
  
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
  };

  // Single config verify
  static Future<ConfigResult> verifySingle(
    String config,
  ) async {
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
      data['detail'] ?? 'Verify failed'
    );
  }

  // Quick format check
  static Future<Map<String, dynamic>> 
      quickCheck(String config) async {
    final res = await http.post(
      Uri.parse('$base/validate-format'),
      headers: headers,
      body: jsonEncode({'config': config}),
    ).timeout(const Duration(seconds: 10));

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Check failed');
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
