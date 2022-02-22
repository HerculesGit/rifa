import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:rifa/core/components/loadings/loading.dart';
import 'package:rifa/core/contants/dimens_contants.dart';

import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:rifa/core/contants/styles.dart';
import 'package:rifa/core/validators/validations.dart';
import 'package:rifa/screen/home/widgets/m_text_form_field.dart';
import 'package:rifa/screen/print_preview/print_preview_controller.dart';

import 'widgets/circle_button.dart';

class PrintPreviewScreen extends GetView<PrintPreviewController> {
  PrintPreviewScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Obx(() => (controller.isLoading.isTrue)
          ? Center(child: Loading())
          : _buildBody()),
    );
  }

  Widget _buildBody() {
    return Column(
      // alignment: Alignment.bottomCenter,
      children: [
        Expanded(
          child: Obx(
            () {
              String name = controller.rifa.value.name;
              String number = controller.rifa.value.number;
              return PdfPreview(
                canChangePageFormat: false,
                useActions: false,
                build: (format) => _generatePdf(name: name, number: number),
              );
            },
          ),
        ),
        //Flexible(child: Container()),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: kLayoutMargin),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: kLayoutMargin / 2),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    MTextFormField(
                      hintText: 'Nome',
                      onChanged: (String? value) {
                        controller.changeName(value ?? '');
                      },
                      validators: [Validations.isEmpty('Nome')],
                    ),
                    MTextFormField(
                      hintText: 'Número',
                      onChanged: (String? value) {
                        controller.changeNumber(value ?? '');
                      },
                      inputType: TextInputType.number,
                      validators: [Validations.isEmpty('Número')],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: kLayoutMargin),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleButton(
                    onTap: () => controller.savePdfAtDevice(_formKey),
                    iconData: Icons.save,
                  ),
                  CircleButton(
                    onTap: () => controller.printPdf(_formKey),
                    iconData: Icons.print,
                  ),
                  CircleButton(
                    onTap: () => controller.sharePdf(_formKey),
                    iconData: Icons.share,
                  ),
                ],
              ),
              const SizedBox(height: kLayoutMargin),
            ],
          ),
        )
      ],
    );
  }

  Future<Uint8List> _generatePdf(
      {required String name, required String number}) async {
    controller.pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    const double h1 = 48 / 2;
    const double h2 = 35 / 2;
    const double p = 32 / 2;
    const double small = 28 / 2;

    const double margin = kLayoutMargin / 2;

    controller.pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        margin: const pw.EdgeInsets.symmetric(vertical: 16.0, horizontal: 42),
        build: (context) {
          return pw.Column(
            children: [
              pw.Center(child: pw.Image(controller.image, width: 160)),
              pw.Text(
                'Obrigado',
                style: pw.TextStyle(
                  fontSize: h1,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              _buildPadding(margin / 2),

              pw.Text(
                name,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: h2,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              _buildPadding(margin / 2),

              ///
              pw.Text(
                'Pela sua ajuda :D\nEste é seu #comprovante',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: p,
                  fontWeight: pw.FontWeight.normal,
                ),
              ),

              _buildPadding(margin),
              _buildHorizontalDivider(),
              _buildPadding(margin),
              pw.Text(
                'Você escolheu este número',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: p,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              _buildPadding(margin),
              _buildCircle(number),
              _buildPadding(margin),

              _buildHorizontalDivider(),

              ///
              _buildPadding(margin),
              pw.Text(
                'Lembrando que:',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: p,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              _buildPadding(margin),

              pw.Text(
                'O SORTEIO SERÁ DIA 01/06.\nNO DIA SERÁ GRAVADO UM VÍDEO\nPARA MOSTRAR O\nGANHADOR!',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: p - 2,
                  fontWeight: pw.FontWeight.normal,
                ),
              ),

              _buildPadding(margin),

              pw.Text(
                'Org: Hércules e Jéssica',
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(
                  fontSize: small,
                ),
              ),
              pw.Spacer(),
              pw.Flexible(
                child: pw.Text(
                  'Boa Sorte!',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontSize: h2,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return controller.pdf.save();
  }

  pw.Container _buildHorizontalDivider() {
    return pw.Container(
      height: 1.0,
      color: PdfColor.fromInt(kAccentColor.value),
    );
  }

  pw.Container _buildCircle(String number) {
    const size = 60.0;
    return pw.Container(
      width: size,
      height: size,
      decoration: pw.BoxDecoration(
        color: PdfColor.fromInt(kAccentColor.value),
        borderRadius: pw.BorderRadius.circular(size / 2),
      ),
      child: pw.Center(
        child: pw.Text(
          number,
          style: pw.TextStyle(
            fontSize: 25.0,
            fontWeight: pw.FontWeight.bold,
            color: PdfColor.fromInt(Colors.white.value),
          ),
        ),
      ),
    );
  }

  pw.Widget _buildPadding(double size) => pw.SizedBox(height: size);
}
