import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:flutter/material.dart';
class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0,
        backgroundColor: kWhiteColor,
        title: const Text('Terms & Conditions', style: kAppBarBlueTitleTextStyle),
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: const [
              Text('''Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Massa ultricies mi quis hendrerit dolor magna eget est. Id neque aliquam vestibulum morbi blandit cursus. Ullamcorper velit sed ullamcorper morbi tincidunt ornare massa eget egestas. Phasellus vestibulum lorem sed risus ultricies tristique nulla aliquet. Volutpat diam ut venenatis tellus in metus vulputate eu. Et netus et malesuada fames ac turpis. Sed libero enim sed faucibus turpis in eu mi. Suspendisse interdum consectetur libero id faucibus. In vitae turpis massa sed elementum. Morbi tristique senectus et netus. Enim eu turpis egestas pretium aenean. Sit amet purus gravida quis blandit turpis cursus in hac. Parturient montes nascetur ridiculus mus mauris vitae ultricies leo. Diam maecenas ultricies mi eget mauris. Scelerisque fermentum dui faucibus in.

Purus semper eget duis at tellus. Etiam non quam lacus suspendisse faucibus interdum posuere lorem. Habitasse platea dictumst quisque sagittis purus sit amet. Urna nunc id cursus metus aliquam eleifend mi in nulla. Non quam lacus suspendisse faucibus interdum posuere lorem. Est pellentesque elit ullamcorper dignissim cras tincidunt. Et netus et malesuada fames ac turpis egestas. Viverra vitae congue eu consequat ac. Tellus pellentesque eu tincidunt tortor aliquam. Gravida cum sociis natoque penatibus et magnis dis parturient.

Id semper risus in hendrerit gravida rutrum quisque. Vitae justo eget magna fermentum iaculis eu. Pretium viverra suspendisse potenti nullam ac. Odio facilisis mauris sit amet massa vitae tortor condimentum lacinia. Justo eget magna fermentum iaculis eu non diam. Ullamcorper sit amet risus nullam eget felis eget. Dignissim convallis aenean et tortor at risus viverra adipiscing at. Volutpat commodo sed egestas egestas fringilla phasellus faucibus. Libero nunc consequat interdum varius sit. Aliquet eget sit amet tellus cras adipiscing enim eu. Diam ut venenatis tellus in metus vulputate. At in tellus integer feugiat scelerisque varius. Nulla facilisi cras fermentum odio eu feugiat pretium. Consequat interdum varius sit amet mattis vulputate. Tristique sollicitudin nibh sit amet commodo nulla facilisi.

Quis blandit turpis cursus in hac habitasse platea. Ligula ullamcorper malesuada proin libero nunc. Maecenas ultricies mi eget mauris pharetra et. Nunc congue nisi vitae suscipit tellus mauris a diam maecenas. Pretium fusce id velit ut tortor pretium viverra suspendisse. Vel eros donec ac odio tempor. Ac feugiat sed lectus vestibulum. Rhoncus dolor purus non enim praesent elementum facilisis leo. Non tellus orci ac auctor augue mauris augue neque gravida. Vulputate ut pharetra sit amet.

Risus in hendrerit gravida rutrum quisque non tellus. Ultricies integer quis auctor elit. Neque aliquam vestibulum morbi blandit cursus risus at ultrices mi. Orci a scelerisque purus semper eget duis at. Viverra mauris in aliquam sem. Nisl purus in mollis nunc sed. Tempor orci dapibus ultrices in iaculis nunc sed augue lacus. Mollis nunc sed id semper. Consequat id porta nibh venenatis cras. Nisl vel pretium lectus quam id leo in. Vestibulum lorem sed risus ultricies tristique nulla aliquet. Egestas congue quisque egestas diam in arcu. Fusce id velit ut tortor pretium viverra suspendisse potenti nullam. Pellentesque pulvinar pellentesque habitant morbi tristique senectus et netus et. Malesuada proin libero nunc consequat interdum varius sit. Sagittis eu volutpat odio facilisis mauris sit. Tellus rutrum tellus pellentesque eu tincidunt tortor aliquam nulla. Tincidunt eget nullam non nisi est sit amet facilisis magna. Ullamcorper eget nulla facilisi etiam dignissim diam quis. Mauris ultrices eros in cursus turpis massa tincidunt dui.
              ''', style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: kBlackColor
              ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
