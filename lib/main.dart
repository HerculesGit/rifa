import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rifa/core/routes/app_routes.dart';

import 'core/contants/styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();

    return OKToast(
      child: GetMaterialApp(
        getPages: AppRoutes.pages,
        initialRoute: AppRoutes.initialRoute,
        title: 'Rifas',
        theme: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(secondary: kAccentColor),
          accentColor: kAccentColor,
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
