import 'upload_helper_io.dart' if (dart.library.html) 'upload_helper_web.dart';

import 'package:file_picker/file_picker.dart';

Future<List<int>?> readPlatformFileBytes(PlatformFile pf) => readPlatformFileBytesImpl(pf);
