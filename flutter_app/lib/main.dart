import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app/asset_helper.dart';
import 'package:flutter_app/juce_lib/juce_lib.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // JuceLib().juceEnableLogs();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PlayerPage(),
    );
  }
}

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  PlayerPageState createState() => PlayerPageState();
}

class PlayerPageState extends State<PlayerPage> {
  final player = JuceMixPlayer();
  double progress = 0.0;
  bool isSliderEditing = false;
  bool isPlaying = false;

  JuceMixPlayerState state = JuceMixPlayerState.IDLE;

  @override
  void initState() {
    super.initState();

    player.setStateUpdateHandler((state) {
      setState(() => this.state = state);
    });

    player.setProgressHandler((progress) {
      if (!isSliderEditing) {
        setState(() => this.progress = progress);
      }
    });

    player.setErrorHandler((error) {
      log('Error: $error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audio Player')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Progress: ${(progress * player.getDuration()).toStringAsFixed(2)} / ${player.getDuration().toStringAsFixed(2)}'),
            Slider(
              value: progress,
              onChanged: (value) {
                setState(() => progress = value);
              },
              onChangeStart: (_) {
                isSliderEditing = true;
              },
              onChangeEnd: (value) {
                isSliderEditing = false;
                player.seek(value.toDouble());
              },
            ),
            // display the current state
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('State: $state'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    player.togglePlayPause();

                    setState(() => isPlaying = !isPlaying);
                  },
                  child: Text(isPlaying ? 'Pause' : 'Play'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () async {
                    final path = await AssetHelper.extractAsset('assets/media/music.mp3');
                    player.setFile(path);
                  },
                  child: const Text('Set File'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
