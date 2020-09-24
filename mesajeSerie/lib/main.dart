import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mesajeSerie/providers/Serii.dart';
import 'package:mesajeSerie/screens/MesajeScreen.dart';
import 'package:mesajeSerie/screens/SeriiOverviewScreen.dart';

import 'package:mesajeSerie/screens/MpScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Serii(),
        )
      ],
      child: MaterialApp(
        title: 'HarvestApp',
        theme: ThemeData(
          primaryColor: Colors.black,
          errorColor: Colors.red,
          fontFamily: 'Roboto',
        ),
        home: SeriiOverviewScreen(),
        routes: {
          MesajeScreen.routeName: (ctx) => MesajeScreen(),
          MpScreen.routeName: (ctx) => MpScreen(),
          //NewPdfScreen.routeName: (ctx) => NewPdfScreen(),
        },
      ),
    );
  }
}
