import 'package:dpr_patient/src/business_logics/providers/signup_otp_provider.dart';
import 'package:dpr_patient/src/business_logics/utils/log_debugger.dart';
import 'package:dpr_patient/src/views/ui/authenticate.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:dpr_patient/src/views/widgets/scaffold_message.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';

class SignupVerifyOTP extends StatefulWidget {
  final String phone;

  const SignupVerifyOTP({Key? key, required this.phone}) : super(key: key);

  @override
  _SignupVerifyOTPState createState() => _SignupVerifyOTPState();
}

class _SignupVerifyOTPState extends State<SignupVerifyOTP> {
  String _code = "";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var signupOTPProvider = Provider.of<SignupOtpProvider>(context);
    return Scaffold(
      backgroundColor: kWhiteColor,
        // appBar: AppBar(
        //   iconTheme: const IconThemeData(
        //     color: Colors.black, //change your color here
        //   ),
        //   backgroundColor: kWhiteColor,
        //   elevation: 0,
        //   title: const Text("Verify OTP", style: kAppBarBlueTitleTextStyle),
        //   shadowColor: Colors.transparent,
        // ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 150,
                    width: size.width,
                    child: Image.asset(
                      "assets/images/verify_otp_bg.png",
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                      "Enter your verification code sent to ${widget.phone}. If you haven't receive yet, please wait.",
                      style: const TextStyle(
                          fontSize: 16,
                          letterSpacing: 0.4,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 32),
                  OTPTextField(
                    length: 4,
                    width: MediaQuery.of(context).size.width,
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldWidth: 55,
                    fieldStyle: FieldStyle.underline,
                    style: const TextStyle(fontSize: 17),
                    onChanged: (pin) {
                      _code = pin;
                      LogDebugger.instance.i("Changed: " + pin);
                    },
                    onCompleted: (pin) {
                      LogDebugger.instance.i("Completed: " + pin);
                    },
                  ),
                  const SizedBox(height: 16),
                  Center(
                      child: WidgetFactory.buildRichText(
                    context: context,
                    text1: 'Didn\'t receive code? ',
                    text2: 'Request again',
                    text1Color: kBlackColor,
                    text2Color: kBlackColor,
                    onTap: () {},
                  )),
                  const SizedBox(height: 32),
                  signupOTPProvider.inProgress
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: kOrangeColor,
                        ))
                      : WidgetFactory.buildButton(
                          context: context,
                          child: const Text("VERIFY", style: kButtonTextStyle),
                          backgroundColor: kVioletColor,
                          borderRadius: 8.0,
                          onPressed: _code.length != 4
                              ? () {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Enter a valid code"),
                                    duration: Duration(seconds: 1),
                                  ));
                                }
                              : () async {
                                  if (_code.isNotEmpty) {
                                    final _responseResult =
                                        await signupOTPProvider.signupVerifyOTP(
                                            widget.phone, _code);
                                    if (_responseResult) {
                                      Navigator.pop(context);
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  const Authenticate()),
                                              (Route<dynamic> route) => false);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(signupOTPProvider
                                                .errorResponse.message ??
                                            "Network error"),
                                        duration: const Duration(seconds: 1),
                                      ));
                                    }
                                  } else {
                                    showScaffoldMessage(context, 'Enter code');
                                  }
                                },
                        ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ));
  }
}
