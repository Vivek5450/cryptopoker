import 'package:cryptopoker/controller/auth_controller.dart';
import 'package:cryptopoker/progress_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({super.key});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🎴 Background image
          Image.asset('assets/images/bg.png', fit: BoxFit.cover),

          // ✅ Centered scrollable layout
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/Logo.png', height: 90),
                        const SizedBox(height: 40),

                        const Text(
                          'Verify Your Email',
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                        const Text(
                          'We\'ve have sent a 6-digit code to your email.',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        const SizedBox(height: 30),

                        Wrap(
                          alignment: WrapAlignment.center,
                          runAlignment: WrapAlignment.center,
                          children: [
                            OtpTextField(
                              alignment: Alignment.center,
                              numberOfFields: 6,
                              showFieldAsBox: true,
                              borderColor: Color.fromARGB(255, 190, 37, 35),
                              focusedBorderColor: Color.fromARGB(
                                255,
                                190,
                                37,
                                35,
                              ),
                              enabledBorderColor: Color.fromARGB(
                                255,
                                190,
                                37,
                                35,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              fieldWidth: 45,
                              fieldHeight: 45,
                              mainAxisAlignment: MainAxisAlignment.center,
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                height: 0.7, // centers text vertically
                              ),
                              onCodeChanged: (String code) {},
                              onSubmit: (String verificationCode) {
                                // handle OTP submit if needed
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 90),
                        _buildButton('Verify OTP', () {}, true),
                        const SizedBox(height: 10),
                        _buildButton('Resend Code', () {}, false),
                        const SizedBox(height: 40),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Don\'t get it? check spam folder',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onTap, bool isResend) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient:
                isResend
                    ? LinearGradient(
                      colors: [
                        const Color.fromARGB(
                          255,
                          190,
                          37,
                          35,
                        ), // light red (top)
                        const Color.fromARGB(255, 144, 20, 22),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )
                    : null,
            color: isResend ? null : const Color.fromARGB(255, 26, 26, 26),
            borderRadius: BorderRadius.circular(15),
            border: isResend ? null : Border.all(color: Colors.white),
          ),

          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
