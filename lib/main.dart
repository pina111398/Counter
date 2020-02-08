import 'package:counter/historial.dart';
import 'package:counter/loginPage.dart';
import 'package:counter/registerPage.dart';
import 'package:counter/splash_page.dart';
import 'package:counter/theme.dart';
import 'package:flutter/services.dart';

import 'homePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => 
      runApp(new MyApp());
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
          child: Consumer<ThemeNotifier>(
            builder: (context, ThemeNotifier notifier, child) {

              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                theme: notifier.darkTheme ? dark : light,
                home: SplashPage(),
                routes: <String, WidgetBuilder>{
                  '/home': (BuildContext context) => MyHomePage(title: 'Home'),
                  '/login': (BuildContext context) => LoginPage(),
                  '/register': (BuildContext context) => RegisterPage(),
                  '/historial':(BuildContext context) => Historial(),
                }
              );
            } ,
          ),);
    
  }
}

            