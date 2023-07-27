import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class FirebaseImageEmbedBuilder extends EmbedBuilder {
  @override
  String get key => "image";

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
    return FirebaseImageWidget(
      imageUrl: imageUrl,
    );
  }
}

class FirebaseImageWidget extends StatefulWidget {
  final String imageUrl;

  FirebaseImageWidget({required this.imageUrl});

  @override
  _FirebaseImageWidgetState createState() => _FirebaseImageWidgetState();
}

class _FirebaseImageWidgetState extends State<FirebaseImageWidget> {
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _downloadAndSetImage();
  }

  Future<void> _downloadAndSetImage() async {
    try {
      final response = await http.get(Uri.parse(widget.imageUrl));
      if (response.statusCode == 200) {
        setState(() {
          _imageBytes = response.bodyBytes;
        });
      } else {
        print('Failed to load image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _imageBytes != null
        ? Image.memory(
      _imageBytes!,
      fit: BoxFit.cover,
    )
        : CircularProgressIndicator();
  }
}
