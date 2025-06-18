import 'dart:io';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:emotion_music_app/model/chat_user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerProvider extends ChangeNotifier {
  late ImagePicker _imagePicker;
  bool _selectedImage = false;

  late File _imageSelected;
  final ChatUserModel chatUserModel = ChatUserModel();

  bool get selectedImage => _selectedImage;

  File get imageSelected => _imageSelected;

  ImagePickerProvider() {
    _imagePicker = ImagePicker();
  }

  Future<void> pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      _selectedImage = true;
      _imageSelected = File(image.path);

      ChatMessage chatMessage = ChatMessage(
        user: ChatUserModel.user,
        createdAt: DateTime.now(),
        text: '',
        medias: [
          ChatMedia(
            url: image.path,
            fileName: image.name,
            type: MediaType.image,
          ),
        ],
      );
      chatUserModel.messages.insert(0, chatMessage);

      notifyListeners();
    }
  }
}
