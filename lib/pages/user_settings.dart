import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({super.key});

  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  String userEmail = 'Loading...';
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final name = doc.data()?['name'] ?? 'No Name';
        final email = user.email ?? 'No Email';

        _nameController.text = name;
        setState(() {
          userEmail = email;
        });

        Provider.of<UserProvider>(context, listen: false).setName(name);
      }
    }
  }

  Future<void> updateUserName(String newName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {'name': newName},
      );

      Provider.of<UserProvider>(context, listen: false).setName(newName);

      setState(() {
        _nameController.text = newName;
      });
    }
  }

  void showEditDialog() {
    showDialog(
      context: context,
      builder: (_) {
        final tempController = TextEditingController(
          text: _nameController.text,
        );
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Ubah Nama'),
          content: TextField(
            controller: tempController,
            decoration: const InputDecoration(
              labelText: 'Nama Baru',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = tempController.text.trim();
                if (newName.isNotEmpty) {
                  updateUserName(newName);
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[600],
              ),
              child: const Text(
                'Simpan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userName = context.watch<UserProvider>().name;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Pengguna'),
        backgroundColor: Colors.brown[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profil Pengguna',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.brown),
                title: Text(userName),
                subtitle: const Text('Nama Lengkap'),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.email, color: Colors.brown),
                title: Text(userEmail),
                subtitle: const Text('Email'),
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: showEditDialog,
                icon: const Icon(Icons.edit),
                label: const Text('Ubah Nama'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
