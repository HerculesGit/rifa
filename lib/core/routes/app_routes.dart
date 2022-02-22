import 'package:get/get.dart';
import 'package:rifa/screen/home/home_binding.dart';
import 'package:rifa/screen/home/home_screen.dart';
import 'package:rifa/screen/print_preview/print_preview.dart';
import 'package:rifa/screen/print_preview/print_preview_binding.dart';

import 'routes.dart';

class AppRoutes {
  static final pages = [
    GetPage(
      name: kHomeScreen,
      page: () => HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: kPrintPreviewScreen,
      page: () => PrintPreviewScreen(),
      binding: PrintPreviewScreenBinding(),
    ),
  ];

  static const initialRoute = kPrintPreviewScreen;
}
