import 'package:flutter/material.dart';
import 'package:urcab/pages/DataBase.dart';
import 'package:youtube_player/youtube_player.dart';
import 'package:youtube_extractor/youtube_extractor.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flare_flutter/flare_actor.dart';

class FavVideo {
  String id, title;
}

class Entertainment extends StatefulWidget {
  @override
  _EntertainmentState createState() => _EntertainmentState();
}

class _EntertainmentState extends State<Entertainment> {
  bool startSearching = false;
  bool showList = false;
  List<YT_API> searchResults = [];
  List<FavVideo> favouriteVideos = [];
  YoutubeAPI ytapi = new YoutubeAPI("AIzaSyAvHXdOeoFw6TrzbZWpIxsmhH5HWReZXSA");
  var db = new DBHelper();
  final _controller = TextEditingController();

  void search(String query) async {
    setState(() {
      startSearching = true;
    });
    searchResults = await ytapi.search(query);
    setState(() {
      showList = searchResults.length > 0;
      startSearching = false;
    });
  }

  void getFav() async {
    var list = await db.getVideoFav();
    favouriteVideos = [];
    list.forEach((f) {
      FavVideo res = FavVideo();
      res.id = f['ID'];
      res.title = f['TITLE'];
      favouriteVideos.add(res);
    });
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFav();
  }

  @override
  Widget build(BuildContext context) {
    return FocusWatcher(
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    onTap: () {
                      setState(() {
                        //TODO open the list again when text field is tapped
                      });
                    },
                    onChanged: (s) {
                      if (s.length > 5) search(s);
                    },
                    controller: _controller,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Search music or video...",
                      contentPadding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      searchResults = [];
                      showList = false;
                      _controller.text = "";
                    });
                  },
                ),
                //TODO add voice button
              ],
            ),
            SizedBox(
              height: 8,
            ),
            startSearching
                ? SizedBox(
                    height: 60,
                    width: 60,
                    child: CircularProgressIndicator(
                      backgroundColor: Color(0xffDBC9DC),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xff702A74)),
                    ),
                  )
                : SizedBox(),
            Expanded(
              child: showList
                  ? ListView(
                      children: searchResults.map<Widget>((res) {
                        return VideoCard(
                          sr: res,
                        );
                      }).toList(),
                    )
                  : ListView(
                      children: favouriteVideos.map<Widget>((res) {
                        return VideoCard(
                          fv: res,
                        );
                      }).toList(),
                    ),
            )

/*
                        FutureBuilder(builder: (c, s) {
                            if (s.hasData) {
                                return Container();
                            }
                            else
                                return _controller.value.toString().length>0? CircularProgressIndicator(
                                    backgroundColor: Color(0xffDBC9DC),
                                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xff702A74)),
                                ):SizedBox();
                        },
                            future: search())
*/
          ],
        ),
      ),
    );
  }
}

class VideoCard extends StatefulWidget {
  final YT_API sr;
  final FavVideo fv;

  VideoCard({Key key, this.sr, this.fv}) : super(key: key);

  @override
  _VideoCardState createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  bool isPlaying = true;
  bool audioPlaying = false;
  var db = new DBHelper();
  bool madeFav;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    madeFav = widget.fv != null;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          AspectRatio(
            child: isPlaying
                ? YoutubePlayer(
                    controlsActiveBackgroundOverlay: true,
                    source: widget.sr != null
                        ? widget.sr.url.replaceAll(new RegExp(' '), '')
                        : "https://www.youtube.com/watch?v=" + widget.fv.id,
                    context: context,
                    quality: YoutubeQuality.MEDIUM,
                    autoPlay: false,
                    keepScreenOn: true,
                    //playerMode: YoutubePlayerMode.NO_CONTROLS,
                    showVideoProgressbar: true,
                    switchFullScreenOnLongPress: true,
                    /*callbackController: (c){
                      vc=c;
                      print(1);
            },*/
                  )
                : SizedBox(),
            /*  Image.network(
                    widget.sr.thumbnail['medium']['url'],
                    fit: BoxFit.cover,
                  ), */
            aspectRatio: 16 / 9,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: AutoSizeText(
              widget.sr != null ? widget.sr.title : widget.fv.title,
              style: TextStyle(fontWeight: FontWeight.w600),
              minFontSize: 20,
              maxLines: 2,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: audioPlaying ? Icon(Icons.pause) : Icon(Icons.music_note),
                onPressed: () async {
                  print(widget.sr.url);
                  /* var ext = YouTubeExtractor();
                  var musicUrl = await ext.getMediaStreamsAsync(widget.sr.id);
                  AudioPlayer ap = AudioPlayer();
                  if (audioPlaying)
                    await ap.pause();
                  else
                    await ap.play(musicUrl.audio.first.url);
                  setState(() {
                    audioPlaying = !audioPlaying;
                  }); */
                },
              ),
              IconButton(
                icon: madeFav
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border),
                onPressed: () async {
                  if (madeFav)
                    await db.deleteVideoFav(
                        widget.sr != null ? widget.sr.id : widget.fv.id,
                        widget.sr != null ? widget.sr.title : widget.fv.title);
                  else
                    await db.addVideoFav(
                        widget.sr != null ? widget.sr.id : widget.fv.id,
                        widget.sr != null ? widget.sr.title : widget.fv.title);

                  setState(() {
                    madeFav = !madeFav;
                  });
                },
              ),
            ],
          ),
          /*Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.skip_previous),
                onPressed: () {},
              ),
              IconButton(
                icon: isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                onPressed: () {
                  if(isPlaying) vc.pause();
                  else vc.play();
                  setState(() {
                    isPlaying = !isPlaying;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.skip_next),
                onPressed: () {},
              ),
            ],
          ),
        */
        ],
      ),
    );
  }
}
