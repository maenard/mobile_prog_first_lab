import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Avatar extends StatefulWidget {
  const Avatar({
    super.key,
    required this.imgUrl,
    required this.onUpload,
  });

  final String? imgUrl;
  final void Function(File? img) onUpload;

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? image =
            await picker.pickImage(source: ImageSource.gallery);

        if (image != null) {
          setState(() {
            _image = File(image.path);
          });
          widget.onUpload(_image!);
        } else {
          return;
        }
      },
      child: CircleAvatar(
        radius: 100,
        backgroundImage: _image != null
            ? FileImage(_image!)
            : widget.imgUrl != null
                ? NetworkImage(widget.imgUrl!)
                : null,
        child: (_image == null && widget.imgUrl == null)
            ? const Icon(Icons.person, size: 80)
            : null,
      ),
    );
  }
}
