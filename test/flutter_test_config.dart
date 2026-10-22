import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

/// Loads the bundled Arabic fonts so widget tests lay out text with real
/// glyph metrics instead of the default Ahem boxes.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  const families = {
    'IBM Plex Sans Arabic': [
      'IBMPlexSansArabic-Regular.ttf',
      'IBMPlexSansArabic-Medium.ttf',
      'IBMPlexSansArabic-SemiBold.ttf',
      'IBMPlexSansArabic-Bold.ttf',
    ],
    'Readex Pro': ['ReadexPro-SemiBold.ttf', 'ReadexPro-Bold.ttf'],
  };
  for (final entry in families.entries) {
    final loader = FontLoader(entry.key);
    for (final file in entry.value) {
      final bytes = File('assets/fonts/$file').readAsBytesSync();
      loader.addFont(Future.value(ByteData.sublistView(bytes)));
    }
    await loader.load();
  }
  await testMain();
}
