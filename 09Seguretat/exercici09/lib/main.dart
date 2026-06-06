import 'package:flutter/material.dart';

import 'screens.dart';
import 'app_theme.dart';

void main() => runApp(const CryptoApp());

class CryptoApp extends StatelessWidget {
  const CryptoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CryptoApp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const _Main(),
    );
  }
}

class _Main extends StatefulWidget {
  const _Main();

  @override
  State<_Main> createState() => _MainState();
}

class _MainState extends State<_Main> with SingleTickerProviderStateMixin {
  int _tab = 0;
  late final TabController _tc;

  @override
  void initState() {
    super.initState();
    _tc = TabController(length: 2, vsync: this);
    _tc.addListener(() {
      if (!_tc.indexIsChanging) setState(() => _tab = _tc.index);
    });
  }

  @override
  void dispose() {
    _tc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        title: Text(
          'Criptografia asimètrica',
          style: AppTheme.heading,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: TabBar(
            controller: _tc,
            indicatorColor: _tab == 0 ? AppTheme.primary : AppTheme.secondary,
            labelColor: _tab == 0 ? AppTheme.primary : AppTheme.secondary,
            unselectedLabelColor: AppTheme.textSub,
            tabs: const [
              Tab(text: 'Encriptar'),
              Tab(text: 'Desencriptar'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tc,
        children: const [
          EncryptView(),
          DecryptView(),
        ],
      ),
    );
  }
}