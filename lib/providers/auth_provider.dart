




import 'package:car_rental_staff_app/models/user_model.dart';
import 'package:car_rental_staff_app/utils/storage_helper.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  String? _localImageUrl;

  UserModel? get user => _user;

  String get localImageUrl => _localImageUrl ??
      'https://avatar.iran.liara.run/public/boy?username=Ash';

  Future<void> loadProfileImage() async {
    final profileImage = _user?.profileImage ?? await StorageHelper.getProfileImage();

    if (profileImage != null) {
      _localImageUrl = 'https://carrentalbackent.onrender.com$profileImage';
    } else {
      _localImageUrl =
          'https://avatar.iran.liara.run/public/boy?username=Ash';
    }

    notifyListeners();
  }

  void setUser(UserModel user) {
    _user = user;
    StorageHelper.saveUserId(user.id, user.name, user.mobile);
    notifyListeners();
  }

  Future<void> updateProfileImage(String imagePath) async {
    if (_user != null) {
      await StorageHelper.updateProfileImage(
        _user!.id,
        _user!.name,
        _user!.mobile,
        imagePath,
      );
      _user = _user!.copyWith(profileImage: imagePath);
      await loadProfileImage();
    }
  }

  void updateUser(UserModel updatedUser) async {
  _user = updatedUser;

  await StorageHelper.updateProfileImage(
    updatedUser.id,
    updatedUser.name,
    updatedUser.mobile,
    updatedUser.profileImage ?? '',
  );

  await loadProfileImage(); // updates _localImageUrl
  notifyListeners();
}


  void logout() {
    _user = null;
    _localImageUrl = null;
    StorageHelper.clearUserId();
    notifyListeners();
  }
}
