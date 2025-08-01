import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class CallController extends GetxController {
  final int appID = int.parse(dotenv.env['ZEGOCLOUD_APP_ID']!);
  final String appSign = dotenv.env['ZEGOCLOUD_APP_SIGN']!;
  final String roomID = 'test_room';

  final String userID = 'user_${DateTime.now().millisecondsSinceEpoch}';
  final String userName = 'User_${DateTime.now().millisecondsSinceEpoch}';

  RxBool isJoined = false.obs;
  int? localViewID;
  int? remoteViewID;
  Widget? localViewWidget;
  Widget? remoteViewWidget;

  @override
  void onInit() {
    super.onInit();
    initZego();
  }

  Future<void> initZego() async {
    await ZegoExpressEngine.createEngineWithProfile(
      ZegoEngineProfile(appID, ZegoScenario.General, appSign: appSign, enablePlatformView: true),
    );

    ZegoExpressEngine.onRoomStateUpdate = (_, state, err, __) {
      if (state == ZegoRoomState.Connected) {
        isJoined.value = true;
      }
    };

    ZegoExpressEngine.onRoomStreamUpdate = (room, updateType, streamList, _) {
      if (updateType == ZegoUpdateType.Add) {
        for (final stream in streamList) {
          startPlayingStream(stream.streamID);
        }
      }
    };

    await ZegoExpressEngine.instance.loginRoom(roomID, ZegoUser(userID, userName),
        config: ZegoRoomConfig.defaultConfig()..isUserStatusNotify = true);
  }

  Future<void> startPreview() async {
    await Permission.camera.request();
    await Permission.microphone.request();

    localViewWidget = await ZegoExpressEngine.instance.createCanvasView((int viewID) {
      localViewID = viewID;
      final canvas = ZegoCanvas(viewID);
      ZegoExpressEngine.instance.startPreview(canvas: canvas);
    });
    update();
  }

  Future<void> startPublishing() async {
    await ZegoExpressEngine.instance.startPublishingStream('stream_$userID');
  }

  Future<void> startPlayingStream(String streamID) async {
    remoteViewWidget = await ZegoExpressEngine.instance.createCanvasView((int viewID) {
      remoteViewID = viewID;
      final canvas = ZegoCanvas(viewID);
      ZegoExpressEngine.instance.startPlayingStream(streamID, canvas: canvas);
    });
    update();
  }

  void leaveRoom() {
    ZegoExpressEngine.instance.logoutRoom(roomID);
    isJoined.value = false;
  }

  @override
  void onClose() {
    ZegoExpressEngine.destroyEngine();
    super.onClose();
  }
}
