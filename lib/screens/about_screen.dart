import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHero(),
            _buildCreator(),
            _buildMission(),
            _buildFeatures(),
            _buildReminder(),
            _buildTechStack(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppTheme.black,
      ),
      padding: const EdgeInsets.fromLTRB(
        24, 56, 24, 40,
      ),
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius:
                  BorderRadius.circular(22),
            ),
            child: const Center(
              child: Text(
                '🔒',
                style: TextStyle(fontSize: 44),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'VPN Config Verifier',
            style: TextStyle(
              color: AppTheme.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: AppTheme.gray800,
              borderRadius:
                  BorderRadius.circular(99),
            ),
            child: const Text(
              'v1.0.0  •  Free Forever  •  Never Sleeps',
              style: TextStyle(
                color: AppTheme.gray400,
                fontSize: 11,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Making the digital world\nsafer for everyone',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.gray400,
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreator() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.gray200,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Creator header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppTheme.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.gray800,
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Text(
                      '👨‍💻',
                      style: TextStyle(
                        fontSize: 28,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chan Nyein Min',
                        style: TextStyle(
                          color: AppTheme.white,
                          fontSize: 18,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '19 years old  •  Developer',
                        style: TextStyle(
                          color: AppTheme.gray400,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Story content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                _paragraph(
                  'This entire project was created '
                  'by a 19-year-old guy named '
                  'Chan Nyein Min. He used Claude '
                  'AI as a tool to help develop '
                  'this project.',
                ),
                const SizedBox(height: 14),
                _paragraph(
                  'The purpose of this project is '
                  'to make the digital world safer '
                  'for everyone. It checks whether '
                  'free services, tools, or '
                  'resources are safe to use or '
                  'whether they contain potential '
                  'risks.',
                ),
                const SizedBox(height: 14),
                _paragraph(
                  'I created this project with '
                  'pride, with the goal of helping '
                  'and protecting people around '
                  'the world.',
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.black,
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        '❝',
                        style: TextStyle(
                          color: AppTheme.gray600,
                          fontSize: 32,
                          height: 0.8,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Technology should protect '
                        'people, not harm them.',
                        style: TextStyle(
                          color: AppTheme.white,
                          fontSize: 15,
                          fontStyle:
                              FontStyle.italic,
                          height: 1.6,
                        ),
                        textAlign:
                            TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '— Chan Nyein Min',
                        style: TextStyle(
                          color: AppTheme.gray500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMission() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        16, 0, 16, 16,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                '🎯',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(width: 10),
              Text(
                'Our Mission',
                style: TextStyle(
                  color: AppTheme.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _missionRow(
            '🌍',
            'Global Safety',
            'Help people worldwide use '
                'internet safely and securely',
          ),
          _missionRow(
            '🔍',
            'Transparency',
            'Show clearly if a VPN config '
                'is safe or potentially risky',
          ),
          _missionRow(
            '🆓',
            'Always Free',
            'This tool will always be '
                'completely free for everyone',
          ),
          _missionRow(
            '🛡️',
            'Protection',
            'Protect users from malicious '
                'or fake VPN configurations',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatures() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        16, 0, 16, 16,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.gray100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.gray200,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                '⚡',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(width: 10),
              Text(
                'App Features',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _featureRow(
            '✅',
            'Single Config Verify',
            'Check if one VPN config '
                'link is safe to use',
          ),
          _featureRow(
            '📋',
            'Bulk Config Check',
            'Verify up to 100 configs '
                'at the same time',
          ),
          _featureRow(
            '🔗',
            'Subscription URL Check',
            'Analyze entire V2Ray '
                'subscription links',
          ),
          _featureRow(
            '📊',
            'Safety Score 0-100%',
            'Clear safety rating for '
                'every config checked',
          ),
          _featureRow(
            '🌍',
            'Server Location Info',
            'See exact country and city '
                'of each VPN server',
          ),
          _featureRow(
            '🔒',
            'Encryption Check',
            'Verify the encryption '
                'strength and protocol used',
          ),
          _featureRow(
            '📋',
            'Copy Config',
            'One tap to copy any '
                'config to clipboard',
          ),
          _featureRow(
            '☁️',
            'Powered by Cloudflare',
            'Fast global infrastructure '
                'that never sleeps',
          ),
        ],
      ),
    );
  }

  Widget _buildReminder() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        16, 0, 16, 16,
      ),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: const BorderSide(
            color: AppTheme.warning,
            width: 4,
          ),
          top: BorderSide(
            color: AppTheme.gray200,
          ),
          right: BorderSide(
            color: AppTheme.gray200,
          ),
          bottom: BorderSide(
            color: AppTheme.gray200,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text(
                  '⚠️',
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Important for Myanmar Users',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Myanmar ISP blocks some '
              'international services. '
              'Please follow these steps:',
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.gray600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            _step(
              '1',
              'Install Psiphon',
              'Search "Psiphon" on Google '
                  'Play Store and install it. '
                  'It is completely free.',
            ),
            _step(
              '2',
              'Connect to Singapore',
              'Open Psiphon → Connect → '
                  'Choose Singapore region '
                  'for best speed.',
            ),
            _step(
              '3',
              'Open This App',
              'After Psiphon is connected, '
                  'open VPN Verifier app. '
                  'You will see "Server Online".',
            ),
            _step(
              '4',
              'Paste Your Config',
              'Copy your V2Ray config link '
                  'and paste it in Single tab '
                  'to verify it.',
            ),
            _step(
              '5',
              'Use Safe Configs Only',
              'Only use configs with score '
                  '75% or higher. Never use '
                  'configs below 55%.',
            ),
            const SizedBox(height: 16),

            // Safe score guide
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.gray100,
                borderRadius:
                    BorderRadius.circular(10),
                border: Border.all(
                  color: AppTheme.gray200,
                ),
              ),
              child: const Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Safety Score Guide',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 10),
                  _ScoreRow(
                    '🟢',
                    '75 - 100%',
                    'Safe to use',
                    AppTheme.success,
                  ),
                  SizedBox(height: 6),
                  _ScoreRow(
                    '🟡',
                    '55 - 74%',
                    'Use with caution',
                    AppTheme.warning,
                  ),
                  SizedBox(height: 6),
                  _ScoreRow(
                    '🔴',
                    '0 - 54%',
                    'Dangerous - Avoid',
                    AppTheme.danger,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Warning
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.dangerBg,
                borderRadius:
                    BorderRadius.circular(10),
                border: Border.all(
                  color: AppTheme.danger
                      .withOpacity(0.3),
                ),
              ),
              child: const Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    '🚨',
                    style:
                        TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Never use VPN configs '
                      'from unknown strangers! '
                      'Fake configs can steal '
                      'your passwords, spy on '
                      'your messages, and '
                      'expose your identity.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.danger,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechStack() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        16, 0, 16, 16,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                '🛠️',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(width: 10),
              Text(
                'Built With',
                style: TextStyle(
                  color: AppTheme.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _badge('Flutter'),
              _badge('Dart'),
              _badge('Cloudflare Workers'),
              _badge('JavaScript'),
              _badge('GitHub Actions'),
              _badge('Claude AI'),
              _badge('Android'),
              _badge('REST API'),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'This app was built entirely '
            'on an Android phone using '
            'Termux terminal. No laptop '
            'or PC was used.',
            style: TextStyle(
              color: AppTheme.gray500,
              fontSize: 12,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        24, 8, 24, 40,
      ),
      child: const Column(
        children: [
          Divider(color: AppTheme.gray200),
          SizedBox(height: 20),
          Text(
            '© 2025 Chan Nyein Min',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Made with ❤️ for a safer internet',
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.gray500,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'FREE  •  OPEN  •  SAFE',
            style: TextStyle(
              fontSize: 10,
              color: AppTheme.gray400,
              letterSpacing: 3,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  // ── Helpers ──

  Widget _paragraph(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: AppTheme.gray700,
        height: 1.7,
      ),
    );
  }

  Widget _missionRow(
    String emoji,
    String title,
    String desc,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            emoji,
            style: const TextStyle(
              fontSize: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(
                    color: AppTheme.gray400,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureRow(
    String emoji,
    String title,
    String desc,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 14,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius:
                  BorderRadius.circular(10),
              border: Border.all(
                color: AppTheme.gray200,
              ),
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.gray500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _step(
    String number,
    String title,
    String desc,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 14,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppTheme.black,
              borderRadius:
                  BorderRadius.circular(99),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: AppTheme.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.gray600,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppTheme.gray800,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(
          color: AppTheme.gray700,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppTheme.gray300,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// Score row helper widget
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
