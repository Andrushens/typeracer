import 'dart:ui';

import 'package:flutter/material.dart';

class HighlightedSymbolText extends StatelessWidget {
  final String text;
  final int index;
  final TextStyle? style;
  final Color highlightColor;

  const HighlightedSymbolText({
    required this.text,
    required this.index,
    required this.style,
    required this.highlightColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textBeforeHighlight = text.substring(0, index);
    var highlightedSymbol = text[index];
    var textAfterHighlight = text.substring(index + 1);
    return RichText(
      text: TextSpan(
        style: style,
        children: [
          TextSpan(text: textBeforeHighlight),
          TextSpan(
            text: highlightedSymbol,
            style: style?.copyWith(
              color: highlightColor,
              fontSize: style!.fontSize! + 4,
              decoration: TextDecoration.underline,
            ),
          ),
          TextSpan(text: textAfterHighlight),
        ],
      ),
    );
  }
}
