
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'controllers/validation/login_validation_controller.dart';
import 'controllers/shared/sort_tab_setting_controller.dart';
import 'screens/auth/login.dart';
import 'screens/home.dart';
import 'screens/nav_screens/account.dart';
import 'screens/nav_screens/providers.dart';
import 'screens/onbaording.dart';



void main() {
  runApp(

     MultiProvider(
       providers: [
          ChangeNotifierProvider(create: (_) => LoginValidation()),
          ChangeNotifierProvider(create: (_) => SortingTabSetting()),
       ],
       child: MyApp(),
     )
   
  );
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProZone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Color(0xff89CBF0),
        primaryColor: Color(0xff094063),
        fontFamily: 'Montserrat'
      ),
      home: OnboardingScreen(),
      routes: {
          '/onboarding': (BuildContext context) => OnboardingScreen(),
          '/login' : (BuildContext context) => LoginScreen(),
          '/home' : (BuildContext context) => HomeScreen(),
          '/providers' : (BuildContext context) => ProvidersScreen(),
          '/account': (BuildContext context) => AccountScreen(),
    
      },
    );
  }
}




