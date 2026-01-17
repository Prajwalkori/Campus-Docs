// IO implementation (non-web)
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

Future<List<int>?> readPlatformFileBytesImpl(PlatformFile pf) async {
  try {
    if (pf.bytes != null) return pf.bytes;
    if (pf.path == null) return null;
    final f = File(pf.path!);
    final bytes = await f.readAsBytes();
    return bytes;
  } catch (_) {
    return null;
  }
}
