import 'package:dpr_patient/src/business_logics/providers/login_provider.dart';
import 'package:dpr_patient/src/views/ui/authenticate.dart';
import 'package:dpr_patient/src/views/ui/forgot_password.dart';
import 'package:dpr_patient/src/views/ui/signup.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:dpr_patient/src/views/utils/validators.dart';
import 'package:dpr_patient/src/views/widgets/shadow_container.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _passwordVisible = false, _show = false;
  final _phoneNumberETController = TextEditingController();
  final _passwordETController = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var loginProvider = Provider.of<LoginProvider>(context);
    return Scaffold(
      backgroundColor: kLightGreyColor,
      // appBar: AppBar(
      //   iconTheme: const IconThemeData(
      //     color: Colors.black, //change your color here
      //   ),
      //   backgroundColor: kWhiteColor,
      //   elevation: 0,
      //   title: const Text("Login", style: kAppBarBlueTitleTextStyle),
      //   shadowColor: Colors.transparent,
      // ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
                color: kWhiteColor,
                height: 200,
                width: size.width,
                child: Image.asset(
                  "assets/images/login_bg.png",
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                color: kWhiteColor,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: kLightGreyColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.0),
                        topRight: Radius.circular(24.0)),
                  ),
                  child: const Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: kBlackColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16.0),
                      const Text(
                        "Phone Number",
                        style: kTitleTextStyle,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 8.0),
                      ShadowContainer(
                        radius: 8,
                        child: WidgetFactory.buildTextField(
                          context: context,
                          validator: validator.phoneNoValidator,
                          label: "",
                          hint: "01XXXXXXXX",
                          textInputType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          borderRadius: 8.0,
                          borderColor: kDarkGreyColor,
                          controller: _phoneNumberETController,
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Password",
                        style: kTitleTextStyle,
                        textAlign: TextAlign.start,
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
                          controller: _passwordETController,
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_show)
                        const Text(
                          "Wrong Credential",
                          style: TextStyle(color: kRedColor),
                        ),
                  const SizedBox(height: 12),
                      SizedBox(
                        width: size.width,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPassword()));
                          },
                          child: loginProvider.inProgress
                          ? Container()
                          : const Text(
                            "Forgot Password?",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: kBlackColor,
                                letterSpacing: 0.4),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      loginProvider.inProgress
                          ? const Center(
                          child: CircularProgressIndicator(
                            color: kOrangeColor,
                          )
                      )
                      : WidgetFactory.buildButton(
                          context: context,
                          child: const Text("LOGIN", style: kButtonTextStyle),
                          backgroundColor: kVioletColor,
                          borderRadius: 16.0,
                          onPressed: () async {
                            setState(() {
                              _show = false;
                            });
                            if (_form.currentState!.validate()) {
                              final phone = _phoneNumberETController.text.toString();
                              final password = _passwordETController.text.toString();
                              final _responseResult = await loginProvider.login(phone, password);
                              if (_responseResult) {
                                setState(() {
                                  _show = false;
                                });
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Authenticate()),
                                        (Route<dynamic> route) => false
                                );
                              } else {
                                setState(() {
                                  _show = true;
                                });
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //     SnackBar(
                                //       content: Text(loginProvider.errorResponse
                                //           .message ?? "Network error"),
                                //       duration: const Duration(seconds: 1),
                                //     ));
                              }
                              // navigate to home/dashboard
                            }
                          }),
                      const SizedBox(height: 16),
                      loginProvider.inProgress
                      ? Container()
                      : Center(
                        child: WidgetFactory.buildRichText(
                          context: context,
                          text1: 'Don\'t have an account? ',
                          text2: 'Sign Up',
                          text1Color: kBlackColor,
                          text2Color: kDeepBlueColor,
                          onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const Signup()),
                                  (Route<dynamic> route) => false
                          );
                          },
                        )
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          )
        )
      ),
    );
  }

  @override
  void dispose() {
    _phoneNumberETController.dispose();
    _passwordETController.dispose();
    super.dispose();
  }
}
