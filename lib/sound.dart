// @dart=2.9
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';

class Sound extends StatefulWidget {
  @override
  State<Sound> createState() => _SoundState();
}



class _SoundState extends State<Sound> {
  var file;
  final _player = AudioPlayer();

  void getfile() async {
    // List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    // var root = storageInfo[0].rootDir;
    var fm = FileManager(root: Directory("/storage/emulated/0/Download"));
    file = await fm.filesTree(
      excludedPaths: ["/storage/emulated/0/Android" , "/storage/emulated/0/MIUI"],
      extensions: ["mp3"],
    );
    setState(() {

    });
  }
  void perm() async {
    var status = await Permission.audio.status;
    if(status.isDenied){
      Permission.audio.request();
      Permission.storage.request();
    }
    if(status.isGranted){
      getfile();
    }
  }



  Future<void> _ini() async {
    final session = await AudioSession.instance;
    await session.configuration;
    AudioSessionConfiguration.speech();
  }

  @override
  void initState() {
    perm();
    getfile();
    _ini();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Center(child: Text("MUSIC"),),
        backgroundColor: Color(0xFF738FECA6),
      ),
      body: file== null ? Center(child: Text('NO MUSIC')):
            ListView.builder(
              itemCount: file?.length ?? 0,
                itemBuilder: (context, index){
                return Card(
                  child: ListTile(
                    title: Text(file[index].path.split('/').last, style: TextStyle(color: Colors.green),),
                    leading: Icon(Icons.audiotrack, color: Colors.green,),
                    trailing: Icon(Icons.play_arrow,color: Colors.green,),
                    onTap: (){
                      if(_player.playing)_player.stop();
                      _player.setUrl(file[index].path).then((value) => (play){
                        _player.play();
                        print("player playing");
                      });
                      _player.setFilePath(file[index].path).then((value) => (play){
                        _player.play();
                        print(("pplaying"));
                      });
                    },
                  ),
                );
                }),
    );
  }
}
