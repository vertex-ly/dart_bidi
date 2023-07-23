part of bidi;

/// Implementation of the BIDI algorithm, as described in http://www.unicode.org/reports/tr9/tr9-17.html
/// [logicalString] is the original logical-ordered string. Returns the visual representation of the string.
List<int> logicalToVisual(String logicalString, {Options options = const Options()}) {
  final pars = splitStringToParagraphs(logicalString, options: options);
  final sb = <int>[];
  for (final p in pars) {
    sb.addAll(p.bidiText);
  }

  return sb;
}

/// Implementation of the BIDI algorithm, as described in http://www.unicode.org/reports/tr9/tr9-17.html
/// [logicalString] is the original logical-ordered string.
/// [indexes] Implies where the original characters are.
/// [lengths] Implies how many characters each original character occupies.
/// Returns the visual representation of the string.
String logicalToVisual2(
  String logicalString,
  List<int> indexes,
  List<int> lengths, {
  Options options = const Options(),
}) {
  //Section 3:
  //1. seperate text into paragraphs
  //2. resulate each paragraph to its embeding levels of text
  //2.1 find the first character of type L, AL, or R.
  //3. reorder text elements

  //Section 3.3: Resolving Embedding Levels:
  //(1) determining the paragraph level.
  //(2) determining explicit embedding levels and directions.
  //(3) resolving weak types.
  //(4) resolving neutral types.
  //(5) resolving implicit embedding levels.

  List<Paragraph> pars = splitStringToParagraphs(logicalString, options: options);
  final sb = <int>[];
  for (Paragraph p in pars) {
    sb.addAll(p.bidiText);
    indexes.addAll(p.bidiIndexes);
    lengths.addAll(p.bidiIndexLengths);
  }

  return String.fromCharCodes(sb);
}

/// Split the text into separate paragraphs.
///
/// A paragraph separator is kept with the previous paragraph.
/// Within each paragraph, apply all the other rules of this algorithm.
///
/// 3.3.1.P1.
List<Paragraph> splitStringToParagraphs(String logicalString, {Options options = const Options()}) {
  List<Paragraph> ret = [];

  var sb = <int>[];
  for (var i = 0; i < logicalString.length; ++i) {
    final c = logicalString.codeUnits[i];
    final cType = _getBidiCharacterType(c);
    if (cType == _BidiCharacterType.B) {
      final p = Paragraph._(sb, c,options: options);
      ret.add(p);
      sb = [];
    } else {
      sb.add(c);
    }
  }
  if (sb.isNotEmpty) // string ended without a paragraph separator
  {
    ret.add(Paragraph._(sb, _BidiChars.NotAChar,options: options));
  }
  return ret;
}

/// Holds configurations for the conversion process.
class Options {
  /// Default constructor.
  const Options({
    this.useBasicArabicCharForm = false,
  });

  /// If true, the algorithm will use the basic form of the letter instead of the isolated form.
  ///
  /// For example, the letter 'ل' has an isolated form (0x644) and a basic form (0xFE8E).
  /// setting this option to true will result in the letter 'ل' being remapped as 0xFE8E instead of 0x644.
  ///
  /// defaults to false.
  final bool useBasicArabicCharForm;
}
