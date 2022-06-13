import 'dart:math';

class TextProvider {
  static final texts = [
    "Strings are mainly used to represent text. A character may be represented by multiple code points, each code point consisting of one or two code units. For example, the Papua New Guinea flag character requires four code units to represent two code points, but should be treated like a single character.",
    "Look at the stars. Same stars as last week, last year, when we were kids, before we were even born. In a hundred years no one will ever know who we were. They'll know those same stars.",
    "bruh bruh bruh bruh",
  ];

  static String getRandomText() {
    return texts[Random().nextInt(texts.length)];
  }
}
