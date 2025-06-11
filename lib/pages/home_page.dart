import 'package:flutter/material.dart';
import 'package:kopiradar/pages/detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kopiradar/auth/login.dart';
import 'package:kopiradar/pages/qr_scanner_page.dart';
import 'package:kopiradar/pages/user_settings.dart';
import 'package:kopiradar/providers/user_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showLogout = false;
  bool isHome = true;
  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final userProvider = Provider.of<UserProvider>(context, listen: false);

      if (snapshot.exists && snapshot.data()!.containsKey('name')) {
        userProvider.setName(snapshot.data()!['name']);
      } else {
        userProvider.setName(user.email ?? 'User');
      }
    }
  }

  final List<Map<String, String>> cards = [
    {
      'title': 'Bar',
      'subtitle': 'INF Coffee',
      'image': 'assets/images/Bar INF.jpg',
    },
    {
      'title': 'Lobby',
      'subtitle': 'INF Coffee',
      'image': 'assets/images/INF Lobby.jpg',
    },
    {
      'title': 'Mushola',
      'subtitle': 'INF Coffee',
      'image': 'assets/images/INF Mushola.jpg',
    },
    {
      'title': 'Toilet',
      'subtitle': 'INF Coffee',
      'image': 'assets/images/INF Toilet.jpg',
    },
    {
      'title': 'Parkir Area',
      'subtitle': 'INF Coffee',
      'image': 'assets/images/INF Parkir Area.jpg',
    },
    {
      'title': 'Social Space',
      'subtitle': 'INF Coffee',
      'image': 'assets/images/INF Social Space.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 180,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Color(0xFF131313), Color(0xFF313131)],
                    ),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(24),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Profile',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                Consumer<UserProvider>(
                                  builder: (context, userProvider, _) => Text(
                                    userProvider.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(
                                showLogout
                                    ? Icons.keyboard_arrow_down
                                    : Icons.keyboard_arrow_left,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  showLogout = !showLogout;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  top: 100,
                  left: MediaQuery.of(context).size.width / 2 - 160,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 320,
                          height: 160,
                          child: Image.asset(
                            'assets/images/INF Coffee.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              'Infokom Coffee',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black54,
                                    offset: Offset(2, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (showLogout)
                  Positioned(
                    top: 80,
                    right: 16,
                    child: Material(
                      elevation: 6,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const UserSettingsPage(),
                                  ),
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  "User Settings",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await FirebaseAuth.instance.signOut();
                                if (context.mounted) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const Login(),
                                    ),
                                    (route) => false,
                                  );
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  "Logout",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => isHome = true);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isHome
                              ? const Color(0xFFC67C4E)
                              : const Color(0xFFEFEFEF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Home',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Tombol LIHAT LOKASI
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DetailPage(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFEFEF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Lihat Lokasi',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const QRScannerPage(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F6F6),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.camera_alt_outlined),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cards.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3 / 4,
                ),
                itemBuilder: (context, index) {
                  final card = cards[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DetailPage()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 6),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Image.asset(
                              card['image']!,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  card['title']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  card['subtitle']!,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
