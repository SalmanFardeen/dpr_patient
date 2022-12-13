import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PaymentMethodSettings extends StatelessWidget {
  const PaymentMethodSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: kWhiteColor,
        elevation: 0,
          title: const Text("Select Payment Method",
              style: kAppBarBlueTitleTextStyle),
          shadowColor: Colors.transparent),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PaymentListTile(
                  name: "Credit Card",
                  icon: const Icon(
                    FontAwesomeIcons.creditCard,
                    size: 34,
                    color: kWhiteColor,
                  ),
                  onTap: () {},
                  backgroundColor: kDeepBlueColor,
                  fontColor: kWhiteColor,
                  arrowColor: kWhiteColor,
                ),
                const SizedBox(
                  height: 10,
                ),
                PaymentListTile(
                  name: "Master Card",
                  icon: const Icon(
                    FontAwesomeIcons.ccMastercard,
                    size: 34,
                    color: kDeepBlueColor,
                  ),
                  onTap: () {},
                  backgroundColor: kWhiteColor,
                  fontColor: kDeepBlueColor,
                  arrowColor: kDeepBlueColor,
                ),
                const SizedBox(
                  height: 10,
                ),
                PaymentListTile(
                  name: "Google pay",
                  icon: const Icon(
                    FontAwesomeIcons.googlePay,
                    size: 34,
                    color: kDeepBlueColor,
                  ),
                  onTap: () {},
                  backgroundColor: kWhiteColor,
                  fontColor: kDeepBlueColor,
                  arrowColor: kDeepBlueColor,
                ),
                const SizedBox(
                  height: 10,
                ),
                PaymentListTile(
                  name: "bKash",
                  icon: IconButton(
                    icon: Image.asset("assets/images/icon_bkash.png"),
                    onPressed: () {},
                  ),
                  onTap: () {},
                  backgroundColor: kWhiteColor,
                  fontColor: kDeepBlueColor,
                  arrowColor: kDeepBlueColor,
                ),
                Container(
                  height: 300,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.scaleDown,
                      image: AssetImage(
                        "assets/images/payment-bg.png",
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PaymentListTile extends StatelessWidget {
  const PaymentListTile({
    Key? key,
    required this.name,
    required this.icon,
    required this.onTap,
    required this.backgroundColor,
    required this.fontColor,
    required this.arrowColor,
  }) : super(key: key);

  final String name;
  final Widget icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color fontColor;
  final Color arrowColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      height: 72,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 2), //
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: icon,
        title: Text(
          name,
          style: TextStyle(
              fontSize: 21.0, fontWeight: FontWeight.w600, color: fontColor),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded, color: arrowColor),
      ),
    );
  }
}
