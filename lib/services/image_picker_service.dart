import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker picker = ImagePicker();

  Future<File?> pickImageFromGallery() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (image == null) return null;
    return File(image.path);
  }
}
