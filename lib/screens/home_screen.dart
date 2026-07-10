import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import 'single_screen.dart';
import 'bulk_screen.dart';
import 'subscription_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {
  int _index = 0;

  final _screens = const [
    SingleScreen(),
    BulkScreen(),
    SubscriptionScreen(),
    AboutScreen(),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final provider =
          context.read<AppProvider>();
      await provider.pingServer();
      if (!provider.serverOnline && mounted) {
        _showVpnReminder();
      }
    });
  }

  void _showVpnReminder() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius:
                BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppTheme.gray100,
                  borderRadius:
                      BorderRadius.circular(18),
                  border: Border.all(
                    color: AppTheme.gray200,
                  ),
                ),
                child: const Center(
                  child: Text(
                    '🔒',
                    style: TextStyle(
                      fontSize: 34,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              const Text(
                'VPN Required',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.black,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              const Text(
                'Myanmar ISP is blocking\n'
                'this service right now',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.gray500,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 20),

              // Steps
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.gray100,
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How to fix:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w700,
                        color: AppTheme.gray600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 10),
                    _DialogStep(
                      '1️⃣',
                      'Open Psiphon app',
                    ),
                    SizedBox(height: 6),
                    _DialogStep(
                      '2️⃣',
                      'Connect Singapore server',
                    ),
                    SizedBox(height: 6),
                    _DialogStep(
                      '3️⃣',
                      'Come back here',
                    ),
                    SizedBox(height: 6),
                    _DialogStep(
                      '4️⃣',
                      'Tap "Retry" button below',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Psiphon hint
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.black,
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: const Text(
                  '💡 No Psiphon? Search it on\n'
                  'Play Store - it is FREE!',
                  style: TextStyle(
                    color: AppTheme.gray300,
                    fontSize: 12,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              // Retry button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await context
                        .read<AppProvider>()
                        .pingServer();
                    if (mounted &&
                        !context
                            .read<AppProvider>()
                            .serverOnline) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Still offline. '
                            'Check your VPN '
                            'connection.',
                          ),
                          backgroundColor:
                              AppTheme.danger,
                          behavior:
                              SnackBarBehavior
                                  .floating,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppTheme.black,
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                  child: const Text(
                    '🔄  Retry Connection',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Skip button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () =>
                      Navigator.pop(ctx),
                  child: const Text(
                    'Continue without VPN',
                    style: TextStyle(
                      color: AppTheme.gray400,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _screens[_index],
      bottomNavigationBar: _buildNavBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Row(
        children: [
          Text(
            '🔒',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(width: 8),
          Text(
            'VPN Verifier',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppTheme.white,
            ),
          ),
        ],
      ),
      actions: [
        Consumer<AppProvider>(
          builder: (_, p, __) => GestureDetector(
            onTap: () async {
              await p.pingServer();
              if (mounted &&
                  !p.serverOnline) {
                _showVpnReminder();
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(
                right: 16,
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(
                      milliseconds: 300,
                    ),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: p.serverOnline
                          ? AppTheme.success
                          : AppTheme.danger,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.serverOnline
                            ? 'Online'
                            : 'Offline',
                        style: TextStyle(
                          fontSize: 12,
                          color: p.serverOnline
                              ? AppTheme.success
                              : AppTheme.danger,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Tap to refresh',
                        style: const TextStyle(
                          fontSize: 9,
                          color: AppTheme.gray500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavBar() {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.white,
        border: Border(
          top: BorderSide(
            color: AppTheme.gray200,
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) =>
            setState(() => _index = i),
        backgroundColor: AppTheme.white,
        selectedItemColor: AppTheme.black,
        unselectedItemColor: AppTheme.gray400,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.link_rounded),
            activeIcon: Icon(
              Icons.link_rounded,
              size: 26,
            ),
            label: 'Single',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list_alt_rounded,
            ),
            activeIcon: Icon(
              Icons.list_alt_rounded,
              size: 26,
            ),
            label: 'Bulk',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.rss_feed_rounded,
            ),
            activeIcon: Icon(
              Icons.rss_feed_rounded,
              size: 26,
            ),
            label: 'Subscribe',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.info_outline_rounded,
            ),
            activeIcon: Icon(
              Icons.info_rounded,
              size: 26,
            ),
            label: 'About',
          ),
        ],
      ),
    );
  }
}

// Dialog step helper
class _DialogStep extends StatelessWidget {
  final String emoji;
  final String text;

  const _DialogStep(this.emoji, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: AppTheme.gray700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
