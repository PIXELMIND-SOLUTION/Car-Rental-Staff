import 'package:car_rental_staff_app/widgect/blurred_circle.dart';
import 'package:flutter/material.dart';


class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                      backgroundImage: NetworkImage("https://s3-alpha-sig.figma.com/img/f641/434d/9033e72f032ba28554095623174e2a9c?Expires=1745798400&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=sr3Bud6yNkgJYs-gs5jD1HRHD25r~LUoM70HmBUk9RuUI4-MDOfCvA5XJrC6UZ2UwyMJhiwFwSyLBi7x4IIys16qV51DalqhOtMIEfyLXFTq6qT1hlplb41QO5lzzfNgXhCK0RJGtO9-rgox4KIGm8CFrywqQcf4jLypNUpbMPeojqcPbrW8jya7NaJPruD1nKYwsJpYNiWgkohTYIQ7nbuosa7UwsBCZ6LWj-k4llvycvCNRE10wcbq3oUupzjDew12Vs8GCfBIH8Z7uoyr2WF4ErSjsPg75SuGI~ibs6Xu3yJUtWeuisMuWtTYPoemRUmS8Yfv1J-mmUu5fMhwCg__"),
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "We have sent a verification code to your phone\nat 123456789",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),

                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return Container(
  margin: const EdgeInsets.symmetric(horizontal: 8),
  height: 40,
  width: 40,
  decoration: BoxDecoration(
    color: index == 0
        ? const Color.fromARGB(255, 180, 217, 248)
        : const Color.fromARGB(0, 255, 255, 255),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.black, width: 2),
  ),
  child: Center(
    child: TextField(
      controller: _controllers[index]
        ..text = index == 0 ? "6" : _controllers[index].text,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center, // center the input inside
      maxLength: 1,
      style: TextStyle(
        color: index == 0
            ? const Color.fromARGB(255, 0, 0, 0)
            : Colors.black,
        fontWeight: FontWeight.bold,
      ),
      decoration: const InputDecoration(
        counterText: "",
        border: InputBorder.none,
        isCollapsed: true, // removes default padding
        contentPadding: EdgeInsets.zero, // make sure it sits dead center
      ),
      readOnly: index == 0,
    ),
  ),
);

                    }),
                  ),

                  const SizedBox(height: 32),
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                        children: [
                          TextSpan(text: "Don't Receive code? "),
                          TextSpan(
                            text: "Resend",
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),
                  SizedBox(
                    height: 46,
                    width: 350,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (ctx) => const SignupScreen()),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 10, 32, 175),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Verify Account",
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
