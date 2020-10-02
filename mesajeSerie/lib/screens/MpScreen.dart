import 'dart:async';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mesajeSerie/providers/Mesaj.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

class MpScreen extends StatefulWidget {
  static const routeName = '/mp';
  static const double pi = 3.1415926535897932;

  final Mesaj mesaj;

  MpScreen(this.mesaj);

  @override
  _MpScreenState createState() => _MpScreenState();
}

class _MpScreenState extends State<MpScreen> {
  MediaItem mediaItemFromMesaj;
  // Mesaj mesaj;

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  close() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // widget.mesaj = ModalRoute.of(context).settings.arguments as Mesaj;
    mediaItemFromMesaj = widget.mesaj.mediaItem;

    return Scaffold(
      //appBar: AppBar(),
      body: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.grey,
          // accentColor: Colors.black,
          // cardColor: Colors.black,
          primaryColor: Colors.black,
        ),
        routes: {},
        home: AudioServiceWidget(
            child: MainScreen(widget.mesaj, mediaItemFromMesaj, context)),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  final MediaItem mediaItemFromMesaj;
  final Mesaj mesaj;
  BuildContext contextMpScreen;

  MainScreen(this.mesaj, this.mediaItemFromMesaj, this.contextMpScreen);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  /// Tracks the position while the user drags the seek bar.
  final BehaviorSubject<double> _dragPositionSubject =
      BehaviorSubject.seeded(null);

  Future<void> _launched;

  // String toLaunch =
  //     'https://harvestbucuresti.ro/wp-content/uploads/2020/06/Serie-%C3%8En-Ora%C5%9F-%C3%8Endemna%C5%A3i-S%C4%83-Practic%C4%83m-Ce-Am-Devenit-%C3%8Entreb%C4%83ri-GM.pdf';

