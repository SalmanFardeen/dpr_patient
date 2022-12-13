import 'package:dpr_patient/src/business_logics/providers/signup_provider.dart';
import 'package:dpr_patient/src/views/ui/login.dart';
import 'package:dpr_patient/src/views/ui/signup_verify_otp.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:dpr_patient/src/views/utils/validators.dart';
import 'package:dpr_patient/src/views/widgets/shadow_container.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _isAccepted = false;
  bool _passwordVisible = false;
  final _firstNameETController = TextEditingController();
  final _lastNameETController = TextEditingController();
  final _phoneNumberETController = TextEditingController();
  final _passwordETController = TextEditingController();
  final _form = GlobalKey<FormState>();

  bool _show = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final signupProvider = Provider.of<SignupProvider>(context);
    return Scaffold(
      backgroundColor: kLightGreyColor,
      // appBar: AppBar(
      //   iconTheme: const IconThemeData(
      //     color: Colors.black, //change your color here
      //   ),
      //   backgroundColor: kWhiteColor,
      //   elevation: 0,
      //   title: const Text("Sign up", style: kAppBarBlueTitleTextStyle),
      //   shadowColor: Colors.transparent,
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 32.0,
                color: kWhiteColor,
              ),
              Container(
                color: kWhiteColor,
                height: 150,
                width: size.width,
                child: Image.asset(
                  "assets/images/signup_bg.png",
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                width: size.width,
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
                      "Sign Up",
                      style: TextStyle(
                          color: kBlackColor,
                          fontSize: 24,
                          letterSpacing: 0.4,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Container(
                width: size.width,
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "First Name",
                                  style: kTitleTextStyle,
                                ),
                                const SizedBox(height: 8.0),
                                ShadowContainer(
                                  radius: 8.0,
                                  child: WidgetFactory.buildTextField(
                                    context: context,
                                    label: "",
                                    hint: "First Name",
                                    borderRadius: 8.0,
                                    borderColor: kDarkGreyColor,
                                    validator: validator.nameValidator,
                                    textInputType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    controller: _firstNameETController,
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Last Name",
                                  style: kTitleTextStyle,
                                ),
                                const SizedBox(height: 8.0),
                                ShadowContainer(
                                  radius: 8.0,
                                  child: WidgetFactory.buildTextField(
                                    context: context,
                                    label: "",
                                    hint: "Last Name",
                                    borderRadius: 8.0,
                                    borderColor: kDarkGreyColor,
                                    validator: validator.nameValidator,
                                    textInputType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    controller: _lastNameETController,
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Phone Number",
                        style: kTitleTextStyle,
                      ),
                      const SizedBox(height: 8.0),
                      ShadowContainer(
                        radius: 8.0,
                        child: WidgetFactory.buildTextField(
                          context: context,
                          label: "",
                          hint: "01XXXXXXXXX",
                          borderRadius: 8.0,
                          borderColor: kDarkGreyColor,
                          validator: validator.phoneNoValidator,
                          textInputType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          controller: _phoneNumberETController,
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Password",
                        style: kTitleTextStyle,
                      ),
                      const SizedBox(height: 8),
                      ShadowContainer(
                        radius: 8.0,
                        child: WidgetFactory.buildPasswordField(
                          context: context,
                          textInputAction: TextInputAction.done,
                          validator: validator.passwordValidator,
                          obscurePassword: !_passwordVisible,
                          label: "",
                          hint: "Must be at least 6 characters",
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() => _passwordVisible = !_passwordVisible);
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
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Checkbox(
                            value: _isAccepted,
                            onChanged: (bool? value) {
                              setState(() {
                                _isAccepted = value ?? false;
                                if(!_isAccepted) {
                                  _show = false;
                                }
                              });
                            },
                          ),
                          Center(
                              child: WidgetFactory.buildRichText(
                            context: context,
                            text1: 'I accept the ',
                            text2: 'terms and conditions',
                            text1Color: kBlackColor,
                            text2Color: kDeepBlueColor,
                            onTap: () {},
                          )),
                        ],
                      ),
                      const SizedBox(height: 4),
                      if(_show && !_isAccepted)
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text('Please Accept Terms And Conditions', style: TextStyle(color: kRedColor, fontSize: 10),),
                      ),
                      const SizedBox(height: 16),
                      signupProvider.inProgress
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: kOrangeColor,
                          )
                      )
                      : WidgetFactory.buildButton(
                        context: context,
                        child: const Text("SIGN UP", style: kButtonTextStyle),
                        backgroundColor: kVioletColor,
                        borderRadius: 8.0,
                        onPressed: () async {
                          setState(() {
                            _show = true;
                          });
                            if (_form.currentState!.validate()) {
                              if(!_isAccepted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Please accept terms and condition to proceed"),
                                      duration: Duration(seconds: 1),
                                    ));
                                return;
                              }
                              String firstName = _firstNameETController.text
                                  .toString();
                              String lastName = _lastNameETController.text
                                  .toString();
                              String phone = _phoneNumberETController.text
                                  .toString();
                              String password = _passwordETController.text
                                  .toString();
                              final _responseResult = await signupProvider
                                  .signUp(firstName, lastName, phone, password);
                              if (_responseResult) {
                                setState(() {
                                  _show = false;
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            SignupVerifyOTP(
                                                phone: phone)));
                              } else {
                                setState(() {
                                  _show = true;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(signupProvider.errorResponse
                                          .errors?.first.status ?? "Network error"),
                                      duration: const Duration(seconds: 1),
                                    ));
                              }
                            }
                          },
                      ),
                      const SizedBox(height: 16),
                      signupProvider.inProgress
                          ? Container()
                      : Center(
                          child: WidgetFactory.buildRichText(
                              context: context,
                              text1: 'Already have an account? ',
                              text2: 'Login',
                              text1Color: kBlackColor,
                              text2Color: kDeepBlueColor,
                              onTap: () => Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                      const Login()),
                                      (Route<dynamic> route) => false),
                          )
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      )
    );
  }

  @override
  void dispose() {
    _firstNameETController.dispose();
    _lastNameETController.dispose();
    _phoneNumberETController.dispose();
    _passwordETController.dispose();
    super.dispose();
  }
}
