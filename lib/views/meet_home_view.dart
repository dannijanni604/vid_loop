import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/call_controller.dart';

class MeetHomeView extends StatelessWidget {
  final CallController controller = Get.put(CallController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ZEGOCLOUD Video Call')),
      body: GetBuilder<CallController>(builder: (_) {
        return controller.isJoined.value
            ? Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 250,
                    child: controller.localViewWidget ??
                        Container(color: Colors.black12),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 250,
                    child: controller.remoteViewWidget ??
                        Container(color: Colors.black12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.leaveRoom();
              },
              child: const Text('Leave'),
            ),
          ],
        )
            : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Not in room'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  controller.initZego(); // Retry joining
                },
                child: const Text('Try Again'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
