import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/result_card.dart';
import '../theme/app_theme.dart';

class SingleScreen extends StatefulWidget {
  const SingleScreen({super.key});

  @override
  State<SingleScreen> createState() =>
      _SingleScreenState();
}

class _SingleScreenState 
    extends State<SingleScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
              // Input section
              _buildInput(provider),
              const SizedBox(height: 16),

              // Buttons
              _buildButtons(provider),
              const SizedBox(height: 20),

              // Result
              if (provider.singleStatus ==
                  Status.loading)
                _buildLoading(),

              if (provider.singleStatus ==
                  Status.error)
                _buildError(provider),

              if (provider.singleResult != null)
                ResultCard(
                  result: provider.singleResult!,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInput(AppProvider provider) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'CONFIG LINK',
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
          maxLines: 5,
          style: const TextStyle(
            fontSize: 13,
            fontFamily: 'monospace',
          ),
          decoration: const InputDecoration(
            hintText:
                'Paste your config here...\n'
                'vmess://...\n'
                'vless://...\n'
                'trojan://...\n'
                'ss://...',
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Supports: VMess, VLESS, Trojan, '
          'Shadowsocks, Hysteria, TUIC',
          style: TextStyle(
            fontSize: 11,
            color: AppTheme.gray400,
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(AppProvider provider) {
    final loading = provider.singleStatus == 
        Status.loading;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: loading ? null : () {
              final text = 
                  _controller.text.trim();
              if (text.isEmpty) {
                _showSnack(
                  'Please paste a config',
                );
                return;
              }
              provider.verifySingle(text);
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
                : const Text('Verify Config'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              _controller.clear();
              provider.clearSingle();
            },
            child: const Text('Clear'),
          ),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            CircularProgressIndicator(
              color: AppTheme.black,
              strokeWidth: 2,
            ),
            SizedBox(height: 12),
            Text(
              'Checking config...',
              style: TextStyle(
                color: AppTheme.gray500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(AppProvider provider) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.dangerBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.danger
              .withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          const Text('❌ '),
          Expanded(
            child: Text(
              provider.singleError,
              style: const TextStyle(
                color: AppTheme.danger,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppTheme.black,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
