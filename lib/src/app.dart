import 'package:dpr_patient/src/business_logics/models/user_location.dart';
import 'package:dpr_patient/src/services/location_services/location_service.dart';
import 'package:dpr_patient/src/views/ui/authenticate.dart';
import 'package:dpr_patient/src/views/widgets/custom_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserLocation>(
      create: (context) => LocationService().locationStream,
      initialData: UserLocation(latitude: 0.0, longitude: 0.0),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: CustomTheme.lightTheme,
        home: const Authenticate(),
      )
    );
  }
}
