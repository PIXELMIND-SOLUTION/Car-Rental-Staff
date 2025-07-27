

// import 'dart:io';
// import 'package:car_rental_staff_app/controllers/user_controller.dart';
// import 'package:car_rental_staff_app/utils/storage_helper.dart';
// import 'package:car_rental_staff_app/providers/auth_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final ImagePicker _picker = ImagePicker();

//   Future<void> _showImageSourceDialog() async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Select Image Source'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 GestureDetector(
//                   child: const Row(
//                     children: [
//                       Icon(Icons.camera_alt, color: Color(0XFF120698)),
//                       SizedBox(width: 10),
//                       Text('Camera'),
//                     ],
//                   ),
//                   onTap: () {
//                     Navigator.of(context).pop();
//                     _pickImageFromSource(ImageSource.camera);
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 GestureDetector(
//                   child: const Row(
//                     children: [
//                       Icon(Icons.photo_library, color: Color(0XFF120698)),
//                       SizedBox(width: 10),
//                       Text('Gallery'),
//                     ],
//                   ),
//                   onTap: () {
//                     Navigator.of(context).pop();
//                     _pickImageFromSource(ImageSource.gallery);
//                   },
//                 ),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _pickImageFromSource(ImageSource source) async {
//     try {
//       final XFile? pickedFile = await _picker.pickImage(
//         source: source,
//         maxWidth: 1024,
//         maxHeight: 1024,
//         imageQuality: 85,
//       );

//       if (pickedFile != null) {
//         File imageFile = File(pickedFile.path);
//         await _updateProfileImage(imageFile);
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to pick image')),
//       );
//     }
//   }

//   Future<void> _updateProfileImage(File image) async {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final userController = Provider.of<UserController>(context, listen: false);

//     String? userId = authProvider.user?.id;
//     if (userId == null || userId.isEmpty) {
//       userId = await StorageHelper.getUserId();
//     }

//     if (userId == null || userId.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('User ID not found. Please login again.')),
//       );
//       return;
//     }

//     try {
//       await userController.updateProfileImage(
//         context: context,
//         image: image,
//         id: userId,
//         authProvider: authProvider,
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to update profile image')),
//       );
//     }
//   }

//   String _getProfileImageUrl(String? profileImage, String userName) {
//     final timestamp = DateTime.now().millisecondsSinceEpoch;

//     if (profileImage != null &&
//         profileImage.isNotEmpty &&
//         !profileImage.contains('null')) {
//       if (profileImage.startsWith('http')) {
//         return '$profileImage?v=$timestamp';
//       } else {
//         return 'https://carrentalbackent.onrender.com$profileImage?v=$timestamp';
//       }
//     }

//     return 'https://avatar.iran.liara.run/public/boy?username=${userName.replaceAll(' ', '')}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     double textScaleFactor = MediaQuery.of(context).textScaleFactor;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: Container(
//           margin: const EdgeInsets.all(8.0),
//           decoration: BoxDecoration(
//             color: Colors.grey.shade200,
//             shape: BoxShape.circle,
//           ),
//           child: IconButton(
//             icon: const Icon(
//               Icons.arrow_back,
//               color: Colors.black,
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//         ),
//         title: Text(
//           "Profile",
//           style: const TextStyle(
//             color: Color.fromARGB(255, 0, 0, 0),
//             fontSize: 18,
//             fontWeight: FontWeight.w800,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Consumer2<AuthProvider, UserController>(
//         builder: (context, authProvider, userController, child) {
//           final user = authProvider.user;
//           final String profileImage = user?.profileImage ?? '';
//           final String userName = user?.name ?? 'Unknown User';
//           final String email = user?.email ?? 'No Email';
//           final String mobile = user?.mobile ?? 'No Mobile';

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 // Profile Image with Edit Icon
//                 Stack(
//                   children: [
//                     CircleAvatar(
//                       radius: 60,
//                       backgroundImage: NetworkImage(
//                           _getProfileImageUrl(profileImage, userName)),
//                       backgroundColor: Colors.grey[300],
//                     ),
//                     // Loading indicator overlay
//                     if (userController.isUploading)
//                       Positioned.fill(
//                         child: Container(
//                           decoration: const BoxDecoration(
//                             color: Colors.black54,
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Center(
//                             child: CircularProgressIndicator(
//                               valueColor:
//                                   AlwaysStoppedAnimation<Color>(Colors.white),
//                             ),
//                           ),
//                         ),
//                       ),
//                     // Edit Icon
//                     Positioned(
//                       bottom: 0,
//                       right: 0,
//                       child: GestureDetector(
//                         onTap: userController.isUploading
//                             ? null
//                             : _showImageSourceDialog,
//                         child: Container(
//                           padding: const EdgeInsets.all(8),
//                           decoration: const BoxDecoration(
//                             color: Color(0XFF120698),
//                             shape: BoxShape.circle,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black26,
//                                 blurRadius: 4,
//                                 offset: Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           child: const Icon(
//                             Icons.camera_alt,
//                             color: Colors.white,
//                             size: 20,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),

//                 // Name
//                 Text(
//                   userName,
//                   style: TextStyle(
//                     fontSize: 20 * textScaleFactor,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 // Info Cards
//                 Card(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   elevation: 3,
//                   child: ListTile(
//                     leading: const Icon(Icons.email, color: Color(0XFF120698)),
//                     title: const Text('Email'),
//                     subtitle: Text(email),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Card(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   elevation: 3,
//                   child: ListTile(
//                     leading: const Icon(Icons.phone, color: Color(0XFF120698)),
//                     title: const Text('Phone'),
//                     subtitle: Text(mobile),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }







import 'dart:io';
import 'package:car_rental_staff_app/controllers/user_controller.dart';
import 'package:car_rental_staff_app/utils/storage_helper.dart';
import 'package:car_rental_staff_app/providers/auth_provider.dart';
import 'package:car_rental_staff_app/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _showImageSourceDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Row(
                    children: [
                      Icon(Icons.camera_alt, color: Color(0XFF120698)),
                      SizedBox(width: 10),
                      Text('Camera'),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImageFromSource(ImageSource.camera);
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  child: const Row(
                    children: [
                      Icon(Icons.photo_library, color: Color(0XFF120698)),
                      SizedBox(width: 10),
                      Text('Gallery'),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImageFromSource(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImageFromSource(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        await _updateProfileImage(imageFile);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick image')),
      );
    }
  }

  Future<void> _updateProfileImage(File image) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userController = Provider.of<UserController>(context, listen: false);

    String? userId = authProvider.user?.id;
    if (userId == null || userId.isEmpty) {
      userId = await StorageHelper.getUserId();
    }

    if (userId == null || userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID not found. Please login again.')),
      );
      return;
    }

    try {
      await userController.updateProfileImage(
        context: context,
        image: image,
        id: userId,
        authProvider: authProvider,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile image')),
      );
    }
  }

  String _getProfileImageUrl(String? profileImage, String userName) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    if (profileImage != null &&
        profileImage.isNotEmpty &&
        !profileImage.contains('null')) {
      if (profileImage.startsWith('http')) {
        return '$profileImage?v=$timestamp';
      } else {
        return 'https://carrentalbackent.onrender.com$profileImage?v=$timestamp';
      }
    }

    return 'https://avatar.iran.liara.run/public/boy?username=${userName.replaceAll(' ', '')}';
  }

  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(
                Icons.logout,
                color: Colors.red.shade600,
                size: 28,
              ),
              const SizedBox(width: 10),
              const Text(
                'Logout',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to logout from your account?',
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _performLogout() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Perform logout
      authProvider.logout();

      // Close loading dialog
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text('Logged out successfully'),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      // Navigate to login screen and clear navigation stack
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      // Close loading dialog if still open
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 10),
              Text('Logout failed: ${e.toString()}'),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    automaticallyImplyLeading: false, // Removes the default back arrow
    title: Text(
      "Profile",
      style: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
      overflow: TextOverflow.ellipsis,
    ),
  ),
      body: Consumer2<AuthProvider, UserController>(
        builder: (context, authProvider, userController, child) {
          final user = authProvider.user;
          final String profileImage = user?.profileImage ?? '';
          final String userName = user?.name ?? 'Unknown User';
          final String email = user?.email ?? 'No Email';
          final String mobile = user?.mobile ?? 'No Mobile';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Profile Image with Edit Icon
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                          _getProfileImageUrl(profileImage, userName)),
                      backgroundColor: Colors.grey[300],
                    ),
                    // Loading indicator overlay
                    if (userController.isUploading)
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ),
                      ),
                    // Edit Icon
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: userController.isUploading
                            ? null
                            : _showImageSourceDialog,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0XFF120698),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Name
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 20 * textScaleFactor,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // Info Cards
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: ListTile(
                    leading: const Icon(Icons.email, color: Color(0XFF120698)),
                    title: const Text('Email'),
                    subtitle: Text(email),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: ListTile(
                    leading: const Icon(Icons.phone, color: Color(0XFF120698)),
                    title: const Text('Phone'),
                    subtitle: Text(mobile),
                  ),
                ),
                const SizedBox(height: 20),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _showLogoutDialog,
                    icon: const Icon(Icons.logout, size: 20),
                    label: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // App Version or Additional Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, 
                               color: Colors.grey.shade600, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'App Information',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Version',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          Text(
                            '1.0.0',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Build',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          Text(
                            'Staff Portal',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}