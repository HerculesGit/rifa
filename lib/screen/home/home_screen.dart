import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rifa/core/components/loadings/loading.dart';
import 'package:rifa/core/contants/dimens_contants.dart';
import 'package:rifa/core/contants/path_constants.dart';
import 'package:rifa/core/validators/validations.dart';

import 'home_controller.dart';
import 'widgets/button_generate_receipt.dart';
import 'widgets/m_text_form_field.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: kHorizontalPadding,
          child: Obx(
            () => Column(
              children: [
                const SizedBox(height: kLayoutMargin),
                _buildImageContainer(),
                const SizedBox(height: kLayoutMargin),
                const Text(
                  'Coloque o nome e abaixo coloque o número escolhido',
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: kLayoutMargin / 2),
                if (controller.isLoading.isTrue)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Loading(),
                        const SizedBox(height: kLayoutMargin / 2),
                        const Text('Gerando arquivo...',
                            style: TextStyle(fontSize: 22))
                      ],
                    ),
                  ),
                if (controller.isLoading.isFalse) _buildBody(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: kLayoutMargin - 5),
        Image.asset('$kImageAssets/pombos.png', width: Get.context!.width / 2),
      ],
    );
  }

  Widget _buildBody() {
    return Flexible(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            MTextFormField(
              hintText: 'Nome',
              onChanged: (String? value) {
                controller.setName(value ?? '');
              },
              validators: [Validations.isEmpty('Nome')],
            ),
            MTextFormField(
              hintText: 'Número',
              onChanged: (String? value) {
                controller.setNumber(value ?? '');
              },
              inputType: TextInputType.number,
              validators: [Validations.isEmpty('Número')],
            ),
            Expanded(child: Container()),
            const SizedBox(height: kLayoutMargin),
            ButtonGenerateRecipient(
              enableButton: controller.buttonEnabled.isTrue,
              onPressed: () async {
                await requestPermission();
                onCreateTapped();
              },
            ),
            const SizedBox(height: kLayoutMargin),
          ],
        ),
      ),
    );
  }

  void onCreateTapped() {
    if (validate()) {
      controller.createOutputDocx();
    }
  }

  requestPermission() async {
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
    await Permission.accessMediaLocation.request();
    await Permission.mediaLibrary.request();
  }

  bool validate() => _formKey.currentState!.validate();

  String? validateIsNotEmpty(String? value) =>
      (value == null || value.isEmpty) ? "Esse campo não pode ser vazio" : null;
}
