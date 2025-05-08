import 'dart:ui';
import 'package:car_rental_staff_app/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReturnUploadScreen extends StatefulWidget {
  final String id;

  const ReturnUploadScreen({
    super.key,
    required this.id,
  });

  @override
  State<ReturnUploadScreen> createState() => _ReturnUploadScreenState();
}

class _ReturnUploadScreenState extends State<ReturnUploadScreen> {
    final List<TextEditingController> _otpControllers =
      List.generate(4, (index) => TextEditingController());
  bool showOtpOverlay = false;

  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());


  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _showOtpVerification() {
    setState(() {
      showOtpOverlay = true;
    });
  }

  void _verifyOtp() {
    String otp = _otpControllers.map((controller) => controller.text).join();
    print("llllllllllllllllllllll$otp");
    
    // Check if OTP is valid (example: 4 digits)
    if (otp.length == 4 && otp == '1234') {
      Navigator.push(context,MaterialPageRoute(builder: (context)=>HomeScreen()));
      setState(() {
        showOtpOverlay = false;
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main Content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          "id: #1234",
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
                    height: 30,
                  ),
                  Card(
                    elevation: 1,
                    color: const Color(0XFFFFFFFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'TS 05 TD 4544',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Hyundai Verna',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Automatic & Seaters Row
                          Row(
                            children: [
                              const Icon(Icons.settings,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              const Text(
                                'Automatic',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Row(
                                children: const [
                                  Icon(Icons.airline_seat_recline_normal,
                                      size: 16, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Text(
                                    '5 Seaters',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Date & Time Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              Icon(Icons.calendar_today,
                                  size: 16, color: Colors.blue),
                              SizedBox(width: 4),
                              Text(
                                '23-03-2025',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(width: 16),
                              Icon(Icons.access_time,
                                  size: 16, color: Colors.blue),
                              SizedBox(width: 4),
                              Text(
                                '11:00 AM',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 30),
                  const SizedBox(height: 10),
                  const Text(
                    'Pickup Photos',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Security deposit section
                  const Text(
                    'Return Upload',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: List.generate(
                      4,
                      (index) => _buildDocumentCard(
                        title: 'Aadhar card',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  const SizedBox(height: 20),

                  // Scan/Upload container
                  Container(
                    width: double.infinity,
                    height: 150,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B1B3D),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildImageOption(
                            icon: Icons.camera_alt,
                            title: 'Scan',
                            subtitle: 'Bike Front & Back',
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildImageOption(
                            icon: Icons.file_upload_outlined,
                            title: 'Upload',
                            subtitle: 'Bike Front & Back',
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ID cards
                  _buildDocumentCard(
                    title: 'Aadhar Card',
                  ),

                  const SizedBox(height: 25),

                  _buildDocumentCard(
                    title: 'Aadhar card',
                  ),

                  SizedBox(height: 25),

                  // Next button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _showOtpVerification,
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
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // OTP Verification Overlay
          if (showOtpOverlay)
            buildOtpVerificationDialog(
                context, _otpControllers, _focusNodes, _verifyOtp)
        ],
      ),
    );
  }

  Widget buildOtpVerificationDialog(
      BuildContext context,
      List<TextEditingController> otpControllers,
      List<FocusNode> otpFocusNodes,
      VoidCallback onVerify) {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(
            sigmaX: 10, sigmaY: 10), // increased blur for softer effect
        child: Container(
          color: Colors.black.withOpacity(0.3), // slightly darker shade
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15), // glass effect
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 25, // stronger blur on shadow
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Return otp verification',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          4,
                          (index) => Container(
                            width: 50,
                            height: 50,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: TextField(
                                controller: _otpControllers[index],
                                focusNode: _focusNodes[index],
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) {
                                  if (value.isNotEmpty && index < 3) {
                                    otpFocusNodes[index].unfocus();
                                    FocusScope.of(context)
                                        .requestFocus(otpFocusNodes[index + 1]);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: onVerify,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ).copyWith(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                return Colors.transparent;
                              },
                            ),
                            shadowColor:
                                MaterialStateProperty.all(Colors.transparent),
                            elevation: MaterialStateProperty.all(0),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF003082), Color(0xFF0071BC)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              child: const Text(
                                'Verify',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required String label,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border(
            bottom:
                BorderSide(color: const Color.fromARGB(255, 162, 162, 162))),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: label,
                hintStyle: TextStyle(color: Colors.grey.shade500),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard({
    required String title,
  }) {
    return Container(
      width: double.infinity,
      height: 206,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: AssetImage('assets/adhar.png'), // your background image
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
}
