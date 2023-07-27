import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/embeds/utils.dart';

class ResponsiveImageEmbedBuilder extends EmbedBuilder {
  @override
  String get key => BlockEmbed.imageType;

  @override
  Widget build(
      BuildContext context,
      QuillController controller,
      Embed node,
      bool readOnly,
      bool inline,
      TextStyle textStyle,
      ) {
    final imageUrl = node.value.data;
    if (isImageBase64(imageUrl)) {
      return const SizedBox();
    }

    final size = MediaQuery.of(context).size;
    final maxWidth = size.width;
    final maxHeight = size.height * 0.45; // Limit the height to 45% of the screen height

    return Image.network(
      imageUrl,
      width: maxWidth,
      height: maxHeight,
      fit: BoxFit.cover,
    );
  }
}