  String pdfUrl = 'pdfUrl';

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return const Text('');
    }
  }

  Widget pdf() {
    return RaisedButton(
      onPressed: () => setState(() {
        _launched = _launchInBrowser(pdfUrl);
      }),
      child: const Text('Launch in app'),
    );
  }

  void launchPdf() {
    setState(() {
      _launched = _launchInBrowser(pdfUrl);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    AudioService.stop();

    super.dispose();
  }

  List<String> s = [
    'aa',
    'bb',
    'cc',
  ];
  double _value = 1.0;

  @override
  Widget build(BuildContext context) {
    // if (widget.mesaj.pdfUrl.isEmpty) {
    //   pdfUrl = 'pdfUrl';
    // } else {
    //   pdfUrl = widget.mesaj.pdfUrl;
    // }
    widget.mesaj.pdfUrl == null
        ? pdfUrl = 'pdfUrl'
        : pdfUrl = widget.mesaj.pdfUrl;
    String ideiContent = '';
    int j = 1;
    widget.mesaj.puncte.forEach((punct) {
      String i = j.toString() + '. ';
      ideiContent += i + punct.titluPunct;
      j++;
      ideiContent += '\n';
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: StreamBuilder<ScreenState>(
            stream: _screenStateStream,
            builder: (context, snapshot) {
              final screenState = snapshot.data;
              //final queue = screenState?.queue;
              /// de lucrat aici
              final mediaItem = widget.mediaItemFromMesaj;
              final state = screenState?.playbackState;
              final processingState =
                  state?.processingState ?? AudioProcessingState.none;
              final playing = state?.playing ?? false;

              return Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Stack(
                      children: [
                        Container(
                          foregroundDecoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xff000000),
                                Color(0x1E1E1E1E),
                                Color(0x00000000),
                                Color(0x00000000),
                                Color(0x00000000),
                                Color(0x00000000),
                              ],
                            ),
                          ),
                          width: double.infinity,
                          child: Image.network(
                            mediaItem.artUri,
                            alignment: Alignment.center,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes
                                      : null,
                                ),
                              );
                            },
                            //fit: BoxFit.cover,
                          ),
                        ),
                        // Container(
                        //   alignment: Alignment.center,
                        //   child: Text('TITLU'),
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 25,
                          ),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: () =>
                                  Navigator.of(widget.contextMpScreen).pop(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 10,
                    ),
                    child: Text(
                      '${widget.mesaj.titlu}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins-Italic',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 14,
                      right: 14,
                      top: 10,
                      bottom: 5,
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '     IdeeaCentrala: ',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: '${widget.mesaj.ideeaCentrala}',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 'Ideea centrala: ${widget.mesaj.ideeaCentrala}',
                  // style: TextStyle(
                  //     fontSize: 15,
                  //     fontFamily: 'Poppins',
                  //     fontWeight: FontWeight.normal),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 42,
                    ),
                    child: Text(
                      ideiContent,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  // RaisedButton(
                  //   child: Image.asset('assets/asset-pdf.png'),
                  //   onPressed: () {},
                  // ),
                  if (pdfUrl == 'pdfUrl')
                    Container()
                  else
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 39,
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            child: Ink.image(
                              image: AssetImage('assets/asset-pdf.png'),
                              fit: BoxFit.contain,
                              child: InkWell(
                                onTap: launchPdf,
                              ),
                            ),
                          ),
                          Container(child: Text('Intrebari')),
                        ],
                      ),
                    ),

                  Container(
                    padding: EdgeInsets.only(bottom: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (processingState == AudioProcessingState.none) ...[
                          Column(
                            children: [
                              audioPlayerButton(mediaItem.title),
                              Container(
                                child: Text('Predica'),
                              )
                            ],
                          )
                        ] else ...[
                          if (mediaItem?.title != null)
                            //Text(mediaItem.title),
                            positionIndicator(mediaItem, state),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(0),
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.0),
                                    //color: Colors.grey,
                                  ),
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.03,
                                      right: MediaQuery.of(context).size.width *
                                          0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                        value: _value,
                                        iconSize: 0.0,
                                        items: [
                                          DropdownMenuItem(
                                            child: Text(
                                              '0.5x',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            value: 0.5,
                                          ),
                                          DropdownMenuItem(
                                            child: Text(
                                              '0.75x',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            value: 0.75,
                                          ),
                                          DropdownMenuItem(
                                            child: Text(
                                              "1x ",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            value: 1.0,
                                          ),
                                          DropdownMenuItem(
                                            child: Text(
                                              "1.25x ",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            value: 1.25,
                                          ),
                                          DropdownMenuItem(
                                            child: Text(
                                              "1.5x",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            value: 1.5,
                                          ),
                                          DropdownMenuItem(
                                            child: Text(
                                              "1.75x ",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            value: 1.75,
                                          ),
                                          DropdownMenuItem(
                                            child: Text(
                                              "2x ",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            value: 2.0,
                                          )
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            _value = value;
                                          });
                                          AudioService.setSpeed(_value);
                                        }),
                                  ),
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              Row(
                                children: [
                                  rewindButton(),
                                  if (playing) pauseButton() else playButton(),
                                  stopButton(),
                                  fastForwardButton(),

                                  //IconButton(onPressed: AudioService.setSpeed(10),),
                                ],
                              ),
                              Spacer(),
                              IconButton(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.04,
                                    right: MediaQuery.of(context).size.width *
                                        0.04),
                                icon: Icon(Icons.share),
                                onPressed: () {},
                              ),
                            ],
                          )
                        ],
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// Encapsulate all the different data we're interested in into a single
  /// stream so we don't have to nest StreamBuilders.
  Stream<ScreenState> get _screenStateStream =>
      Rx.combineLatest3<List<MediaItem>, MediaItem, PlaybackState, ScreenState>(
          AudioService.queueStream,
          AudioService.currentMediaItemStream,
          AudioService.playbackStateStream,
          (queue, mediaItem, playbackState) =>
              ScreenState(queue, mediaItem, playbackState));

  FlatButton audioPlayerButton(String appBarTitle) => startButton(
        'Start Predica',
        () async {
          await AudioService.start(
            backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
            androidNotificationChannelName: appBarTitle,
            // Enable this if you want the Android service to exit the foreground state on pause.
            //androidStopForegroundOnPause: true,
            androidNotificationColor: 0xFF2196f3,
            androidNotificationIcon: 'mipmap/ic_launcher',
            androidEnableQueue: true,
          );
        },
      );

  FlatButton startButton(String label, VoidCallback onPressed) => FlatButton(
        child: Container(
          height: 50,
          width: 50,
          child: Image.asset(
            'assets/asset-play-button.png',
            fit: BoxFit.contain,
          ),
        ),
        onPressed: onPressed,
        // color: Colors.black,
      );
  // /Image.asset('assets/asset-play-button.png'),
  /*
        Container(
                      height: 50,
                      width: 50,
                      child: Ink.image(
                        image: AssetImage('assets/asset-pdf.png'),
                        fit: BoxFit.contain,
                        child: InkWell(
                          onTap: launchPdf,
                        ),
                      ),
                    ),
      */

  IconButton playButton() => IconButton(
        icon: Icon(Icons.play_arrow),
        iconSize: MediaQuery.of(context).size.width * 0.14,
        onPressed: AudioService.play,
      );

  IconButton pauseButton() => IconButton(
        icon: Icon(Icons.pause),
        iconSize: MediaQuery.of(context).size.width * 0.14,
        onPressed: AudioService.pause,
      );

  IconButton stopButton() => IconButton(
        icon: Icon(Icons.stop),
        iconSize: MediaQuery.of(context).size.width * 0.1,
        onPressed: AudioService.stop,
      );

  IconButton fastForwardButton() => IconButton(
        icon: Icon(Icons.fast_forward),
        iconSize: MediaQuery.of(context).size.width * 0.09,
        onPressed: AudioService.fastForward,
      );

  IconButton rewindButton() => IconButton(
        icon: Icon(Icons.fast_rewind),
        iconSize: MediaQuery.of(context).size.width * 0.09,
        onPressed: AudioService.rewind,
      );

  Widget positionIndicator(MediaItem mediaItem, PlaybackState state) {
    double seekPos;
    return mediaItem == null
        ? CircularProgressIndicator()
        : StreamBuilder(
            stream: Rx.combineLatest2<double, double, double>(
                _dragPositionSubject.stream,
                Stream.periodic(Duration(milliseconds: 200)),
                (dragPosition, _) => dragPosition),
            builder: (context, snapshot) {
              double position = snapshot.data ??
                  state.currentPosition.inMilliseconds.toDouble();

              double duration = mediaItem?.duration?.inMilliseconds?.toDouble();

              return Column(
                children: [
                  if (duration != null)
                    Row(
                      children: [
                        Container(
                            padding: EdgeInsets.only(left: 5),
                            child: Text("${format(state.currentPosition)}")),
                        Spacer(),
                        Container(
                            padding: EdgeInsets.only(right: 5),
                            child: Text("${format(mediaItem.duration)}")),
                      ],
                    ),
                  Theme(
                    data: Theme.of(context).copyWith(
                        accentTextTheme: TextTheme(
                            bodyText2: TextStyle(color: Colors.white))),
                    child: Container(
                      height: 20,
                      child: Slider(
                        activeColor: Colors.black,
                        min: 0.0,
                        max: duration,
                        value: seekPos ?? max(0.0, min(position, duration)),
                        onChanged: (value) {
                          _dragPositionSubject.add(value);
                        },
                        onChangeEnd: (value) {
                          AudioService.seekTo(
                              Duration(milliseconds: value.toInt()));
                          // Due to a delay in platform channel communication, there is
                          // a brief moment after releasing the Slider thumb before the
                          // new position is broadcast from the platform side. This
                          // hack is to hold onto seekPos until the next state update
                          // comes through.
                          // TODO: Improve this code.
                          seekPos = value;
                          _dragPositionSubject.add(null);
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          );
  }
}

format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

class ScreenState {
  final List<MediaItem> queue;
  final MediaItem mediaItem;
  final PlaybackState playbackState;

  ScreenState(this.queue, this.mediaItem, this.playbackState);
}

// NOTE: Your entrypoint MUST be a top-level function.
void _audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

/// This task defines logic for playing a list of podcast episodes.
class AudioPlayerTask extends BackgroundAudioTask {
  final _mediaLibrary = MediaLibrary();
  AudioPlayer _player = new AudioPlayer();
  AudioProcessingState _skipState;
  bool _interrupted = false;
  StreamSubscription<PlaybackEvent> _eventSubscription;

  List<MediaItem> get queue => _mediaLibrary.items;
  int get index => _player.currentIndex;
  MediaItem get mediaItem => index == null ? null : queue[index];

  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    // Broadcast media item changes.
    _player.currentIndexStream.listen((index) {
      if (index != null) AudioServiceBackground.setMediaItem(queue[index]);
    });
    // Propagate all events from the audio player to AudioService clients.
    _eventSubscription = _player.playbackEventStream.listen((event) {
      _broadcastState();
    });
    // Special processing for state transitions.
    _player.processingStateStream.listen((state) {
      switch (state) {
        case ProcessingState.completed:
          // In this example, the service stops when reaching the end.
          onStop();
          break;
        case ProcessingState.ready:
          // If we just came from skipping between tracks, clear the skip
          // state now that we're ready to play.
          _skipState = null;
          break;
        default:
          break;
      }
    });

    // Load and broadcast the queue
    AudioServiceBackground.setQueue(queue);
    try {
      await _player.load(ConcatenatingAudioSource(
        children:
            queue.map((item) => AudioSource.uri(Uri.parse(item.id))).toList(),
      ));
      // In this example, we automatically start playing on start.
      onPlay();
    } catch (e) {
      print("Error: $e");
      onStop();
    }
  }

  @override
  Future<void> onPlay() => _player.play();

  @override
  Future<void> onPause() => _player.pause();

  @override
  Future<void> onSeekTo(Duration position) => _player.seek(position);

  @override
  void onSetSpeed(double speed) {
    _player.setSpeed(speed);
  }

  @override
  Future<void> onFastForward() => _seekRelative(fastForwardInterval);

  @override
  Future<void> onRewind() => _seekRelative(-rewindInterval);

  @override
  Future<void> onSeekForward(bool begin) async => null;

  @override
  Future<void> onSeekBackward(bool begin) async => null;

  @override
  Future<void> onAudioFocusLost(AudioInterruption interruption) async {
    // We override the default behaviour to duck when appropriate.
    // First, remember if we were playing when the interruption occurred.
    if (_player.playing) _interrupted = true;
    // If another app wants to take over the audio focus, we either pause (e.g.
    // during a phonecall) or duck (e.g. if Maps Navigator starts speaking).
    if (interruption == AudioInterruption.temporaryDuck) {
      _player.setVolume(0.5);
    } else {
      onPause();
    }
  }

  @override
  Future<void> onAudioFocusGained(AudioInterruption interruption) async {
    // Restore normal playback depending on whether we paused or ducked.
    switch (interruption) {
      case AudioInterruption.temporaryPause:
        // Resume playback again. But only if we *were* originally playing at
        // the time the phone call came through. If we were paused when the
        // phone call came, we shouldn't suddenly start playing when they hang
        // up.
        if (!_player.playing && _interrupted) onPlay();
        break;
      case AudioInterruption.temporaryDuck:
        // Resume normal volume after a duck.
        _player.setVolume(1.0);
        break;
      default:
        break;
    }
    _interrupted = false;
  }

  @override
  Future<void> onStop() async {
    await _player.pause();
    await _player.dispose();
    _eventSubscription.cancel();
    // It is important to wait for this state to be broadcast before we shut
    // down the task. If we don't, the background task will be destroyed before
    // the message gets sent to the UI.
    await _broadcastState();
    // Shut down this task
    await super.onStop();
  }

  /// Jumps away from the current position by [offset].
  Future<void> _seekRelative(Duration offset) async {
    var newPosition = _player.position + offset;
    // Make sure we don't jump out of bounds.
    if (newPosition < Duration.zero) newPosition = Duration.zero;
    if (newPosition > mediaItem.duration) newPosition = mediaItem.duration;
    // Perform the jump via a seek.
    await _player.seek(newPosition);
  }

  /// Begins or stops a continuous seek in [direction]. After it begins it will
  /// continue seeking forward or backward by 10 seconds within the audio, at
  /// intervals of 1 second in app time.

  /// Broadcasts the current state to all clients.
  /// for notification control
  Future<void> _broadcastState() async {
    await AudioServiceBackground.setState(
      controls: [
        MediaControl.rewind,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: [
        //MediaAction.seekTo,
        // MediaAction.seekForward,
        // MediaAction.seekBackward,
      ],
      processingState: _getProcessingState(),
      playing: _player.playing,
      position: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
    );
  }

  /// Maps just_audio's processing state into into audio_service's playing
  /// state. If we are in the middle of a skip, we use [_skipState] instead.
  AudioProcessingState _getProcessingState() {
    if (_skipState != null) return _skipState;
    switch (_player.processingState) {
      case ProcessingState.none:
        return AudioProcessingState.stopped;
      case ProcessingState.loading:
        return AudioProcessingState.connecting;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
      default:
        throw Exception("Invalid state: ${_player.processingState}");
    }
  }
}

/// Provides access to a library of media items. In your app, this could come
/// from a database or web service.
class MediaLibrary {
  final _items = <MediaItem>[
    // MediaItem(
    //   id: "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3",
    //   album: "Science Friday",
    //   title: "A Salute To Head-Scratching Science",
    //   artist: "Science Friday and WNYC Studios",
    //   duration: Duration(milliseconds: 5739820),
    //   artUri:
    //       "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
    // ),
    MediaItem(
      id: 'https://firebasestorage.googleapis.com/v0/b/harvestapp-24d89.appspot.com/o/Songs%2FDansul%20conjugal%2FCe%20conteaza%20cu%20adevarat%20in%20familie.mp3?alt=media&token=900edb1a-518f-47ea-a1ec-39b6b9b838f0',
      album: 'Dansul conjugal',
      title: 'De la basm la realitate',
      duration: Duration(minutes: 59),
      artUri:
          'https://harvestbucuresti.ro/wp-content/uploads/2020/07/Grafica-Serie-Dansul-Conjugal-SD.jpg',
    ),
  ];

  List<MediaItem> get items => _items;
}

// NOTE: Your entrypoint MUST be a top-level function.
// void _textToSpeechTaskEntrypoint() async {
//   AudioServiceBackground.run(() => TextPlayerTask());
// }

/// This task defines logic for speaking a sequence of numbers using
/// text-to-speech.

/// An object that performs interruptable sleep.
