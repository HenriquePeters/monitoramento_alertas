import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Preferências')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Vibração'),
              value: prov.vibrate,
              onChanged: (v) => prov.updatePreferences(v: v),
            ),
            SwitchListTile(
              title: const Text('Som'),
              value: prov.sound,
              onChanged: (v) => prov.updatePreferences(s: v),
            ),
            SwitchListTile(
              title: const Text('Banner (notificações visuais)'),
              value: prov.banner,
              onChanged: (v) => prov.updatePreferences(b: v),
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Modo Crítico (tentar tocar som mesmo em DND)'),
              value: prov.criticalMode,
              onChanged: (v) => prov.updatePreferences(critical: v),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                
                await prov.simulateAlert(source: 'Preferences Test');
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Alerta simulado')));
              },
              child: const Text('Testar Alerta'),
            ),
          ],
        ),
      ),
    );
  }
}
