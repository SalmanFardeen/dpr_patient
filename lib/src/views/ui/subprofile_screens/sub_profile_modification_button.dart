import 'package:dpr_patient/src/business_logics/providers/profile_provider.dart';
import 'package:dpr_patient/src/views/ui/subprofile_screens/sub_profile_edit.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubProfileModificationButton extends StatelessWidget {
  const SubProfileModificationButton({Key? key, required this.onTapDelete}) : super(key: key);

  final VoidCallback onTapDelete;

  @override
  Widget build(BuildContext context) {
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    return PopupMenuButton(
        icon: Image.asset("assets/images/menu.png"),
        padding: EdgeInsets.zero,
        color: kLightGreyColor,
        itemBuilder: (context) => [
          PopupMenuItem(
            padding: const EdgeInsets.only(left: 8),
            child: Center(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubProfileEdit(
                              profileProvider: profileProvider)));
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.person,
                      size: 14,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      "Edit Profile",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            value: 1,
          ),
          if(profileProvider.subProfileModel?.data?.profile?.patRelation?.toLowerCase() != 'self')
            PopupMenuItem(
              padding: const EdgeInsets.only(left: 8),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  showDialog(context: context, builder: (context)=> AlertDialog(
                    title: const Text('Delete Profile'),
                    content: const Text('Press yes to delete the profile'),
                    actions: [
                      TextButton(onPressed: ()=> Navigator.pop(context), child: const Text('No')),
                      TextButton(onPressed: onTapDelete, child: const Text('Yes')),
                    ],
                  ));
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.delete,
                      size: 14,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      "Delete Profile",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              value: 2,
            )
        ]);
  }
}