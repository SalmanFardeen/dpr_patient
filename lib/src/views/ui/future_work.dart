import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:flutter/material.dart';

class FutureWork extends StatelessWidget {
  const FutureWork({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: kWhiteColor,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0,
      ),
      body: const Center(
        child: Text("For future work"),
      ),
    );
  }
}
