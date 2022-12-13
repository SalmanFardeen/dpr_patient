import 'package:dpr_patient/src/business_logics/models/user_data.dart';
import 'package:dpr_patient/src/business_logics/providers/document_provider.dart';
import 'package:dpr_patient/src/views/ui/chat_list_screen.dart';
import 'package:dpr_patient/src/views/ui/upload_new_document.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:dpr_patient/src/views/widgets/shadow_container.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadedDocument extends StatefulWidget {
  const UploadedDocument({Key? key}) : super(key: key);

  @override
  State<UploadedDocument> createState() => _UploadedDocumentState();
}

class _UploadedDocumentState extends State<UploadedDocument> {

  void _launchURL(String _url) async {
    Uri url = Uri.parse(_url);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    var documentProvider = Provider.of<DocumentProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // documentProvider.getProfile();
      documentProvider.getDocumentList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DocumentProvider documentProvider = Provider.of<DocumentProvider>(context);
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: kWhiteColor,
        shadowColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(UserData.username ?? "", style: kTitleTextStyle),
                const SizedBox(height: 4.0),
                Text(UserData.gender != null && UserData.age != null ? "${UserData.gender}, ${UserData.age} years" : "", style: kParagraphTextStyle),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.zero,
            icon: const FaIcon(
              FontAwesomeIcons.facebookMessenger,
              size: 20,
            ),
            color: kDeepBlueColor,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatListScreen()));
            },
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8.0),
          Container(
            padding: const EdgeInsets.only(right: 20),
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 14),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.notifications,
                      color: kDeepBlueColor,
                    ),
                    onPressed: () {},
                    constraints: const BoxConstraints(),
                  ),
                ),
                Positioned(
                    top: 14,
                    left: 12,
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: const BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                      child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            "1",
                            style: TextStyle(fontSize: 6, color: kWhiteColor),
                          )),
                    ))
              ],
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: size.width,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    // Expanded(
                    //   flex: 2,
                    //   child: PatientLocation(location: UserData.address)
                    // ),
                    Expanded(
                        flex: 3,
                        child: Container()
                    ),
                    Expanded(
                      flex: 1,
                      child: WidgetFactory.buildButton(
                          context: context,
                          child: const Text("Add New", style: kButtonTextStyle),
                          backgroundColor: kDeepBlueColor,
                          borderRadius: 8.0,
                          onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const UploadNewDocument()));
                          }
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 24.0),
                const Text("Uploaded Documents", style: kLargerBlueTextStyle),
                const SizedBox(height: 16.0),
                (!documentProvider.inProgress && (documentProvider.uploadListModel?.data?.length ?? 0) == 0)
                ? SizedBox(width: size.width, height: 300, child: const Center(child: Text("No document uploaded", style: kTitleTextStyle)))
                : getList(documentProvider, size.width)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getList(DocumentProvider provider, double width) {
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: provider.uploadListModel?.data?.length ?? 0,
        separatorBuilder: (_, __) => const SizedBox(height: 16.0),
        itemBuilder: (BuildContext context, int position) {
          return provider.inProgress
              ? shimmer(width)
              : documentTile(provider, position);
        }
    );
  }

  Widget documentTile(DocumentProvider provider, int position) {
    return ShadowContainer(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(flex: 2,child: Text(provider.uploadListModel?.data?[position].doctDescription ?? "", style: kTitleTextStyle)),
            Expanded(
              flex: 1,
              child: WidgetFactory.buildButton(
                  context: context,
                  child: const Text("View Report", style: kButtonTextStyle, textAlign: TextAlign.center,),
                  backgroundColor: kDeepBlueColor,
                  borderRadius: 8.0,
                  onPressed: provider.uploadListModel?.data?[position].pathName == null
                    ? () {}
                    :() {
                    _launchURL(provider.uploadListModel?.data?[position].pathName ?? "");
                  }),
            )
          ],
        ),
        radius: 8.0
    );
  }

  Widget shimmer(width) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
                color: Colors.grey[200]!
            )
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 130, height: 20, color: Colors.grey[200]),
                  const SizedBox(height: 4.0),
                  Container(width: 150, height: 20, color: Colors.grey[200]),
                ],
              ),
            ),
            Container(
              width: 80,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}