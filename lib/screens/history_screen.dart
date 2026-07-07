import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (_, provider, __) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Stats overview
              _buildStats(provider),
              const SizedBox(height: 24),

              // Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.gray100,
                  borderRadius:
                      BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.gray200,
                  ),
                ),
                child: const Column(
                  children: [
                    Text(
                      '🔒 Safety Tips',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 12),
                    _TipItem(
                      '✅',
                      'Use configs with 75%+ score',
                    ),
                    _TipItem(
                      '✅',
                      'Prefer VLESS+Reality or '
                      'Trojan+TLS',
                    ),
                    _TipItem(
                      '✅',
                      'Rotate configs every few days',
                    ),
                    _TipItem(
                      '⚠️',
                      'Never use configs below 55%',
                    ),
                    _TipItem(
                      '⚠️',
                      'Avoid "none" encryption',
                    ),
                    _TipItem(
                      '❌',
                      'Never share configs publicly',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Score guide
              _buildScoreGuide(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStats(AppProvider provider) {
    return Row(
      children: [
        _statCard(
          '${provider.totalChecked}',
          'Total Checked',
          Icons.check_circle_outline,
        ),
        const SizedBox(width: 12),
        _statCard(
          '${provider.totalSafe}',
          'Total Safe',
          Icons.security,
          AppTheme.success,
        ),
      ],
    );
  }

  Widget _statCard(
    String value,
    String label,
    IconData icon, [
    Color color = AppTheme.black,
  ]) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.gray100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.gray200,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.gray500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreGuide() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.gray100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.gray200,
        ),
      ),
      child: const Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'Score Guide',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12),
          _ScoreRow(
            '🟢',
            '75 - 100%',
            'Safe to use',
            AppTheme.success,
          ),
          SizedBox(height: 8),
          _ScoreRow(
            '🟡',
            '55 - 74%',
            'Use with caution',
            AppTheme.warning,
          ),
          SizedBox(height: 8),
          _ScoreRow(
            '🔴',
            '0 - 54%',
            'Avoid - High risk',
            AppTheme.danger,
          ),
        ],
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final String emoji;
  final String text;

  const _TipItem(this.emoji, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Row(
        children: [
          Text(emoji),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.gray700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  final String emoji;
  final String range;
  final String label;
  final Color color;

  const _ScoreRow(
    this.emoji,
    this.range,
    this.label,
    this.color,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji),
        const SizedBox(width: 8),
        Text(
          range,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: color,
            fontSize: 13,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.gray600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
