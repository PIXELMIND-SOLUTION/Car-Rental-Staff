import 'package:car_rental_staff_app/views/all_bookings_screen.dart';
import 'package:car_rental_staff_app/views/booking_detail_screen.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class CarDetails extends StatefulWidget {
  const CarDetails({super.key});

  @override
  State<CarDetails> createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {
  // Add controller for OTP fields
  final List<TextEditingController> _otpControllers =
      List.generate(4, (index) => TextEditingController());

  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  // Flag to control OTP dialog visibility
  bool _showOtpDialog = false;

  @override
  void dispose() {
    // Dispose all controllers and focus nodes when widget is disposed
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: screenWidth * 0.06,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.25),
                      Text(
                        "Car Details",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 0, 0),
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Image.asset(
                  'assets/car_detail.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 263,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade300,
                    height: 200,
                    child: Icon(Icons.error, size: screenWidth * 0.1),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Car Images",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      const SizedBox(height: 20),

                      _buildImageUploadCard(),

                      SizedBox(
                        height: 20,
                      ),

                      // ID cards
                      _buildDocumentCard(
                        title: 'Aadhar Card',
                      ),

                      const SizedBox(height: 25),

                      _buildDocumentCard(
                        title: 'Aadhar card',
                      ),

                      SizedBox(
                        height: 25,
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Show OTP dialog when Proceed button is clicked
                            setState(() {
                              _showOtpDialog = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF120698),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Proceed',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          // OTP verification overlay with blur effect
          if (_showOtpDialog)
            BackdropFilter(
              filter:
                  ImageFilter.blur(sigmaX: 15, sigmaY: 15), // increased blur
              child: Container(
                color: Color(0XFFFFFF).withOpacity(0.2),
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: _buildOtpVerificationCard(context),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildOtpVerificationCard(BuildContext context) {
    return Container(
      width: 343,
      height: 345,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Pickup otp verification',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              4,
              (index) => _buildOtpTextField(index),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                _verifyOtp();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3182CE),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Verify',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpTextField(int index) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 2,
          ),
        ],
      ),
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            _focusNodes[index + 1].requestFocus();
          }
        },
      ),
    );
  }

  void _verifyOtp() {
    // Get OTP from controllers
    String otp = _otpControllers.map((controller) => controller.text).join();
    
    // Check if OTP is valid (example: 4 digits)
    if (otp.length == 4 && otp == '1234') {
      Navigator.push(context,MaterialPageRoute(builder: (context)=>AllBookingsScreen()));
      setState(() {
        _showOtpDialog = false;
      });
      
      // Additional logic after verification (e.g., navigate to next screen)
      // Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid OTP')),
      );
    }
  }
  Widget _buildDocumentCard({
    required String title,
  }) {
    return Container(
      height: 206,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: AssetImage('assets/adhar.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Gradient overlay at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 60,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageUploadCard() {
    return Container(
      height: 206,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: AssetImage('assets/car_upload.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Light black overlay on top of the image
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black.withOpacity(0.7),
            ),
          ),

          // Center icon
          Center(
            child: _buildImageOption(icon: Icons.camera_alt),
          ),

          // Bottom gradient (optional)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 60,
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(12)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.4),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageOption({
    required IconData icon,
  }) {
    return GestureDetector(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 65,
              height: 57,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Icon(icon,
                  color: const Color.fromARGB(255, 0, 0, 0), size: 36)),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
