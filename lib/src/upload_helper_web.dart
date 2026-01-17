// Web implementation
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

Future<List<int>?> readPlatformFileBytesImpl(PlatformFile pf) async {
  try {
    return pf.bytes;
  } catch (_) {
    return null;
  }
}
