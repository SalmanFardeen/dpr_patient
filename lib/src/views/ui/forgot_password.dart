import 'package:dpr_patient/src/business_logics/providers/forgot_password_provider.dart';
import 'package:dpr_patient/src/views/ui/forgot_password__verify_otp.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:dpr_patient/src/views/utils/validators.dart';
import 'package:dpr_patient/src/views/widgets/shadow_container.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({ Key? key }) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _phoneNumberETController = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var forgotPasswordProvider = Provider.of<ForgotPasswordProvider>(context);
    return Scaffold(
      backgroundColor: kWhiteColor,
      // appBar: AppBar(
      //   iconTheme: const IconThemeData(
      //     color: Colors.black, //change your color here
      //   ),
      //   backgroundColor: kWhiteColor,
      //   elevation: 0,
      //   title: const Text("Forgot Password", style: kAppBarBlueTitleTextStyle),
      //   shadowColor: Colors.transparent,
      // ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 150,
                    width: size.width,
                    child: Image.asset(
                      "assets/images/forgot_password_bg.png",
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Center(
                    child: Text(
                        "Enter your phone number\n associated with your account",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  const Text(
                      "Phone Number",
                      style: kTitleTextStyle,
                    ),
                  const SizedBox(height: 8.0),
                  ShadowContainer(
                   radius: 8.0,
                    child: WidgetFactory.buildTextField(
                      context: context,
                      validator: validator.phoneNoValidator,
                      label: "",
                      hint: "01XXXXXXXXX",
                      borderRadius: 8.0,
                      borderColor: kDarkGreyColor,
                      textInputType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      controller: _phoneNumberETController,
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Center(
                    child: Text(
                        "We will send a verification code to\n reset your password",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w200,
                        ),
                        textAlign: TextAlign.center
                    ),
                  ),
                  const SizedBox(height: 32),
                  forgotPasswordProvider.inProgress
                      ? const Center(
                      child: CircularProgressIndicator(
                        color: kOrangeColor,
                      )
                  )
                  : WidgetFactory.buildButton(
                    context: context,
                    child: const Text("SEND", style: kButtonTextStyle),
                    backgroundColor: kVioletColor,
                    borderRadius: 8.0,
                    onPressed: () async {
                      if (_form.currentState!.validate()) {
                        final phone = _phoneNumberETController.text.toString();
                        final _responseResult = await forgotPasswordProvider
                            .requestCode(phone);
                        if (_responseResult) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (
                                      context) => ForgotPasswordVerifyOTP(phone: phone))
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    forgotPasswordProvider.errorResponse
                                        .message ?? "Network error"),
                                duration: const Duration(seconds: 1),
                              )
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

  @override
  void dispose() {
    _phoneNumberETController.dispose();
    super.dispose();
  }
}