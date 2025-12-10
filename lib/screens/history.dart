import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico')),
      body: prov.events.isEmpty ? const Center(child: Text('Sem eventos')) : ListView.builder(
        itemCount: prov.events.length,
        itemBuilder: (c, i) {
          final e = prov.events[i];
          return ListTile(
            title: Text('${e.type} - ${e.source}'),
            subtitle: Text('Início: ${e.timestamp.toLocal()}\nProcessado: ${e.processedAt?.toLocal() ?? '—'}'),
            isThreeLine: true,
          );
        },
      ),
    );
  }
}
