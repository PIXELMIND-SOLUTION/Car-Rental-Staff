import 'dart:io';
import 'package:car_rental_staff_app/models/user_model.dart';
import 'package:car_rental_staff_app/providers/auth_provider.dart';
import 'package:car_rental_staff_app/services/api/user_service.dart';
import 'package:flutter/material.dart';


class UserController with ChangeNotifier{
  final UserService _userService = UserService();

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  void setUploading(bool value){
    _isUploading = value;
    notifyListeners();
  }

// Future<void> updateProfileImage({
//   required BuildContext context,
//   required File image,
//   required String id,
// }) async {
//   setUploading(true);
//   try {
//     final response = await _userService.updateProfileImage(image, id);
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Profile image updated successfully')),
//     );
//     notifyListeners(); 
//   } catch (e) {
//     print("Error uploading profile image: $e");
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Failed to update profile image')),
//     );
//   } finally {
//     setUploading(false);
//   }
// }

Future<void> updateProfileImage({
  required BuildContext context,
  required File image,
  required String id,
  required AuthProvider authProvider,
}) async {
  setUploading(true);
  try {
    final response = await _userService.updateProfileImage(image, id);

    // Extract updated profileImage
    final updatedUser = response['user'];
    if (updatedUser != null && updatedUser['profileImage'] != null) {
      // Update the current user in AuthProvider
      UserModel? currentUser = authProvider.user;
      if (currentUser != null) {
        final updatedUserModel = UserModel(
          id: currentUser.id,
          mobile: currentUser.mobile,
          name: currentUser.name,
          myBookings: currentUser.myBookings,
          profileImage: updatedUser['profileImage'],
        );

        print('hhhhhhhhhhhhhhhhhhh${updatedUserModel.profileImage}');

        authProvider.updateUser(updatedUserModel); // Update user in AuthProvider
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile image updated successfully')),
    );
    notifyListeners();
  } catch (e) {
    print("Error uploading profile image: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to update profile image')),
    );
  } finally {
    setUploading(false);
    notifyListeners();
  }
}


}