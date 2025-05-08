import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String profileImage = 'assets/profile_placeholder.jpg'; // Replace with actual URL or asset
  final String name = 'Vishnu';
  final String email = 'vishnu@example.com';
  final String phone = '+91 9876543210';

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: const Color(0XFF120698),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Image
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(profileImage),
            ),
            const SizedBox(height: 16),

            // Name
            Text(
              name,
              style: TextStyle(
                fontSize: 20 * textScaleFactor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Flutter Developer',
              style: TextStyle(
                fontSize: 14 * textScaleFactor,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),

            // Info Cards
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.email, color: Color(0XFF120698)),
                title: const Text('Email'),
                subtitle: Text(email),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.phone, color: Color(0XFF120698)),
                title: const Text('Phone'),
                subtitle: Text(phone),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
