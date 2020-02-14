import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider_setup.dart';
import 'router.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: RoutePaths.Home,
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}
