import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:rifa/core/contants/path_constants.dart';
import 'package:rifa/models/ticket.dart';

class PathManager {
  /// This method supports only [Platform.isAndroid] and [Platform.isIOS]
  static Future<String> getOutputPath(Rifa rifa,
      [String extension = '.pdf']) async {
    String outputPath = '$chaRifaPath/${docName(rifa)}';

    if (Platform.isIOS) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      outputPath = '$appDocPath/${rifa.name}_${rifa.number}$extension';
    }

    return outputPath;
  }

  static docName(Rifa rifa, [String extension = '.pdf']) =>
      '${rifa.name}_${rifa.number}$extension';

  static saveFileOnDevice(String outputPath, List<int> bytes) async {
    await _createChaRifaFolder();
    final file = File(outputPath);
    await file.writeAsBytes(bytes);
  }

  static _createChaRifaFolder() async {
    final path = Directory(chaRifaPath);
    if (!(await path.exists())) path.create();
  }
}
