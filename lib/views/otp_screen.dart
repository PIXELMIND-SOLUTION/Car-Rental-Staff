
// import 'package:car_rental_staff_app/controllers/auth_controller.dart';
// import 'package:car_rental_staff_app/providers/auth_provider.dart';
// import 'package:car_rental_staff_app/views/main_layout.dart';
// import 'package:car_rental_staff_app/widgect/blurred_circle.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'dart:async';

// class OtpScreen extends StatefulWidget {
//   final String? mobile; // Optional mobile number parameter
  
//   const OtpScreen({super.key, this.mobile});

//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }

// class _OtpScreenState extends State<OtpScreen> {
//   final List<TextEditingController> _controllers = List.generate(
//     4,
//     (index) => TextEditingController(),
//   );
  
//   final List<FocusNode> _focusNodes = List.generate(
//     4,
//     (index) => FocusNode(),
//   );

//   final AuthController _authController = AuthController();
//   bool _isLoading = false;
//   bool _isResending = false;
//   bool _hasError = false; // Track if there's an error for visual feedback
  
//   // Timer related variables
//   int _resendTimer = 30;
//   bool _canResend = false;
//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();
//     // Focus on first field initially
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _focusNodes[0].requestFocus();
//     });
//     // Start the resend timer
//     _startResendTimer();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel(); // Cancel timer to prevent memory leaks
//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     for (var focusNode in _focusNodes) {
//       focusNode.dispose();
//     }
//     super.dispose();
//   }

//   String get otpCode {
//     return _controllers.map((controller) => controller.text).join();
//   }

//   bool get isOtpComplete {
//     return otpCode.length == 4 && otpCode.split('').every((char) => char.isNotEmpty);
//   }

//   void _onOtpChanged(String value, int index) {
//     setState(() {
//       _hasError = false; // Clear error state when user types
//     });

//     if (value.isNotEmpty) {
//       // Move to next field
//       if (index < 3) {
//         _focusNodes[index + 1].requestFocus();
//       } else {
//         // Last field, unfocus
//         _focusNodes[index].unfocus();
//       }
//     }

//     // Auto-verify when OTP is complete
//     if (isOtpComplete) {
//       _verifyOtp();
//     }
//   }

//   void _onBackspace(int index) {
//     if (_controllers[index].text.isEmpty && index > 0) {
//       _focusNodes[index - 1].requestFocus();
//     }
//   }

//   void _showErrorToast(String message) {
//     setState(() {
//       _hasError = true;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(
//               Icons.error_outline,
//               color: Colors.white,
//               size: 20,
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 message,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.red.shade600,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         margin: const EdgeInsets.all(16),
//         duration: const Duration(seconds: 3),
//         action: SnackBarAction(
//           label: 'Dismiss',
//           textColor: Colors.white,
//           onPressed: () {
//             ScaffoldMessenger.of(context).hideCurrentSnackBar();
//           },
//         ),
//       ),
//     );
//   }

