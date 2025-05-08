
import 'package:car_rental_staff_app/controllers/auth_controller.dart';
import 'package:car_rental_staff_app/views/home_screen.dart';
import 'package:car_rental_staff_app/views/main_layout.dart';
import 'package:car_rental_staff_app/widgect/blurred_circle.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mobileController = TextEditingController();

  final AuthController _authController = AuthController();

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: const Stack(
              children: [
                Positioned(
                  top: -100,
                  left: -100,
                  child: BlurredCircle(color: Color(0xFF2E2EFF)),
                ),
                Positioned(
                  top: 100,
                  left: 200,
                  child: BlurredCircle(color: Color(0xFF2E2EFF)),
                ),
              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: height * 0.75, 
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.06,
                vertical: height * 0.04,
              ),
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
                  SizedBox(height: height * 0.02),
                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: height * 0.01),
                  const Text(
                    "Our app is waiting for Campaign your ideas",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  SizedBox(height: height * 0.05),
                  TextField(
                    keyboardType: TextInputType.phone,
                    controller: _mobileController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      hintText: "9898989898",
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: height * 0.08),
                  SizedBox(
                    height: 46,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final mobile = _mobileController.text.trim();
                        if (mobile.isEmpty) return;

                        final isSuccess =
                            await _authController.loginUser(context, mobile);
                        // if (isSuccess) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => const MainLayout()));
                        // } else {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(content: Text("Login Failed")),
                        //   );
                        // }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 10, 32, 175),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
