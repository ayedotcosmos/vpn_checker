import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/config_result.dart';
import '../theme/app_theme.dart';

class ResultCard extends StatefulWidget {
  final ConfigResult result;

  const ResultCard({
    super.key,
    required this.result,
  });

  @override
  State<ResultCard> createState() =>
      _ResultCardState();
}

class _ResultCardState 
    extends State<ResultCard> {
  bool _open = false;
  bool _copied = false;

  Color get _leftColor {
    switch (widget.result.safetyLevel) {
      case 'safe': return AppTheme.success;
      case 'caution': return AppTheme.warning;
      default: return AppTheme.danger;
    }
  }

  Color get _bgColor {
    switch (widget.result.safetyLevel) {
      case 'safe': return AppTheme.successBg;
      case 'caution': return AppTheme.warningBg;
      default: return AppTheme.dangerBg;
    }
  }

  Color get _textColor {
    switch (widget.result.safetyLevel) {
      case 'safe': return AppTheme.success;
      case 'caution': return AppTheme.warning;
      default: return AppTheme.danger;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: _leftColor, 
            width: 4,
          ),
          top: const BorderSide(
            color: AppTheme.gray200,
          ),
          right: const BorderSide(
            color: AppTheme.gray200,
          ),
          bottom: const BorderSide(
            color: AppTheme.gray200,
          ),
        ),
      ),
      child: Column(
        children: [
          // Header (always visible)
          _Header(
            result: widget.result,
            open: _open,
            bgColor: _bgColor,
            textColor: _textColor,
            onTap: () => setState(
              () => _open = !_open,
            ),
          ),

          // Body (expandable)
          if (_open)
            _Body(
              result: widget.result,
              copied: _copied,
              onCopy: _copy,
            ),
        ],
      ),
    );
  }

  void _copy() async {
    await Clipboard.setData(
      ClipboardData(
        text: widget.result.config,
      ),
    );
    setState(() => _copied = true);
    await Future.delayed(
      const Duration(seconds: 2),
    );
    if (mounted) {
      setState(() => _copied = false);
    }
  }
}

class _Header extends StatelessWidget {
  final ConfigResult result;
  final bool open;
  final Color bgColor;
  final Color textColor;
  final VoidCallback onTap;

  const _Header({
    required this.result,
    required this.open,
    required this.bgColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius:
                    BorderRadius.circular(6),
              ),
              child: Text(
                '${result.statusEmoji} '
                '${result.statusText}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Type
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 7,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppTheme.gray100,
                borderRadius:
                    BorderRadius.circular(5),
                border: Border.all(
                  color: AppTheme.gray200,
                ),
              ),
              child: Text(
                result.type,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.gray700,
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Country + status
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  if (result.country != '??')
                    Text(
                      '🌏 ${result.country}'
                      ' ${result.city}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.gray600,
                      ),
                      overflow: 
                          TextOverflow.ellipsis,
                    ),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: result.portOpen
                              ? AppTheme.success
                              : AppTheme.danger,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        result.portOpen
                            ? 'Online'
                            : 'Offline',
                        style: TextStyle(
                          fontSize: 11,
                          color: result.portOpen
                              ? AppTheme.success
                              : AppTheme.danger,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Score
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.end,
              children: [
                Text(
                  '${result.score}%',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 48,
                  height: 3,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: result.score / 100,
                      backgroundColor: 
                          AppTheme.gray200,
                      valueColor:
                          AlwaysStoppedAnimation(
                        textColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 8),

            // Arrow
            Icon(
              open
                  ? Icons.expand_less
                  : Icons.expand_more,
              color: AppTheme.gray400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final ConfigResult result;
  final bool copied;
  final VoidCallback onCopy;

  const _Body({
    required this.result,
    required this.copied,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        12, 12, 12, 12,
      ),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppTheme.gray100,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // Details grid
          _detailGrid(),
          const SizedBox(height: 12),

          // Config box
          _configBox(context),
        ],
      ),
    );
  }

  Widget _detailGrid() {
    final items = [
      ['Host', result.host],
      ['Port', result.port],
      ['IP', result.ip.isEmpty 
           ? 'Not resolved' 
           : result.ip],
      ['Provider', result.provider],
      ['Encryption', result.encryption],
      ['Org', result.org],
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: 
          const NeverScrollableScrollPhysics(),
      childAspectRatio: 3.5,
      crossAxisSpacing: 8,
      mainAxisSpacing: 4,
      children: items.map((item) {
        return Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              item[0],
              style: const TextStyle(
                fontSize: 10,
                color: AppTheme.gray400,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              item[1].isEmpty 
                  ? 'Unknown' 
                  : item[1],
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _configBox(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.gray900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'CONFIG',
                style: TextStyle(
                  fontSize: 10,
                  color: AppTheme.gray500,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
              GestureDetector(
                onTap: onCopy,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: copied
                        ? AppTheme.success
                        : AppTheme.gray700,
                    borderRadius:
                        BorderRadius.circular(4),
                  ),
                  child: Text(
                    copied ? '✓ Copied' : 'Copy',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SelectableText(
            result.config,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF4ADE80),
              fontFamily: 'monospace',
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