//   void _showSuccessToast(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(
//               Icons.check_circle_outline,
//               color: Colors.white,
//               size: 20,
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 message,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.green.shade600,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         margin: const EdgeInsets.all(16),
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   void _showInfoToast(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(
//               Icons.info_outline,
//               color: Colors.white,
//               size: 20,
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 message,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.blue.shade600,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         margin: const EdgeInsets.all(16),
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   void _startResendTimer() {
//     setState(() {
//       _resendTimer = 30;
//       _canResend = false;
//     });

//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (mounted) {
//         setState(() {
//           if (_resendTimer > 0) {
//             _resendTimer--;
//           } else {
//             _canResend = true;
//             timer.cancel();
//           }
//         });
//       } else {
//         timer.cancel();
//       }
//     });
//   }

//   String _formatTimer(int seconds) {
//     int minutes = seconds ~/ 60;
//     int remainingSeconds = seconds % 60;
//     return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
//   }

//   Future<void> _verifyOtp() async {
//     if (!isOtpComplete) {
//       _showErrorToast('Please enter complete OTP');
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _hasError = false;
//     });

//     try {
//       final result = await _authController.verifyOtp(context, otpCode);
      
//       if (result['success'] == true) {
//         _showSuccessToast(result['message'] ?? 'OTP verified successfully!');
        
//         // Navigate to main layout
//         if (mounted) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const MainLayout())
//           );
//         }
//       } else {
//         _showErrorToast(result['message'] ?? 'OTP verification failed');
//         _clearOtp();
//       }
//     } catch (e) {
//       _showErrorToast('An unexpected error occurred');
//       _clearOtp();
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   void _clearOtp() {
//     for (var controller in _controllers) {
//       controller.clear();
//     }
//     _focusNodes[0].requestFocus();
//   }

//   Future<void> _resendOtp() async {
//     if (!_canResend || _isResending) return;

//     setState(() {
//       _isResending = true;
//       _hasError = false;
//     });
    
//     try {
//       final result = await _authController.resendOtp(widget.mobile);
      
//       if (result['success'] == true) {
//         _showSuccessToast(result['message'] ?? 'OTP sent successfully!');
//         _clearOtp();
//         _startResendTimer(); // Restart the timer after successful resend
//       } else {
//         _showErrorToast(result['message'] ?? 'Failed to resend OTP');
//       }
//     } catch (e) {
//       _showErrorToast('Network error. Please try again.');
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isResending = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.black,
//               border: Border.all(color: Colors.black, width: 2),
//             ),
//           ),
//           const Positioned(
//             top: -100,
//             left: -100,
//             child: BlurredCircle(color: Color(0xFF2E2EFF)),
//           ),
//           const Positioned(
//             top: 100,
//             left: 200,
//             child: BlurredCircle(color: Color(0xFF2E2EFF)),
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               height: 615,
//               width: double.infinity,
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(40),
//                   topRight: Radius.circular(40),
//                 ),
//                 border: Border.all(color: Colors.black, width: 2),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 24),
//                   const Text(
//                     "OTP Verification",
//                     style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   const Center(
//                     child: CircleAvatar(
//                       radius: 50,
//                       backgroundImage: AssetImage("assets/profile_placeholder.jpg"),
//                     ),
//                   ),
//                   const SizedBox(height: 50),
//                   Align(
//                     alignment: Alignment.center,
//                     child: Text(
//                       "We have sent a verification code to your phone\nat ${widget.mobile ?? 'your registered number'}",
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(fontSize: 14, color: Colors.black54),
//                     ),
//                   ),
//                   const SizedBox(height: 50),
                  
//                   // OTP Input Fields
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(4, (index) {
//                       return Container(
//                         margin: const EdgeInsets.symmetric(horizontal: 8),
//                         height: 60,
//                         width: 55,
//                         decoration: BoxDecoration(
//                           color: _controllers[index].text.isNotEmpty
//                               ? const Color.fromARGB(255, 180, 217, 248)
//                               : Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: _hasError 
//                                 ? Colors.red 
//                                 : (_focusNodes[index].hasFocus 
//                                     ? const Color.fromARGB(255, 10, 32, 175)
//                                     : Colors.grey.shade300),
//                             width: _focusNodes[index].hasFocus || _hasError ? 2.5 : 1.5,
//                           ),
//                           boxShadow: _focusNodes[index].hasFocus
//                               ? [
//                                   BoxShadow(
//                                     color: const Color.fromARGB(255, 10, 32, 175).withOpacity(0.2),
//                                     blurRadius: 8,
//                                     spreadRadius: 1,
//                                   ),
//                                 ]
//                               : _hasError
//                                   ? [
//                                       BoxShadow(
//                                         color: Colors.red.withOpacity(0.2),
//                                         blurRadius: 8,
//                                         spreadRadius: 1,
//                                       ),
//                                     ]
//                                   : [],
//                         ),
//                         child: Center(
//                           child: TextField(
//                             controller: _controllers[index],
//                             focusNode: _focusNodes[index],
//                             keyboardType: TextInputType.number,
//                             textAlign: TextAlign.center,
//                             maxLength: 1,
//                             inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                             style: const TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 22,
//                             ),
//                             decoration: const InputDecoration(
//                               counterText: "",
//                               border: InputBorder.none,
//                               isCollapsed: true,
//                               contentPadding: EdgeInsets.zero,
//                             ),
//                             onChanged: (value) => _onOtpChanged(value, index),
//                             onTap: () {
//                               // Clear error state when user taps
//                               if (_hasError) {
//                                 setState(() {
//                                   _hasError = false;
//                                 });
//                               }
//                             },
//                             onEditingComplete: () {
//                               if (index < 3 && _controllers[index].text.isNotEmpty) {
//                                 _focusNodes[index + 1].requestFocus();
//                               }
//                             },
//                           ),
//                         ),
//                       );
//                     }),
//                   ),

//                   const SizedBox(height: 40),
                  
//                   // Resend OTP with Timer
//                   Align(
//                     alignment: Alignment.center,
//                     child: _canResend
//                         ? GestureDetector(
//                             onTap: _isResending ? null : _resendOtp,
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//                               decoration: BoxDecoration(
//                                 color: Colors.transparent,
//                                 borderRadius: BorderRadius.circular(10),
//                                 border: Border.all(
//                                   color: _isResending ? Colors.grey.shade300 : Colors.blue.shade400,
//                                   width: 1.5,
//                                 ),
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   if (_isResending)
//                                     SizedBox(
//                                       width: 18,
//                                       height: 18,
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 2,
//                                         color: Colors.blue.shade600,
//                                       ),
//                                     )
//                                   else
//                                     Icon(
//                                       Icons.refresh,
//                                       size: 20,
//                                       color: Colors.blue.shade600,
//                                     ),
//                                   const SizedBox(width: 10),
//                                   Text(
//                                     _isResending ? "Sending..." : "Resend OTP",
//                                     style: TextStyle(
//                                       fontSize: 15,
//                                       color: _isResending ? Colors.grey.shade600 : Colors.blue.shade600,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )
//                         : Container(
//                             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//                             decoration: BoxDecoration(
//                               color: Colors.grey.shade100,
//                               borderRadius: BorderRadius.circular(10),
//                               border: Border.all(
//                                 color: Colors.grey.shade300,
//                                 width: 1,
//                               ),
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(
//                                   Icons.timer_outlined,
//                                   size: 20,
//                                   color: Colors.grey.shade600,
//                                 ),
//                                 const SizedBox(width: 10),
//                                 Text(
//                                   "Resend in ${_formatTimer(_resendTimer)}",
//                                   style: TextStyle(
//                                     fontSize: 15,
//                                     color: Colors.grey.shade600,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                   ),

//                   const SizedBox(height: 50),
                  
//                   // Verify Button
//                   SizedBox(
//                     height: 50,
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: _isLoading ? null : _verifyOtp,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: isOtpComplete 
//                             ? const Color.fromARGB(255, 10, 32, 175)
//                             : Colors.grey.shade400,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: isOtpComplete ? 3 : 0,
//                         shadowColor: const Color.fromARGB(255, 10, 32, 175).withOpacity(0.3),
//                       ),
//                       child: _isLoading
//                           ? const SizedBox(
//                               height: 24,
//                               width: 24,
//                               child: CircularProgressIndicator(
//                                 color: Colors.white,
//                                 strokeWidth: 2.5,
//                               ),
//                             )
//                           : const Text(
//                               "Verify Account",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 16,
//                               ),
//                             ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }














import 'package:car_rental_staff_app/controllers/auth_controller.dart';
import 'package:car_rental_staff_app/providers/auth_provider.dart';
import 'package:car_rental_staff_app/views/main_layout.dart';
import 'package:car_rental_staff_app/widgect/blurred_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class OtpScreen extends StatefulWidget {
  final String? mobile; // Optional mobile number parameter
  
  const OtpScreen({super.key, this.mobile});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  
  final List<FocusNode> _focusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );

  final AuthController _authController = AuthController();
  bool _isLoading = false;
  bool _isResending = false;
  bool _hasError = false; // Track if there's an error for visual feedback
  
  // Timer related variables
  int _resendTimer = 30;
  bool _canResend = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Focus on first field initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
    // Start the resend timer
    _startResendTimer();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer to prevent memory leaks
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  String get otpCode {
    return _controllers.map((controller) => controller.text).join();
  }

  bool get isOtpComplete {
    return otpCode.length == 4 && otpCode.split('').every((char) => char.isNotEmpty);
  }

  void _onOtpChanged(String value, int index) {
    setState(() {
      _hasError = false; // Clear error state when user types
    });

    if (value.isNotEmpty) {
      // Move to next field
      if (index < 3) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last field, unfocus
        _focusNodes[index].unfocus();
      }
    } else {
      // Handle backspace - if current field becomes empty, move to previous field
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
        _controllers[index - 1].clear();
      }
    }

    // Auto-verify when OTP is complete
    if (isOtpComplete) {
      _verifyOtp();
    }
  }

  void _onBackspace(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      // Move to previous field and clear it
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
      setState(() {
        _hasError = false;
      });
    }
  }

  void _showErrorToast(String message) {
    setState(() {
      _hasError = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _showSuccessToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showInfoToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.info_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _startResendTimer() {
    setState(() {
      _resendTimer = 30;
      _canResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_resendTimer > 0) {
            _resendTimer--;
          } else {
            _canResend = true;
            timer.cancel();
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  String _formatTimer(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _verifyOtp() async {
    if (!isOtpComplete) {
      _showErrorToast('Please enter complete OTP');
      return;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final result = await _authController.verifyOtp(context, otpCode);
      
      if (result['success'] == true) {
        _showSuccessToast(result['message'] ?? 'OTP verified successfully!');
        
        // Navigate to main layout
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainLayout())
          );
        }
      } else {
        _showErrorToast(result['message'] ?? 'OTP verification failed');
        _clearOtp();
      }
    } catch (e) {
      _showErrorToast('An unexpected error occurred');
      _clearOtp();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _clearOtp() {
    for (var controller in _controllers) {
      controller.clear();
    }
    setState(() {
      _hasError = false;
    });
    _focusNodes[0].requestFocus();
  }

  Future<void> _resendOtp() async {
    if (!_canResend || _isResending) return;

    setState(() {
      _isResending = true;
      _hasError = false;
    });
    
    try {
      final result = await _authController.resendOtp(widget.mobile);
      
      if (result['success'] == true) {
        _showSuccessToast(result['message'] ?? 'OTP sent successfully!');
        _clearOtp();
        _startResendTimer(); // Restart the timer after successful resend
      } else {
        _showErrorToast(result['message'] ?? 'Failed to resend OTP');
      }
    } catch (e) {
      _showErrorToast('Network error. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  // Handle back button press
  Future<bool> _onWillPop() async {
    // Clear OTP fields when user presses back button
    _clearOtp();
    return true; // Allow the back navigation
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              _clearOtp(); // Clear OTP when back button is pressed
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.black, width: 2),
              ),
            ),
            const Positioned(
              top: -100,
              left: -100,
              child: BlurredCircle(color: Color(0xFF2E2EFF)),
            ),
            const Positioned(
              top: 100,
              left: 200,
              child: BlurredCircle(color: Color(0xFF2E2EFF)),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 615,
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    const Text(
                      "OTP Verification",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage("assets/profile_placeholder.jpg"),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "We have sent a verification code to your phone\nat ${widget.mobile ?? 'your registered number'}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ),
                    const SizedBox(height: 50),
                    
                    // OTP Input Fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          height: 60,
                          width: 55,
                          decoration: BoxDecoration(
                            color: _controllers[index].text.isNotEmpty
                                ? const Color.fromARGB(255, 180, 217, 248)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _hasError 
                                  ? Colors.red 
                                  : (_focusNodes[index].hasFocus 
                                      ? const Color.fromARGB(255, 10, 32, 175)
                                      : Colors.grey.shade300),
                              width: _focusNodes[index].hasFocus || _hasError ? 2.5 : 1.5,
                            ),
                            boxShadow: _focusNodes[index].hasFocus
                                ? [
                                    BoxShadow(
                                      color: const Color.fromARGB(255, 10, 32, 175).withOpacity(0.2),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : _hasError
                                    ? [
                                        BoxShadow(
                                          color: Colors.red.withOpacity(0.2),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                    : [],
                          ),
                          child: Center(
                            child: RawKeyboardListener(
                              focusNode: FocusNode(),
                              onKey: (RawKeyEvent event) {
                                if (event is RawKeyDownEvent) {
                                  if (event.logicalKey == LogicalKeyboardKey.backspace) {
                                    if (_controllers[index].text.isEmpty && index > 0) {
                                      // Move to previous field and clear it
                                      _controllers[index - 1].clear();
                                      _focusNodes[index - 1].requestFocus();
                                      setState(() {
                                        _hasError = false;
                                      });
                                    }
                                  }
                                }
                              },
                              child: TextField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                maxLength: 1,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                                decoration: const InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  isCollapsed: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onChanged: (value) => _onOtpChanged(value, index),
                                onTap: () {
                                  // Clear error state when user taps
                                  if (_hasError) {
                                    setState(() {
                                      _hasError = false;
                                    });
                                  }
                                },
                                onEditingComplete: () {
                                  if (index < 3 && _controllers[index].text.isNotEmpty) {
                                    _focusNodes[index + 1].requestFocus();
                                  }
                                },
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 40),
                    
                    // Resend OTP with Timer
                    Align(
                      alignment: Alignment.center,
                      child: _canResend
                          ? GestureDetector(
                              onTap: _isResending ? null : _resendOtp,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _isResending ? Colors.grey.shade300 : Colors.blue.shade400,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (_isResending)
                                      SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.blue.shade600,
                                        ),
                                      )
                                    else
                                      Icon(
                                        Icons.refresh,
                                        size: 20,
                                        color: Colors.blue.shade600,
                                      ),
                                    const SizedBox(width: 10),
                                    Text(
                                      _isResending ? "Sending..." : "Resend OTP",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: _isResending ? Colors.grey.shade600 : Colors.blue.shade600,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.timer_outlined,
                                    size: 20,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Resend in ${_formatTimer(_resendTimer)}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),

                    const SizedBox(height: 50),
                    
                    // Verify Button
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _verifyOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isOtpComplete 
                              ? const Color.fromARGB(255, 10, 32, 175)
                              : Colors.grey.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: isOtpComplete ? 3 : 0,
                          shadowColor: const Color.fromARGB(255, 10, 32, 175).withOpacity(0.3),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                "Verify Account",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}