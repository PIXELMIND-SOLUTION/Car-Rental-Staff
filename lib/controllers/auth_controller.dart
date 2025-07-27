
// import 'package:car_rental_staff_app/providers/auth_provider.dart';
// import 'package:car_rental_staff_app/services/api/auth_service.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class AuthController {
//   final AuthService _authService = AuthService();

//   Future<bool> loginUser(BuildContext context, String mobile) async {
//     try{
//       final user = await _authService.login(mobile);
//       return false;
//     }catch(e){
//       return false;
//     }
//   }
// }


import 'package:car_rental_staff_app/providers/auth_provider.dart';
import 'package:car_rental_staff_app/services/api/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthController {
  final AuthService _authService = AuthService();

  Future<bool> loginUser(BuildContext context, String mobile) async {
    try {
      final user = await _authService.login(mobile);
      if (user != null) {
        // Login successful, OTP should be sent
        return true;
      }
      return false;
    } catch (e) {
      print('Login Error in Controller: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> verifyOtp(BuildContext context, String otp) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final result = await _authService.verifyOtp(otp);
      
      if (result['success'] == true && result['user'] != null) {
        // Set user in provider
        authProvider.setUser(result['user']);
        return {'success': true, 'message': 'OTP verified successfully'};
      } else {
        return {'success': false, 'message': result['message'] ?? 'OTP verification failed'};
      }
    } catch (e) {
      print('OTP Verification Error in Controller: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> resendOtp(String? mobile) async {
    try {
      final result = await _authService.resendOtp(mobile);
      return result;
    } catch (e) {
      print('Resend OTP Error in Controller: $e');
      return {'success': false, 'message': e.toString()};
    }
  }
}