import 'dart:async';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:video_player/video_player.dart';

class Screen2 extends ConsumerStatefulWidget {
  final String text;
  final String id;
  const Screen2(this.text, this.id, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _Screen2State();
}

class _Screen2State extends ConsumerState<Screen2> {
  final TextEditingController reasonController = TextEditingController();
  final record = AudioRecorder();
  final audioPlayer = AudioPlayer();
  late final RecorderController recorderController;

  // AUDIO
  String? filePath;
  Timer? timer;
  int seconds = 0;
  bool isRecording = false;
  bool isRecorded = false;
  bool isPlaying = false;

  // VIDEO
  bool isVideoRecorded = false;
  String? videoPath;
  VideoPlayerController? videoController;

  @override
  void initState() {
    super.initState();
    recorderController = RecorderController();
  }

  @override
  void dispose() {
    recorderController.dispose();
    audioPlayer.dispose();
    videoController?.dispose();
    super.dispose();
  }

  // 🎤 AUDIO FUNCTIONS
  Future<void> startRecording() async {
    if (await record.hasPermission()) {
      final dir = await getApplicationDocumentsDirectory();
      final path =
          '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await record.start(RecordConfig(encoder: AudioEncoder.aacLc), path: path);
      recorderController.record(path: path);
      setState(() {
        filePath = path;
        isRecording = true;
        isRecorded = false;
        seconds = 0;
      });

      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() => seconds++);
      });
    }
  }

  Future<void> stopRecording() async {
    await recorderController.stop();
    final path = await record.stop();
    timer?.cancel();

    setState(() {
      filePath = path;
      isRecording = false;
      isRecorded = true;
    });
  }

  Future<void> playRecording() async {
    if (filePath != null && !isPlaying) {
      await audioPlayer.play(DeviceFileSource(filePath!));
      setState(() => isPlaying = true);
      audioPlayer.onPlayerComplete.listen((_) {
        setState(() => isPlaying = false);
      });
    } else if (isPlaying) {
      await stopPlaying();
    }
  }

  Future<void> stopPlaying() async {
    await audioPlayer.stop();
    setState(() => isPlaying = false);
  }

  Future<void> deleteRecording() async {
    if (filePath != null) {
      final file = File(filePath!);
      if (await file.exists()) await file.delete();
    }
    setState(() {
      isRecorded = false;
      filePath = null;
      seconds = 0;
    });
  }

  // 🎥 VIDEO FUNCTIONS
  Future<void> recordVideo() async {
    final picker = ImagePicker();
    final pickedVideo = await picker.pickVideo(source: ImageSource.camera);

    if (pickedVideo != null) {
      setState(() {
        videoPath = pickedVideo.path;
        isVideoRecorded = true;
      });

      videoController = VideoPlayerController.file(File(videoPath!))
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  Future<void> playVideo() async {
    if (videoController != null) {
      if (videoController!.value.isPlaying) {
        await videoController!.pause();
      } else {
        await videoController!.play();
      }
      setState(() {});
    }
  }

  Future<void> deleteVideo() async {
    if (videoPath != null && await File(videoPath!).exists()) {
      await File(videoPath!).delete();
    }
    setState(() {
      isVideoRecorded = false;
      videoPath = null;
      videoController?.dispose();
      videoController = null;
    });
  }

  String formatTime(int sec) {
    final m = sec ~/ 60;
    final s = sec % 60;
    return '${m.toString().padLeft(2, '0')} : ${s.toString().padLeft(2, '0')}';
  }

  String formatVideoTime(int sec) {
    final m = sec ~/ 60;
    final s = sec % 60;
    return '${m.toString().padLeft(2, '0')} : ${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          '02',
                          style: TextStyle(color: Colors.white24),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Why do you want to host with us?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Tell us about your intent and what motivates you to create experience.',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: reasonController,
                          maxLines: 12,
                          maxLength: 600,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            contentPadding: const EdgeInsets.all(16.0),
                            hintStyle: TextStyle(color: Colors.grey.shade700),
                            hintText: '/Start typing here',
                          ),
                        ),
                        const SizedBox(height: 15),

                        //  AUDIO CARD
                        if (isRecording || isRecorded)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (isRecording)
                                  const Icon(Icons.mic, color: Colors.redAccent)
                                else
                                  const Icon(
                                    Icons.audiotrack,
                                    color: Colors.purpleAccent,
                                  ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: isRecording
                                      ? Row(
                                          children: [
                                            AudioWaveforms(
                                              enableGesture: false,
                                              size: const Size(120, 40),
                                              recorderController:
                                                  recorderController,
                                              waveStyle: const WaveStyle(
                                                waveColor: Colors.white,
                                                extendWaveform: true,
                                                showMiddleLine: false,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              formatTime(seconds),
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          'Audio Recorded - ${formatTime(seconds)}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                                Row(
                                  children: [
                                    if (isRecording)
                                      IconButton(
                                        icon: const Icon(
                                          Icons.stop,
                                          color: Colors.redAccent,
                                        ),
                                        onPressed: stopRecording,
                                      )
                                    else ...[
                                      IconButton(
                                        icon: Icon(
                                          isPlaying
                                              ? Icons.stop
                                              : Icons.play_arrow_rounded,
                                          color: Colors.blueAccent,
                                        ),
                                        onPressed: playRecording,
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.pinkAccent,
                                        ),
                                        onPressed: deleteRecording,
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),

                        // VIDEO CARD
                        if (isVideoRecorded)
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child:
                                        videoController != null &&
                                            videoController!.value.isInitialized
                                        ? VideoPlayer(videoController!)
                                        : Icon(
                                            Icons.videocam,
                                            color: Colors.purpleAccent,
                                          ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Video Recorded - ${formatVideoTime(seconds)}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                IconButton(
                                  onPressed: playVideo,
                                  icon: Icon(
                                    videoController != null &&
                                            videoController!.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                IconButton(
                                  onPressed: deleteVideo,
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.pinkAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 10),

                        // BOTTOM BUTTONS
                        Row(
                          children: [
                            if (!isRecorded && !isVideoRecorded)
                              Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      side: const BorderSide(
                                        color: Colors.white12,
                                      ),
                                    ),
                                    onPressed: isRecording
                                        ? stopRecording
                                        : startRecording,
                                    child: Icon(
                                      isRecording ? Icons.stop : Icons.mic_none,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      side: const BorderSide(
                                        color: Colors.white12,
                                      ),
                                    ),
                                    onPressed: recordVideo,
                                    child: const Icon(
                                      Icons.videocam_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 13,
                                  ),
                                  foregroundColor: Colors.white70,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  side: const BorderSide(color: Colors.white24),
                                ),
                                onPressed: () {},
                                child: const Text(
                                  'Next',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
