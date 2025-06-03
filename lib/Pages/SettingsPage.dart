import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proje2/Providers/settings_provider.dart';

import '../Widgets/BasePage.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'The Lost City',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2025 Sumia & Mariam',
      children: const [
        Text('The Lost City is an educational and fun city-guessing game.'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return BasePage(
      title: 'Settings',
      child: ListView(
        children: [
          SwitchListTile(
            title: const Text('Sound Effects'),
            value: settings.isSoundEnabled,
            onChanged: settings.toggleSound,
            secondary: const Icon(Icons.volume_up),
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: settings.isDarkMode,
            onChanged: settings.toggleDarkMode,
            secondary: const Icon(Icons.brightness_6),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () => _showAboutDialog(context),
          ),
        ],
      ),
    );
  }
}
