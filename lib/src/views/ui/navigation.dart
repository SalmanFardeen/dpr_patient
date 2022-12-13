import 'package:dpr_patient/src/business_logics/providers/profile_provider.dart';
import 'package:dpr_patient/src/views/ui/future_work.dart';
import 'package:dpr_patient/src/views/ui/home.dart';
import 'package:dpr_patient/src/views/ui/menu.dart';
import 'package:dpr_patient/src/views/widgets/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Navigation extends StatefulWidget {

  final int selectedIndex;

  const Navigation({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {

  late ProfileProvider profileProvider;
  int _selectedIndex = 0;
  String? phoneNo;

  @override
  void initState() {
    _selectedIndex = widget.selectedIndex;
    super.initState();
  }

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedIndex = i;
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        bottomNavigationBar: BottomNavbar(
          elevation: 8.0,
          index: _selectedIndex,
          labelStyle: LabelStyle(
              showOnSelect: false,
              onSelectTextStyle: TextStyle(color: defaultOnSelectColor, fontSize: 12.0),
              textStyle: TextStyle(color: defaultColor, fontSize: 12.0),
              visible: true
          ),
          iconStyle: IconStyle(
              onSelectColor: const Color(0xFF3B406D),
              barColor: Colors.transparent,
              onSelectBarColor: Colors.blue,
              color: defaultColor,
              onSelectSize: 35.0,
              size: 35.0
          ),
          items: [
            BottomNavItem(icon: FeatherIcons.home, label: 'home'),
            BottomNavItem(icon: Icons.rss_feed, label: 'notification'),
            BottomNavItem(icon: FontAwesomeIcons.notesMedical, label: 'bookmark'),
            BottomNavItem(icon: Icons.settings, label: 'settings')
          ],
          onTap: _handleIndexChanged,
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
      );
  }

  final List<Widget> _widgetOptions = [
    const Home(),
    const FutureWork(),
    const FutureWork(),
    const Menu(),
  ];
}
