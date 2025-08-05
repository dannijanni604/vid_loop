import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WatchTogetherController extends GetxController {
  final RxString roomID = ''.obs;
  final RxString userID = ''.obs;
  final RxBool isHost = false.obs;
  final RxBool isInRoom = false.obs;
  final RxString sharedVideoUrl = ''.obs;

  final TextEditingController roomInput = TextEditingController();
  final TextEditingController videoUrlInput = TextEditingController();

  void createRoom() {
    roomID.value = DateTime.now().millisecondsSinceEpoch.toString();
    isHost.value = true;
    isInRoom.value = true;
  }

  void joinRoom() {
    if (roomInput.text.trim().isNotEmpty) {
      roomID.value = roomInput.text.trim();
      isHost.value = false;
      isInRoom.value = true;
    }
  }

  void shareVideo() {
    if (videoUrlInput.text.trim().isNotEmpty) {
      sharedVideoUrl.value = videoUrlInput.text.trim();
    }
  }

  void leaveRoom() {
    isInRoom.value = false;
    isHost.value = false;
    roomID.value = '';
    sharedVideoUrl.value = '';
    roomInput.clear();
    videoUrlInput.clear();
  }

  @override
  void onClose() {
    roomInput.dispose();
    videoUrlInput.dispose();
    super.onClose();
  }
}
