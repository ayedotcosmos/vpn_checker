class ConfigResult {
  final String config;
  final String type;
  final bool safe;
  final int score;
  final String host;
  final String port;
  final String ip;
  final String country;
  final String city;
  final String org;
  final String provider;
  final String encryption;
  final bool portOpen;
  final String? error;

  ConfigResult({
    required this.config,
    required this.type,
    required this.safe,
    required this.score,
    required this.host,
    required this.port,
    required this.ip,
    required this.country,
    required this.city,
    required this.org,
    required this.provider,
    required this.encryption,
    required this.portOpen,
    this.error,
  });

  String get safetyLevel {
    if (safe && score >= 75) return 'safe';
    if (score >= 55) return 'caution';
    return 'unsafe';
  }

  String get statusText {
    if (safe && score >= 75) return 'SAFE';
    if (score >= 55) return 'CAUTION';
    return 'UNSAFE';
  }

  String get statusEmoji {
    if (safe && score >= 75) return '🟢';
    if (score >= 55) return '🟡';
    return '🔴';
  }

  factory ConfigResult.fromJson(
    Map<String, dynamic> j,
  ) {
    return ConfigResult(
      config: j['config'] ?? '',
      type: j['type'] ?? 'Unknown',
      safe: j['safe'] ?? false,
      score: (j['percentage'] ?? 
              j['score'] ?? 0).toInt(),
      host: j['host'] ?? '',
      port: j['port']?.toString() ?? '',
      ip: j['ip'] ?? '',
      country: j['country'] ?? '??',
      city: j['city'] ?? '',
      org: j['org'] ?? 'Unknown',
      provider: j['provider'] ?? 'Unknown',
      encryption: j['encryption'] ?? 'unknown',
      portOpen: j['port_open'] ?? false,
      error: j['error'],
    );
  }
}

class BulkResult {
  final int total;
  final int safeCount;
  final List<ConfigResult> results;

  BulkResult({
    required this.total,
    required this.safeCount,
    required this.results,
  });

  int get unsafeCount => total - safeCount;
  
  double get safeRate =>
      total > 0 ? safeCount / total * 100 : 0;

  List<ConfigResult> get safeResults =>
      results.where((r) => r.safe).toList()
        ..sort((a, b) => 
          b.score.compareTo(a.score));

  factory BulkResult.fromJson(
    Map<String, dynamic> j,
  ) {
    final list = (j['results'] as List? ?? [])
        .map((r) => ConfigResult.fromJson(r))
        .toList();
    list.sort((a, b) => 
      b.score.compareTo(a.score));
    return BulkResult(
      total: j['total'] ?? list.length,
      safeCount: j['safe_count'] ?? 0,
      results: list,
    );
  }
}
