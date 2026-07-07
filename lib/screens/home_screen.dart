import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import 'single_screen.dart';
import 'bulk_screen.dart';
import 'subscription_screen.dart';
import 'history_screen.dart';

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
    HistoryScreen(),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
      context.read<AppProvider>().pingServer()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _screens[_index],
      bottomNavigationBar: _navBar(),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius:
                  BorderRadius.circular(5),
            ),
            child: const Center(
              child: Text(
                '🔒',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'VPN Verifier',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      actions: [
        Consumer<AppProvider>(
          builder: (_, p, __) => Padding(
            padding: const EdgeInsets.only(
              right: 16,
            ),
            child: Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: p.serverOnline
                        ? AppTheme.success
                        : AppTheme.danger,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  p.serverOnline
                      ? 'Server Online'
                      : 'Server Offline',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.gray400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _navBar() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppTheme.gray200,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) =>
            setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.link_rounded),
            label: 'Single',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'Bulk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rss_feed_rounded),
            label: 'Subscribe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline_rounded),
            label: 'Guide',
          ),
        ],
      ),
    );
  }
}
