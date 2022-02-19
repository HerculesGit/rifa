import 'package:get/get.dart';
import 'package:rifa/screen/home/home_binding.dart';
import 'package:rifa/screen/home/home_screen.dart';

import 'routes.dart';

class AppRoutes {
  static final pages = [
    GetPage(
      name: kHomeScreen,
      page: () => HomeScreen(),
      binding: HomeBinding(),
    ),
  ];

  static const initialRoute = kHomeScreen;
}
