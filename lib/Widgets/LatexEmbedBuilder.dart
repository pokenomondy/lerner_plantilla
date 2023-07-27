import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class LatexEmbedBuilder extends EmbedBuilder {
  @override
  String get key => "latex";

  @override
  Widget build(
      BuildContext context,
      QuillController controller,
      Embed node,
      bool readOnly,
      bool inline,
      TextStyle textStyle,
      ) {
    final latexContent = node.value.data;

    return Container(
      // Set the desired padding, margin, or constraints for the LaTeX widget here.
      // For example, you can use padding or constraints to control the size and spacing.
      padding: const EdgeInsets.all(2.0),
      child: Math.tex(
        latexContent,
        textStyle: textStyle,
      ),
    );
  }
}
