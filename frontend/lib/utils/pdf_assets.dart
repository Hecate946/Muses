import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PdfAssets {
  static Future<String> getAssetPath(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;
    final String filePath = '$tempPath/${assetPath.split('/').last}';
    final File file = File(filePath);
    await file.writeAsBytes(data.buffer.asUint8List(), flush: true);
    return filePath;
  }
}
