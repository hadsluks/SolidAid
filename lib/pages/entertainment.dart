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
  String searchKey;
  Entertainment({this.searchKey});
  @override
  EntertainmentState createState() => EntertainmentState();
}

class EntertainmentState extends State<Entertainment> {
  bool startSearching = false;
  bool showList = false;
  bool initialSearch = false;
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

  Future<List<YT_API>> search2(String query) async {
    setState(() {
      startSearching = true;
    });
    searchResults = await ytapi.search(query);
    setState(() {
      showList = searchResults.length > 0;
      startSearching = false;
    });
    return searchResults;
  }

  void search1(String query) async {
    print(1);
    startSearching = true;
    searchResults = await ytapi.search(query);
    showList = searchResults.length > 0;
    startSearching = false;
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
    initialSearch = widget.searchKey != null && widget.searchKey.length > 0;
  }

  @override
  Widget build(BuildContext context) {
    return FocusWatcher(
      child: Scaffold(
        appBar: widget.searchKey != null && widget.searchKey.length > 0
            ? AppBar(
                centerTitle: true,
                elevation: 8.0,
                backgroundColor: Color(0xffDBC9DC),
                title: Text(
                  widget.searchKey.toString(),
                  style: TextStyle(
                      color: Color(0xff0A010B),
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0),
                ),
              )
            : null,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
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
                        hintText: "Search Latest Music or Video",
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
            showList || favouriteVideos.length > 0 || initialSearch
                ? Expanded(
                    child: showList
                        ? ListView(
                            children: searchResults.map<Widget>((res) {
                              return VideoCard(
                                sr: res,
                              );
                            }).toList(),
                          )
                        : (favouriteVideos.length > 0
                            ? ListView(
                                children: favouriteVideos.map<Widget>((res) {
                                  return VideoCard(
                                    fv: res,
                                  );
                                }).toList(),
                              )
                            : (initialSearch
                                ? FutureBuilder(
                                    future: search2(widget.searchKey),
                                    builder: (context, sp) {
                                      if (sp.hasData) {
                                        return ListView(
                                          children:
                                              searchResults.map<Widget>((res) {
                                            return VideoCard(
                                              sr: res,
                                            );
                                          }).toList(),
                                        );
                                      } else
                                        return SizedBox();
                                    },
                                  )
                                : SizedBox())),
                  )
                : SizedBox(),
            showList || startSearching || favouriteVideos.length > 0
                ? SizedBox()
                : Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: FlareActor(
                          "lib/assets/notfound.flr",
                          fit: BoxFit.cover,
                          animation: "not_found",
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      SizedBox(
                        width: 200,
                        child: AutoSizeText(
                          "No Faourite Videos.\nSearch for videos above or use mic.",
                          textAlign: TextAlign.center,
                          maxLines: 4,
                          minFontSize: 22,
                        ),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                    ],
                  ),

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
  bool audioPlaying = false, audioReading = false;
  AudioPlayer ap = new AudioPlayer();
  var db = new DBHelper();
  bool madeFav;
  var musicUrl;

  Future loadAsAudio() async {
    var ext = YouTubeExtractor();
    musicUrl = await ext
        .getMediaStreamsAsync(widget.sr != null ? widget.sr.id : widget.fv.id);
    print("Here!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    print(musicUrl.audio.first.url);
    await ap.play(musicUrl.audio.first.url);
    await ap.pause();
    return musicUrl;
  }

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
              FutureBuilder(
                future: loadAsAudio(),
                builder: (c, sp) {
                  if (sp.hasData || musicUrl != null) {
                    return IconButton(
                      icon: audioPlaying
                          ? Icon(Icons.pause)
                          : Icon(Icons.music_note),
                      onPressed: () async {
                        if (audioPlaying) {
                          await ap.pause();
                        } else {
                          setState(() {
                            audioReading = true;
                          });
                          await ap.play(musicUrl.audio.first.url);
                        }
                        setState(() {
                          audioPlaying = !audioPlaying;
                        });
                      },
                    );
                  } else
                    return CircularProgressIndicator();
                },
              ),
              IconButton(
                icon: madeFav
                    ? Icon(
                        Icons.favorite,
                        color: Colors.pink,
                      )
                    : Icon(
                        Icons.favorite_border,
                        color: Colors.pink,
                      ),
                onPressed: () async {
                  if (madeFav) {
                    await db.deleteVideoFav(
                        widget.sr != null ? widget.sr.id : widget.fv.id,
                        widget.sr != null
                            ? widget.sr.title
                            : widget.fv
                                .title); // TODO remove favourite and do setState
                  } else
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
