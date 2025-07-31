import 'package:get/get.dart';

import '../services/yt_service.dart';

class YTController extends GetxController {
  final RxList<String> videoIds = <String>[].obs;
  final RxBool isLoading = true.obs;

  final YTService _youtubeService = YTService();

  @override
  void onInit() {
    super.onInit();
    loadVideos();
  }

  void loadVideos() async {
    isLoading.value = true;
    final videos = await _youtubeService.fetchShortsVideoIds();
    videoIds.assignAll(videos);
    isLoading.value = false;
  }
}
