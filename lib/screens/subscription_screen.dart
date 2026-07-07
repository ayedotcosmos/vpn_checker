import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/result_card.dart';
import '../theme/app_theme.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() =>
      _SubscriptionScreenState();
}

class _SubscriptionScreenState
    extends State<SubscriptionScreen> {
  final _urlController = TextEditingController();
  int _limit = 100;
  final _filters = ['All', 'Safe', 'Unsafe'];

  // Preset subscription links
  final _presets = [
    {
      'name': 'Epodonios',
      'url': 'https://github.com/Epodonios/'
          'v2ray-configs/raw/main/'
          'All_Configs_Sub.txt',
    },
    {
      'name': 'MatinGhanbari',
      'url': 'https://raw.githubusercontent.com/'
          'MatinGhanbari/v2ray-configs/main/'
          'subscriptions/v2ray/all_sub.txt',
    },
  ];

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
              // Preset buttons
              _buildPresets(),
              const SizedBox(height: 16),

              // URL input
              const Text(
                'SUBSCRIPTION URL',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.gray500,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _urlController,
                style: const TextStyle(
                  fontSize: 13,
                ),
                decoration: const InputDecoration(
                  hintText: 'https://...',
                  prefixIcon: Icon(
                    Icons.link,
                    color: AppTheme.gray400,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Limit slider
              _buildLimitSlider(),

              const SizedBox(height: 16),

              // Check button
              _buildCheckButton(provider),

              const SizedBox(height: 16),

              // Loading
              if (provider.subStatus == 
                  Status.loading)
                _buildLoading(),

              // Error
              if (provider.subStatus == 
                  Status.error)
                _buildError(provider),

              // Results
              if (provider.subStatus == 
                  Status.done &&
                  provider.subResult != null)
                _buildResults(provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPresets() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'QUICK SELECT',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppTheme.gray500,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: _presets.map((p) {
            return Padding(
              padding: const EdgeInsets.only(
                right: 8,
              ),
              child: OutlinedButton(
                onPressed: () {
                  _urlController.text = 
                      p['url']!;
                },
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                child: Text(
                  p['name']!,
                  style:
                      const TextStyle(fontSize: 12),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLimitSlider() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'MAX CONFIGS TO CHECK',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.gray500,
                letterSpacing: 1,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppTheme.black,
                borderRadius:
                    BorderRadius.circular(6),
              ),
              child: Text(
                '$_limit',
                style: const TextStyle(
                  color: AppTheme.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        Slider(
          value: _limit.toDouble(),
          min: 10,
          max: 500,
          divisions: 49,
          activeColor: AppTheme.black,
          inactiveColor: AppTheme.gray200,
          onChanged: (v) =>
              setState(() => _limit = v.toInt()),
        ),
        const Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '10 (fast)',
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.gray400,
              ),
            ),
            Text(
              '500 (thorough)',
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.gray400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckButton(AppProvider provider) {
    final loading = provider.subStatus == 
        Status.loading;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: loading ? null : () {
          final url = 
              _urlController.text.trim();
          if (url.isEmpty) {
            _snack('Please enter a URL');
            return;
          }
          if (!url.startsWith('http')) {
            _snack('Invalid URL');
            return;
          }
          provider.checkSub(url, _limit);
        },
        child: loading
            ? const Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text('Checking...'),
                ],
              )
            : const Text('Check Subscription'),
      ),
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
            Text(
              'Loading subscription...',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'This may take 1-2 minutes',
              style: TextStyle(
                color: AppTheme.gray400,
                fontSize: 12,
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
        border: Border.all(
          color: AppTheme.danger.withOpacity(0.3),
        ),
      ),
      child: Text(
        '❌ ${provider.subError}',
        style: const TextStyle(
          color: AppTheme.danger,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildResults(AppProvider provider) {
    final result = provider.subResult!;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        // Summary
        Row(
          children: [
            _card('${result.total}', 'Checked'),
            const SizedBox(width: 8),
            _card(
              '${result.safeCount}',
              'Safe',
              AppTheme.success,
            ),
            const SizedBox(width: 8),
            _card(
              '${result.safeRate.toStringAsFixed(0)}%',
              'Rate',
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
                  provider.subFilter == f;
              return Padding(
                padding: const EdgeInsets.only(
                  right: 8,
                ),
                child: GestureDetector(
                  onTap: () =>
                      provider.setSubFilter(f),
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

        // Cards
        ...provider.filteredSub.map(
          (r) => ResultCard(result: r),
        ),

        if (provider.filteredSub.isEmpty)
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

  Widget _card(
    String value,
    String label, [
    Color? color,
  ]) {
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
                color: color ?? AppTheme.black,
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
