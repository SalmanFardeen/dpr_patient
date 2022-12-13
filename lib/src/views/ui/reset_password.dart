import 'package:dpr_patient/src/business_logics/providers/reset_password_provider.dart';
import 'package:dpr_patient/src/views/ui/authenticate.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:dpr_patient/src/views/utils/validators.dart';
import 'package:dpr_patient/src/views/widgets/shadow_container.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({ Key? key }) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool _passwordVisible = false;
  final _passwordETController = TextEditingController();
  final _confirmPasswordETController = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var resetPasswordProvider = Provider.of<ResetPasswordProvider>(context);
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: kWhiteColor,
        elevation: 0,
        title: const Text("Reset Password", style: kAppBarBlueTitleTextStyle),
        shadowColor: Colors.transparent,
      ),
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
                      "assets/images/forgot_password_otp_bg.png",
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                      "New Password",
                      style: kTitleTextStyle,
                    ),
                  const SizedBox(height: 8.0),
                  ShadowContainer(
                    radius: 8.0,
                    child: WidgetFactory.buildPasswordField(
                      context: context,
                      textInputAction: TextInputAction.next,
                      validator: validator.passwordValidator,
                      obscurePassword: !_passwordVisible,
                      label: "",
                      hint: "******",
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(
                                    () => _passwordVisible = !_passwordVisible);
                          },
                          icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: kDarkGreyColor)),
                      backgroundColor: kWhiteColor,
                      textColor: Colors.black,
                      borderRadius: 8.0,
                      borderColor: kDarkGreyColor,
                      controller: _passwordETController,
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "Confirm New Password",
                    style: kTitleTextStyle,
                  ),
                  const SizedBox(height: 8.0),
                  ShadowContainer(
                    radius: 8.0,
                    child: WidgetFactory.buildPasswordField(
                      context: context,
                      textInputAction: TextInputAction.done,
                      validator: validator.passwordValidator,
                      obscurePassword: !_passwordVisible,
                      label: "",
                      hint: "******",
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(
                                    () => _passwordVisible = !_passwordVisible);
                          },
                          icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: kDarkGreyColor)),
                      backgroundColor: kWhiteColor,
                      textColor: Colors.black,
                      borderRadius: 8.0,
                      borderColor: kDarkGreyColor,
                      controller: _confirmPasswordETController,
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(height: 32),
                  resetPasswordProvider.inProgress
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
                        final password = _passwordETController.text.toString();
                        final confirmPassword = _confirmPasswordETController.text.toString();
                        if(password != confirmPassword) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Passwords not matched"),
                                duration: Duration(seconds: 1),
                              )
                          );
                          return;
                        }
                        final _responseResult = await resetPasswordProvider.resetPassword(password);
                        if (_responseResult) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (
                                      context) => const Authenticate()),
                                  (Route<dynamic> route) => false
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    resetPasswordProvider.errorResponse
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
    _passwordETController.dispose();
    _confirmPasswordETController.dispose();
    super.dispose();
  }
}