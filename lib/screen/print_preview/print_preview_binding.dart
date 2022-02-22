import 'package:get/get.dart';

import 'print_preview_controller.dart';

class PrintPreviewScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrintPreviewController>(() {
      return PrintPreviewController();
    });
  }
}
