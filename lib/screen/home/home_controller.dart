import 'dart:io';
import 'dart:typed_data';

import 'package:docx_template/docx_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rifa/core/contants/path_constants.dart';
import 'package:rifa/models/ticket.dart';

class HomeController extends GetxController {
  final Rifa rifa = Rifa(chooseNumber: '', name: '');

  final folderName = chaRifaPath;
  final String sourcePathTemplateDocx = '$kDocxAssets/template.docx';

  /// variables state manager
  var isLoading = false.obs;
  var buttonEnabled = true.obs;

  /// simples methods
  setName(String name) => rifa.name = name;

  setNumber(String number) => rifa.chooseNumber = number;

  /// create docx
  createOutputDocx() async {
    showLoading();
    disableButton();

    await Future.delayed(const Duration(milliseconds: 500));
    await _createChaRifaFolder();
    final content = _editDocx();
    await _saveNewDocx(content);

    hideLoading();
    enableButton();
    showSuccessToast();
  }

  Content _editDocx() {
    const nameKey = 'name';
    const valueKey = 'name';

    Content content = Content();
    content.add(TextContent(nameKey, rifa.name));
    content.add(TextContent(valueKey, rifa.chooseNumber));
    return content;
  }

  Future<void> _saveNewDocx(Content content) async {
    final bytes = await _getTemplateDocxFromAssets();
    final docx = await DocxTemplate.fromBytes(bytes);

    final String outputPath =
        '$folderName/${rifa.name}_${rifa.chooseNumber}.docx';

    final d = await docx.generate(content);
    final of = File(outputPath);
    if (d != null) await of.writeAsBytes(d);
  }

  _createChaRifaFolder() async {
    final path = Directory(folderName);
    if (!(await path.exists())) {
      path.create();
    }
  }

  Future<Uint8List> _getTemplateDocxFromAssets() async {
    final data = await rootBundle.load(sourcePathTemplateDocx);
    final bytes = data.buffer.asUint8List();
    return bytes;
  }

  void showLoading() => isLoading.value = true;

  void hideLoading() => isLoading.value = false;

  void disableButton() => buttonEnabled.value = false;

  void enableButton() => buttonEnabled.value = true;

  void showSuccessToast() => showToast(
      'Docx salvo em Download/rifa/${rifa.name}_${rifa.chooseNumber}.docx',
      textStyle: const TextStyle(color: Colors.white),
      position: ToastPosition.bottom,
      backgroundColor: Colors.black87,
      duration: const Duration(seconds: 3),
      textPadding:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 32.0));
}
