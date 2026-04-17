import 'package:chween_app/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    const Color electricGreen = Color(0xFF69FF68);
    final authsProvider = ref.watch(authProvider);
    final authsNotifier = ref.read(authProvider.notifier);
    final user = authsProvider.user as Map<String, dynamic>;

    final ImageProvider profileImage = (user['profile_pic'].toString().isNotEmpty) ? NetworkImage(user['profile_pic']) : const AssetImage("assets/images/default_user.png");

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            // 1. TOP CENTER IMAGE WITH EDIT OPTION
            Center(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: electricGreen, shape: BoxShape.circle),
                    child: CircleAvatar(radius: 60, backgroundImage: profileImage),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt, size: 20, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 2. NAME & EMAIL SECTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  if (_isEditing)
                    TextField(
                      controller: _nameController,
                      autofocus: true,
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: electricGreen)),
                      ),
                    )
                  else
                    Text(
                      user['full_name'],
                      style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                    ),

                  const SizedBox(height: 8),

                  Text(user['email'], style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 3. FEATURE CARDS
            _buildProfileOption(
              icon: _isEditing ? Icons.check_circle : Icons.edit,
              title: _isEditing ? "Save Profile" : "Edit Name",
              color: electricGreen,
              onTap: () {
                setState(() => _isEditing = !_isEditing);
              },
            ),

            // Added Feature: Privacy/Security
            _buildProfileOption(icon: Icons.shield_moon_outlined, title: "Privacy & Security", color: Colors.white70, onTap: () {}),

            // Added Feature: App Theme (Matches your cool bar)
            _buildProfileOption(icon: Icons.palette_outlined, title: "Customization", color: Colors.white70, onTap: () {}),

            const Divider(color: Colors.white12, height: 40, indent: 30, endIndent: 30),

            // 4. DANGER ZONE
            _buildProfileOption(
              icon: Icons.logout_rounded,
              title: "Logout",
              color: Colors.orangeAccent,
              onTap: () {
                authsNotifier.logout();
              },
            ),

            _buildProfileOption(
              icon: Icons.delete_forever_rounded,
              title: "Delete Account",
              color: Colors.redAccent,
              isLast: true,
              onTap: () {
                // Show Delete Confirmation Dialog
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({required IconData icon, required String title, required Color color, required VoidCallback onTap, bool isLast = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, color: Colors.white10, size: 16),
          ],
        ),
      ),
    );
  }
}
