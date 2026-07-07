import 'package:flutter/foundation.dart';
import '../models/config_result.dart';
import '../services/api_service.dart';

enum Status { idle, loading, done, error }

class AppProvider extends ChangeNotifier {
  // Server
  bool serverOnline = false;

  // Stats
  int totalChecked = 0;
  int totalSafe = 0;

  // Single
  Status singleStatus = Status.idle;
  ConfigResult? singleResult;
  String singleError = '';

  // Bulk  
  Status bulkStatus = Status.idle;
  BulkResult? bulkResult;
  String bulkError = '';
  String bulkFilter = 'All';

  // Subscription
  Status subStatus = Status.idle;
  BulkResult? subResult;
  String subError = '';
  String subFilter = 'All';

  // Check server
  Future<void> pingServer() async {
    serverOnline = await ApiService.ping();
    notifyListeners();
  }

  // Verify single
  Future<void> verifySingle(
    String config,
  ) async {
    singleStatus = Status.loading;
    singleResult = null;
    singleError = '';
    notifyListeners();

    try {
      singleResult = 
          await ApiService.verifySingle(config);
      singleStatus = Status.done;
      totalChecked++;
      if (singleResult!.safe) totalSafe++;
    } catch (e) {
      singleError = e.toString()
          .replaceAll('Exception: ', '');
      singleStatus = Status.error;
    }
    notifyListeners();
  }

  void clearSingle() {
    singleStatus = Status.idle;
    singleResult = null;
    singleError = '';
    notifyListeners();
  }

  // Verify bulk
  Future<void> verifyBulk(
    List<String> configs,
  ) async {
    bulkStatus = Status.loading;
    bulkResult = null;
    bulkError = '';
    bulkFilter = 'All';
    notifyListeners();

    try {
      bulkResult = 
          await ApiService.verifyBulk(configs);
      bulkStatus = Status.done;
      totalChecked += bulkResult!.total;
      totalSafe += bulkResult!.safeCount;
    } catch (e) {
      bulkError = e.toString()
          .replaceAll('Exception: ', '');
      bulkStatus = Status.error;
    }
    notifyListeners();
  }

  List<ConfigResult> get filteredBulk {
    if (bulkResult == null) return [];
    return _filter(
      bulkResult!.results, 
      bulkFilter,
    );
  }

  void setBulkFilter(String f) {
    bulkFilter = f;
    notifyListeners();
  }

  void clearBulk() {
    bulkStatus = Status.idle;
    bulkResult = null;
    bulkError = '';
    notifyListeners();
  }

  // Check subscription
  Future<void> checkSub(
    String url,
    int limit,
  ) async {
    subStatus = Status.loading;
    subResult = null;
    subError = '';
    subFilter = 'All';
    notifyListeners();

    try {
      subResult = await ApiService.checkSub(
        url, limit,
      );
      subStatus = Status.done;
      totalChecked += subResult!.total;
      totalSafe += subResult!.safeCount;
    } catch (e) {
      subError = e.toString()
          .replaceAll('Exception: ', '');
      subStatus = Status.error;
    }
    notifyListeners();
  }

  List<ConfigResult> get filteredSub {
    if (subResult == null) return [];
    return _filter(
      subResult!.results,
      subFilter,
    );
  }

  void setSubFilter(String f) {
    subFilter = f;
    notifyListeners();
  }

  // Filter helper
  List<ConfigResult> _filter(
    List<ConfigResult> list,
    String filter,
  ) {
    switch (filter) {
      case 'Safe':
        return list
            .where((r) => r.safe && r.score >= 75)
            .toList();
      case 'Caution':
        return list
            .where((r) => 
              !r.safe && r.score >= 55)
            .toList();
      case 'Unsafe':
        return list
            .where((r) => r.score < 55)
            .toList();
      default:
        return list;
    }
  }
}
