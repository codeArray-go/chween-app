import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingPage> {
  bool _notificationsEnabled = true;
  bool _darkMode = true;
  final double _fontSize = 16.0;

  @override
  Widget build(BuildContext context) {
    const Color electricGreen = Color(0xFF69FF68);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildSectionHeader("Appearance"),

          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              image: const DecorationImage(image: NetworkImage("https://images.unsplash.com/photo-1550684848-fac1c5b4e853"), fit: BoxFit.cover),
            ),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: Colors.black12),
              child: Center(
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.wallpaper_rounded, color: electricGreen),
                  label: const Text("Change Wallpaper", style: TextStyle(color: Colors.white)),
                  style: TextButton.styleFrom(backgroundColor: Colors.black38),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          _buildSettingTile(
            icon: Icons.dark_mode_rounded,
            title: "Dark Mode",
            trailing: Switch(value: _darkMode, activeThumbColor: electricGreen, onChanged: (val) => setState(() => _darkMode = val)),
          ),

          _buildSettingTile(icon: Icons.text_fields_rounded, title: "Text Size", subtitle: "${_fontSize.toInt()}px", onTap: () {}),

          _buildSectionHeader("System"),

          _buildSettingTile(
            icon: Icons.notifications_active_rounded,
            title: "Notifications",
            trailing: Switch(value: _notificationsEnabled, activeThumbColor: electricGreen, onChanged: (val) => setState(() => _notificationsEnabled = val)),
          ),

          _buildSettingTile(icon: Icons.language_rounded, title: "Language", subtitle: "English (US)", onTap: () {}),

          _buildSettingTile(icon: Icons.storage_rounded, title: "Data & Storage", onTap: () {}),

          const SizedBox(height: 30),

          Center(
            child: Text("App Version 1.0.4", style: TextStyle(color: Colors.white10, fontSize: 12)),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(color: Color(0xFF69FF68), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildSettingTile({required IconData icon, required String title, String? subtitle, Widget? trailing, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.white70),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        subtitle: subtitle != null ? Text(subtitle, style: TextStyle(color: Colors.white10)) : null,
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white24),
      ),
    );
  }
}
