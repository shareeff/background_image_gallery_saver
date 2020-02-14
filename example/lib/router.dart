import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'home_page.dart';

class RoutePaths {
  static const String Home = "/";
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.Home:
        return MaterialPageRoute(builder: (_) => HomePage());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
