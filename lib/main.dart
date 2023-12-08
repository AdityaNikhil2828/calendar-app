import 'package:calendar_app/services/themeservice.dart';
import 'package:calendar_app/ui/authui.dart';
import 'package:calendar_app/ui/home.dart';
import 'package:calendar_app/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import './firebase_options.dart';
// import 'ui/home.dart';
// import 'package:calendar_app/ui/calendar_page.dart';


Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

// options: DefaultFirebaseOptions.currentPlatform

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Calendar',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      initialRoute: '/', 
      routes: {
        '/': (context) => HomePage(),
        '/sign_in': (context) => SignInPage(), 
      },
    );
  }
}