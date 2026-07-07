import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/result_card.dart';
import '../theme/app_theme.dart';

class BulkScreen extends StatefulWidget {
  const BulkScreen({super.key});

  @override
  State<BulkScreen> createState() =>
      _BulkScreenState();
}

class _BulkScreenState 
    extends State<BulkScreen> {
  final _controller = TextEditingController();
  final _filters = ['All','Safe','Caution','Unsafe'];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (_, provider, __) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // Input
              const Text(
                'MULTIPLE CONFIGS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.gray500,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _controller,
                maxLines: 8,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
                decoration: const InputDecoration(
                  hintText:
                      'Paste configs (one per line)\n'
                      'vmess://...\n'
                      'vless://...\n'
                      'trojan://...',
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Max 500 configs at once',
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.gray400,
                ),
              ),
              const SizedBox(height: 16),

              // Buttons
              _buildButtons(provider),

              const SizedBox(height: 16),

              // Loading
              if (provider.bulkStatus == 
                  Status.loading)
                _buildLoading(),

              // Error
              if (provider.bulkStatus == 
                  Status.error)
                _buildError(provider),

              // Results
              if (provider.bulkStatus == 
                  Status.done &&
                  provider.bulkResult != null)
                _buildResults(provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildButtons(AppProvider provider) {
    final loading = provider.bulkStatus == 
        Status.loading;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: loading ? null : () {
              final lines = _controller.text
                  .split('\n')
                  .map((l) => l.trim())
                  .where((l) => l.isNotEmpty)
                  .toList();

              if (lines.isEmpty) {
                _snack('Please paste configs');
                return;
              }
              if (lines.length > 500) {
                _snack('Max 500 configs');
                return;
              }
              provider.verifyBulk(lines);
            },
            child: loading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.white,
                    ),
                  )
                : Text(
                    'Verify '
                    '${_controller.text.split('\n').where((l) => l.trim().isNotEmpty).length} '
                    'Configs',
                  ),
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton(
          onPressed: () {
            _controller.clear();
            provider.clearBulk();
          },
          child: const Text('Clear'),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          children: [
            CircularProgressIndicator(
              color: AppTheme.black,
              strokeWidth: 2,
            ),
            SizedBox(height: 16),
            Text('Checking all configs...'),
            Text(
              'This may take a while',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.gray400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(AppProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.dangerBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '❌ ${provider.bulkError}',
        style: const TextStyle(
          color: AppTheme.danger,
        ),
      ),
    );
  }

  Widget _buildResults(AppProvider provider) {
    final result = provider.bulkResult!;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        // Summary cards
        Row(
          children: [
            _summaryCard(
              '${result.total}',
              'Total',
              AppTheme.black,
            ),
            const SizedBox(width: 8),
            _summaryCard(
              '${result.safeCount}',
              'Safe',
              AppTheme.success,
            ),
            const SizedBox(width: 8),
            _summaryCard(
              '${result.unsafeCount}',
              'Unsafe',
              AppTheme.danger,
            ),
            const SizedBox(width: 8),
            _summaryCard(
              '${result.safeRate.toStringAsFixed(0)}%',
              'Rate',
              AppTheme.gray700,
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Filters
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _filters.map((f) {
              final active = 
                  provider.bulkFilter == f;
              return Padding(
                padding: const EdgeInsets.only(
                  right: 8,
                ),
                child: GestureDetector(
                  onTap: () =>
                      provider.setBulkFilter(f),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: active
                          ? AppTheme.black
                          : AppTheme.white,
                      borderRadius:
                          BorderRadius.circular(99),
                      border: Border.all(
                        color: active
                            ? AppTheme.black
                            : AppTheme.gray300,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      f,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: active
                            ? AppTheme.white
                            : AppTheme.gray600,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 12),

        // Result cards
        ...provider.filteredBulk.map(
          (r) => ResultCard(result: r),
        ),

        if (provider.filteredBulk.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                'No results for this filter',
                style: TextStyle(
                  color: AppTheme.gray400,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _summaryCard(
    String value,
    String label,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: AppTheme.gray100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppTheme.gray200,
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.gray500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppTheme.black,
      ),
    );
  }
}
