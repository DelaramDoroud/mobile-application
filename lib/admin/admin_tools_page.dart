import 'package:flutter/material.dart';
import '../seeding/firestore_seed.dart';

class AdminToolsPage extends StatefulWidget {
  const AdminToolsPage({super.key});

  @override
  State<AdminToolsPage> createState() => _AdminToolsPageState();
}

class _AdminToolsPageState extends State<AdminToolsPage> {
  bool _running = false;

  Future<void> _runSeed() async {
    setState(() => _running = true);
    try {
      await FirestoreSeeder.run();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Seed done ✅')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Seed failed: $e')));
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Tools')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: _running ? null : _runSeed,
          icon: const Icon(Icons.dataset),
          label: Text(_running ? 'Running...' : 'Run Seed'),
        ),
      ),
    );
  }
}
