import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

class CallController extends GetxController {
  final int appID = int.parse(dotenv.env['ZEGOCLOUD_APP_ID'] ?? '0');
  final String appSign = dotenv.env['ZEGOCLOUD_APP_SIGN'] ?? '';
  final String roomID = 'test_room';

  final String userID = 'user_${DateTime.now().millisecondsSinceEpoch}';
  final String userName = 'User_${DateTime.now().millisecondsSinceEpoch}';
  late final String streamID;

  RxBool isJoined = false.obs;
  RxBool isMicMuted = false.obs;
  RxBool isCameraOff = false.obs;

  int? localViewID;
  int? remoteViewID;
  Widget? localViewWidget;
  Widget? remoteViewWidget;

  bool _isEngineInitialized = false;

  @override
  void onInit() {
    streamID = 'stream_$userID';
    super.onInit();
    initZego();
  }

  Future<void> initZego() async {
    if (_isEngineInitialized) {
      print('ℹ️ Engine already initialized.');
      return;
    }

    print('⚙️ Initializing ZEGOCLOUD Engine...');
    if (appID == 0 || appSign.isEmpty) {
      print('❌ Invalid App ID or App Sign. Check your .env file.');
      return;
    }

    await ZegoExpressEngine.createEngineWithProfile(
      ZegoEngineProfile(
        appID,
        ZegoScenario.General,
        appSign: appSign,
        enablePlatformView: true,
      ),
    );
    _isEngineInitialized = true;

    ZegoExpressEngine.onRoomStateUpdate = (_, state, errorCode, __) {
      print('📡 Room state: $state, error: $errorCode');

      if (state == ZegoRoomState.Connected) {
        isJoined.value = true;
        _startSession();
      } else if (state == ZegoRoomState.Disconnected) {
        isJoined.value = false;
        _handleDisconnection();
      }

      update();
    };

    ZegoExpressEngine.onRoomStreamUpdate = (roomID, updateType, streamList, _) {
      print('🔁 Stream update: $updateType');
      if (updateType == ZegoUpdateType.Add) {
        for (final stream in streamList) {
          print('▶️ Remote stream added: ${stream.streamID}');
          startPlayingStream(stream.streamID);
        }
      } else if (updateType == ZegoUpdateType.Delete) {
        print('🛑 Remote stream removed');
        remoteViewWidget = null;
        update();
      }
    };

    print('🔐 Logging into room: $roomID as $userID');
    await ZegoExpressEngine.instance.loginRoom(
      roomID,
      ZegoUser(userID, userName),
      config: ZegoRoomConfig.defaultConfig()..isUserStatusNotify = true,
    );
  }

  Future<void> _startSession() async {
    final hasPermissions = await _requestPermissions();
    if (!hasPermissions) return;

    await _createLocalView();
    await _startPreview();
    await _startPublishing();
  }

  Future<bool> _requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final micStatus = await Permission.microphone.request();

    if (!cameraStatus.isGranted || !micStatus.isGranted) {
      Get.snackbar('Permission Denied', 'Camera and Microphone are required');
      return false;
    }
    return true;
  }

  Future<void> _createLocalView() async {
    localViewWidget = await ZegoExpressEngine.instance.createCanvasView((int viewID) {
      localViewID = viewID;
    });
    update();
  }

  Future<void> _startPreview() async {
    if (localViewID == null) return;
    final canvas = ZegoCanvas(localViewID!);
    await ZegoExpressEngine.instance.startPreview(canvas: canvas);
    print('🎥 Local preview started');
  }

  Future<void> _startPublishing() async {
    print('🚀 Publishing stream: $streamID');
    await ZegoExpressEngine.instance.startPublishingStream(streamID);
  }

  Future<void> startPlayingStream(String remoteStreamID) async {
    remoteViewWidget = await ZegoExpressEngine.instance.createCanvasView((int viewID) {
      remoteViewID = viewID;
      final canvas = ZegoCanvas(viewID);
      ZegoExpressEngine.instance.startPlayingStream(remoteStreamID, canvas: canvas);
    });
    update();
  }

  Future<void> toggleMic() async {
    isMicMuted.value = !isMicMuted.value;
    await ZegoExpressEngine.instance.muteMicrophone(isMicMuted.value);
    print('🎙️ Microphone ${isMicMuted.value ? 'muted' : 'unmuted'}');
  }

  Future<void> toggleCamera() async {
    isCameraOff.value = !isCameraOff.value;
    await ZegoExpressEngine.instance.enableCamera(!isCameraOff.value);
    print('📷 Camera ${isCameraOff.value ? 'off' : 'on'}');
  }

  void leaveRoom() {
    if (isJoined.value) {
      ZegoExpressEngine.instance.logoutRoom(roomID);
      print('❌ Left the room');
    }
    isJoined.value = false;
    localViewWidget = null;
    remoteViewWidget = null;
    update();
  }

  void _handleDisconnection() {
    print('⚠️ Disconnected from room. Attempting reconnect...');
    Future.delayed(const Duration(seconds: 3), () => initZego());
  }

  @override
  void onClose() {
    print('🧹 Cleaning up ZEGOCLOUD Engine...');
    ZegoExpressEngine.destroyEngine();
    super.onClose();
  }
}
