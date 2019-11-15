import 'package:flutter/material.dart';
import 'package:youtube_player/youtube_player.dart';
import 'package:youtube_extractor/youtube_extractor.dart';
import 'package:youtube_api/youtube_api.dart';

void main() {
  runApp(MaterialApp(
    home: player(),
  ));
}

class player extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return player_state();
  }
}

class player_state extends State<player> {
  VideoPlayerController videocontrol;
  TextEditingController textController = new TextEditingController();
  bool isloading = false, isVideoPlaying = false;
  final String apikey = "AIzaSyDuxUqisoTX1sCPtc9TOXmUH1slR0Qzr2E";
  String url = "", audiourl = "";
  List<YT_API> res = [];
  String name = "";

  /*Future<String> _findLocalPath() async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }*/

  void make(String url1) async {
    var ext = YouTubeExtractor();
    var music = await ext.getMediaStreamsAsync(url1);
    audiourl = music.audio.first.url;
  }

  void search() async {
    res = [];
    setState(() {
      isloading = true;
    });
    YoutubeAPI ytapi = new YoutubeAPI(apikey);
    res = await ytapi.search(textController.text);
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    //make();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            TextField(
              controller: textController,
              decoration: InputDecoration(hintText: "Search"),
              keyboardType: TextInputType.text,
            ),
            RaisedButton(
              child: Text("Search"),
              onPressed: () {
                search();
              },
            ),
            url != ""
                ? Container(
                    child: Column(
                      children: <Widget>[
                        YoutubePlayer(
                          context: context,
                          source: url,
                          callbackController: (controller) {
                            videocontrol = controller;
                          },
                          quality: YoutubeQuality.MEDIUM,
                          playerMode: YoutubePlayerMode.NO_CONTROLS,
                          showVideoProgressbar: true,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.skip_previous),
                              onPressed: () async {
                                Duration curr = await videocontrol.position;
                                videocontrol.seekTo(
                                    new Duration(seconds: curr.inSeconds - 5));
                              },
                            ),
                            IconButton(
                              icon: Icon(isVideoPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow),
                              onPressed: () {
                                isVideoPlaying
                                    ? videocontrol.pause()
                                    : videocontrol.play();
                                setState(() {
                                  isVideoPlaying = !isVideoPlaying;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.skip_next),
                              onPressed: () async {
                                Duration curr = await videocontrol.position;
                                videocontrol.seekTo(
                                    new Duration(seconds: curr.inSeconds + 5));
                              },
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.file_download),
                          onPressed: () async {
                            /*String path =
                                (await _findLocalPath()) + '/Download';
                            final taskiD = await FlutterDownloader.enqueue(
                              url: audiourl,
                              savedDir: path,
                              showNotification: true,
                              openFileFromNotification: true,
                              fileName: name,
                            );*/
                            print(audiourl);
                          },
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
            isloading
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: res.length,
                      itemBuilder: (context, i) {
                        return res[i].kind == 'video'
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    String url2 = "";
                                    url2 = res[i].url;
                                    url = url2.replaceAll(new RegExp(' '), '');
                                    url2 = url2.split('=')[1];
                                    make(url2);
                                    print(audiourl);
                                    name = res[i].title;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                      res[i].title + "\n" + res[i].description),
                                ),
                              )
                            : SizedBox();
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
