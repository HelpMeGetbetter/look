import 'dart:io';

import 'package:flutter/material.dart';
import 'package:groceryapp/authentication/sign_up_auth.dart';
import 'package:groceryapp/pages/sign_up.dart';

void main() {
  runApp((App()));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignUpAuth(),

    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}



