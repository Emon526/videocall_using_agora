import 'dart:developer';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:videocall/pages/call.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final _channelcontroller = TextEditingController();
  bool _validateError = false;
  ClientRole? _role = ClientRole.Broadcaster;

  @override
  void dispose() {
    _channelcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Image.network(
                  'https://png.pngtree.com/png-vector/20190529/ourlarge/pngtree-video-call-application-concept-male-hand-holding-smart-phone-with-png-image_1109259.jpg'),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _channelcontroller,
                decoration: InputDecoration(
                    errorText:
                        _validateError ? 'Channel name is mandatory' : null,
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(width: 1),
                    ),
                    hintText: 'Channel Name'),
              ),
              RadioListTile(
                  title: const Text('Broadcaster'),
                  value: ClientRole.Broadcaster,
                  groupValue: _role,
                  onChanged: (ClientRole? value) {
                    setState(() {
                      _role = value;
                      print(_role);
                    });
                  }),
              RadioListTile(
                  title: const Text('Audience'),
                  value: ClientRole.Audience,
                  groupValue: _role,
                  onChanged: (ClientRole? value) {
                    setState(() {
                      _role = value;
                      print(_role);
                    });
                  }),
              ElevatedButton(
                onPressed: onJoin,
                child: const Text('Join'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    setState(() {
      _channelcontroller.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if (_channelcontroller.text.isNotEmpty) {
      await _handlecameraAndMic(Permission.camera);
      await _handlecameraAndMic(Permission.microphone);

      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CallPage(
                    channelname: _channelcontroller.text,
                    role: _role,
                  )));
    }
  }

  Future<void> _handlecameraAndMic(Permission permission) async {
    final status = await permission.request();
    log(status.toString());
  }
}
