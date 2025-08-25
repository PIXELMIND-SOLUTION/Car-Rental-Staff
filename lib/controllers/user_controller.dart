
import 'dart:io';
import 'package:car_rental_staff_app/models/user_model.dart';
import 'package:car_rental_staff_app/providers/auth_provider.dart';
import 'package:car_rental_staff_app/services/api/user_service.dart';
import 'package:car_rental_staff_app/utils/storage_helper.dart';
import 'package:flutter/material.dart';

class UserController with ChangeNotifier {
  final UserService _userService = UserService();

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  void setUploading(bool value) {
    print("🔄 UserController: setUploading($value)");
    _isUploading = value;
    notifyListeners();
    print("✅ UserController: notifyListeners() called for uploading state");
  }

  Future<void> updateProfileImage({
    required BuildContext context,
    required File image,
    required String id,
    required AuthProvider authProvider,
  }) async {
    print("🚀 UserController: Starting updateProfileImage");
    print("   File path: ${image.path}");
    print("   User ID: $id");
    
    setUploading(true);
    
    try {
      print("📡 UserController: Calling API service...");
      final response = await _userService.updateProfileImage(image, id);
      print("📡 UserController: API Response received: $response");

      // Check if response contains user data
      if (response.containsKey('staff')) {
        final updatedUser = response['staff'];
        print("👤 UserController: Updated user data: $updatedUser");
        
        if (updatedUser != null && updatedUser.containsKey('profileImage')) {
          final newProfileImage = updatedUser['profileImage'];
          print("🖼️ UserController: New profile image from API: $newProfileImage");

          // Get current user from AuthProvider
          UserModel? currentUser = authProvider.user;
          print("👤 UserController: Current user from AuthProvider: ${currentUser?.toJson()}");
          
          if (currentUser != null) {
            // Create updated user model
            final updatedUserModel = UserModel(
              id: currentUser.id,
              mobile: currentUser.mobile,
              email: currentUser.email,
              name: currentUser.name,
              // myBookings: currentUser.myBookings,
              profileImage: newProfileImage,
            );

            print("👤 UserController: Created updated user model: ${updatedUserModel.toJson()}");

            // Update AuthProvider
            print("🔄 UserController: Updating AuthProvider...");
            await authProvider.updateUser(updatedUserModel);
            print("✅ UserController: AuthProvider updated");
            
            // Verify AuthProvider was updated
            print("🔍 UserController: Verifying AuthProvider update...");
            final verifyUser = authProvider.user;
            print("   AuthProvider user after update: ${verifyUser?.toJson()}");

            // Update SharedPreferences
            print("💾 UserController: Updating SharedPreferences...");
            await StorageHelper.saveUserId(
              updatedUserModel.id ?? '',
              updatedUserModel.name ?? '',
              updatedUserModel.mobile ?? '',
              updatedUserModel.email ?? '',
              updatedUserModel.profileImage,
            );
            print("✅ UserController: SharedPreferences updated");
            
            // Verify SharedPreferences was updated
            print("🔍 UserController: Verifying SharedPreferences update...");
            final verifySharedPrefs = await StorageHelper.getAllUserData();
            print("   SharedPreferences after update: $verifySharedPrefs");

          } else {
            print("❌ UserController: Current user is null in AuthProvider");
            
            // Fallback: Update SharedPreferences only
            print("💾 UserController: Fallback - updating SharedPreferences only...");
            final userData = await StorageHelper.getAllUserData();
            await StorageHelper.saveUserId(
              userData['userId'] ?? '',
              userData['userName'] ?? '',
              userData['mobile'] ?? '',
              userData['email'] ?? '',
              newProfileImage,
            );
            print("✅ UserController: SharedPreferences updated (fallback)");
          }
        } else {
          print("❌ UserController: No profileImage in user data");
        }
      } else {
        print("❌ UserController: No user data in API response");
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile image updated successfully')),
      );
      
      print("🔄 UserController: Calling notifyListeners()...");
      notifyListeners();
      print("✅ UserController: notifyListeners() called");
      
    } catch (e) {
      print("❌ UserController: Error in updateProfileImage: $e");
      print("❌ UserController: Stack trace: ${StackTrace.current}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile image')),
      );
    } finally {
      print("🏁 UserController: Finally block - setting uploading to false");
      setUploading(false);
    }
  }
}