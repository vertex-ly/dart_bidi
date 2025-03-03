/// Implementation of the Bidi algorithm, as described in http://www.unicode.org/reports/tr9/tr9-17.html.
///
/// Converts *logical* strings to their equivalent *visual* representation. Persian, Hebrew and Arabic languages (and any other RTL language) are supported.
library bidi;

import 'dart:core';
import 'dart:math';
import 'dart:collection';

part 'src/bidi.dart';
part 'src/paragraph.dart';
part 'src/stack.dart';
part 'src/character_mirror_resolver.dart';
part 'src/enums.dart';
part 'src/shaping_resolver.dart';
part 'src/unicode_character_resolver.dart';
