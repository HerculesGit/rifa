import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:rifa/core/contants/path_constants.dart';
import 'package:rifa/models/ticket.dart';
import 'package:rifa/service/path_manager.dart';

class PrintPreviewController extends GetxController {
  late pw.ImageProvider image;
  late pw.Document pdf;

  var rifa = Rifa(name: '', number: '').obs;

  var isLoading = false.obs;
  var buttonEnabled = false.obs;
  bool requestPermissionAgain = true;

  @override
  void onInit() {
    loadImage();
    super.onInit();
  }

  loadImage() async {
    showLoading();
    image = await imageFromAssetBundle('$kImageAssets/pombo_logo.png');
    hideLoading();
  }

  sharePdf(GlobalKey<FormState> formKey) async {
    if (_validate(formKey)) {
      showLoading();
      final name = PathManager.docName(rifa.value);
      await Printing.sharePdf(bytes: await pdf.save(), filename: name);
      hideLoading();
    } else {
      showInfoToast('Ops! Preencha os campos obrigatórios');
    }
  }

  printPdf(GlobalKey<FormState> formKey) async {
    if (_validate(formKey)) {
      showLoading();
      final name = PathManager.docName(rifa.value);
      await Printing.layoutPdf(onLayout: (_) async => pdf.save());
      //await Printing.sharePdf(bytes: await pdf.save(), filename: name);
      hideLoading();
    } else {
      showInfoToast('Ops! Preencha os campos obrigatórios');
    }
  }

  savePdfAtDevice(GlobalKey<FormState> formKey) async {
    await requestPermission();

    if (requestPermissionAgain) {
      showInfoToast(
          'Ops! É necessário dar permissão ao app para salvar o arquivo localmente');
      return;
    }

    if (_validate(formKey)) {
      showLoading();
      final path = await PathManager.getOutputPath(rifa.value);
      await PathManager.saveFileOnDevice(path, await pdf.save());
      hideLoading();
      showInfoToast('Docx salvo em $path');
    } else {
      showInfoToast('Ops! Preencha os campos obrigatórios');
    }
  }

  requestPermission() async {
    requestPermissionAgain = false;
    final PermissionStatus storagePermissionStatus =
        await Permission.storage.request();
    final PermissionStatus manageExternalStoragePermissionStatus =
        await Permission.manageExternalStorage.request();
    final PermissionStatus accessMediaLocationPermissionStatus =
        await Permission.accessMediaLocation.request();
    final PermissionStatus mediaLibraryPermissionStatus =
        await Permission.mediaLibrary.request();

    if (storagePermissionStatus.isDenied ||
        storagePermissionStatus.isPermanentlyDenied ||
        manageExternalStoragePermissionStatus.isDenied ||
        manageExternalStoragePermissionStatus.isPermanentlyDenied ||
        accessMediaLocationPermissionStatus.isDenied ||
        accessMediaLocationPermissionStatus.isPermanentlyDenied ||
        mediaLibraryPermissionStatus.isDenied ||
        mediaLibraryPermissionStatus.isPermanentlyDenied) {
      requestPermissionAgain = true;
    }
  }

  _validate(GlobalKey<FormState> formKey) => formKey.currentState!.validate();

  void showInfoToast(String message) => showToast(message,
      textStyle: const TextStyle(color: Colors.white),
      position: ToastPosition.bottom,
      backgroundColor: Colors.black87,
      duration: const Duration(seconds: 3),
      textPadding:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 32.0));

  void changeName(String name) => rifa.update((value) => value?.name = name);

  void changeNumber(String number) =>
      rifa.update((value) => value?.number = number);

  void showLoading() => isLoading.value = true;

  void hideLoading() => isLoading.value = false;

  void disableButton() => buttonEnabled.value = false;

  void enableButton() => buttonEnabled.value = true;
}
