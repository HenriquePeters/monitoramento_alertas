import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              value: prov.activated,
              onChanged: (_) => prov.toggleActivated(),
              title: const Text('Sistema Ativado'),
            ),
            Card(
              child: ListTile(
                title: const Text('Estado do sistema'),
                subtitle: Text(prov.activated ? 'Ativado' : 'Desativado'),
                trailing: prov.apiStatus.isNotEmpty ? const Icon(Icons.cloud_done) : const Icon(Icons.cloud_off),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.warning),
              label: const Text('Simular Alerta / Botão de Pânico'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => prov.simulateAlert(source: 'Manual'),
            ),
            const SizedBox(height: 16),
            if (prov.apiStatus.isNotEmpty) Card(
              child: ListTile(
                title: const Text('API Status / Banner'),
                subtitle: Text(prov.apiStatus),
                trailing: IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => prov.refreshApiStatus(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: prov.events.isEmpty
                ? const Center(child: Text('Nenhum evento recente'))
                : ListView.builder(
                    itemCount: prov.events.length,
                    itemBuilder: (c, i) {
                      final e = prov.events[i];
                      return ListTile(
                        leading: const Icon(Icons.notifications),
                        title: Text('${e.type} — ${e.source}'),
                        subtitle: Text(e.timestamp.toLocal().toString()),
                        trailing: e.processedAt == null ? const Text('Pendente') : Text('Processado'),
                      );
                    },
                  ),
            )
          ],
        ),
      ),
    );
  }
}
