//sudo code version
// find a picture
// 2 if statemnts
// set threshold

//Mood
//Same if else staments
//happy, neutral, pissed

//Customize
//controller, text, etc
//name pet, and button

import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  int energyLevel = 50;

  final String catImageUrl = 'https://www.vhv.rs/dpng/d/28-287493_orange-cat-png-transparent-png.png';

  // temporary holder for the text input
  String _tempName = '';

  // timer to auto-increase hunger over time
  Timer? _hungerTimer;

  //timer/flags for win/loss
  Timer? _winTimer;  
  bool _winShown = false;
  bool _lossShown = false;

  // Color based on happiness
  Color _moodColor() {
    if (happinessLevel > 70) return Colors.green;
    if (happinessLevel >= 30) return Colors.yellow;
    return Colors.red;
  }

  // text label for mood
  String _moodLabel() {
    if (happinessLevel > 70) return 'Happy';
    if (happinessLevel >= 30) return 'Neutral';
    return 'Unhappy';
  }

  // emoji for mood
  String _moodEmoji() {
    if (happinessLevel > 70) return '😀';
    if (happinessLevel >= 30) return '😐';
    return '😞';
  }

  //start/stop the periodic hunger increase
  @override
  void initState() {
    super.initState();
    _hungerTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _updateHunger(); // every 30s, hunger rises (and may affect happiness)
    });
  }

  @override
  void dispose() {
    _hungerTimer?.cancel();
    _winTimer?.cancel();
    super.dispose();
  }

  // simple handler to confirm the name
  void _setPetName() {
    final name = _tempName.trim();
    if (name.isNotEmpty) {
      setState(() {
        petName = name;
      });
      _checkWinLoss();
    }
  }

  void _playWithPet() {
    setState(() {
      happinessLevel += 10;
      //Plating uses energy
      energyLevel = (energyLevel - 5).clamp(0, 100).toInt();
      _updateHunger();
    });
    _checkWinLoss();
  }

  void _feedPet() {
    setState(() {
      hungerLevel -= 10;
      //Feeding restores a little bit of energy
      energyLevel = (energyLevel + 5).clamp(0, 100).toInt();
      _updateHappiness();
    });
    _checkWinLoss();
  }

  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel -= 20;
    } else {
      happinessLevel += 10;
    }
    _checkWinLoss();
  }

  void _updateHunger() {
    setState(() {
      hungerLevel += 5;
      if (hungerLevel > 100) {
        hungerLevel = 100;
        happinessLevel -= 20;
      }
    });
    _checkWinLoss();
  }

  // central win/loss checker (call after any change)
  void _checkWinLoss() {
    if (!mounted) return;

    // LOSS
    if (!_lossShown && hungerLevel >= 100 && happinessLevel <= 10) {
      _lossShown = true;
      _winTimer?.cancel();
      _hungerTimer?.cancel();
      _showEndDialog(title: 'Game Over', message: 'Your pet became too hungry and unhappy.');
      return;
    }

    // WIN
    if (happinessLevel > 80) {
      _winTimer ??= Timer(const Duration(minutes: 3), () {
        if (!mounted) return;
        if (!_winShown && !_lossShown && happinessLevel > 80) {
          _winShown = true;
          _hungerTimer?.cancel();
          _showEndDialog(title: 'You Win!', message: 'You kept your pet happy for 3 minutes!');
        }
      });
    } else {
      // happiness dropped to 80 or below -> cancel any running win timer
      _winTimer?.cancel();
      _winTimer = null;
    }
  }

  // helper to show end-game dialog
  void _showEndDialog({required String title, required String message}) {
    if (!mounted) return;
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // reset to play again
              setState(() {
                happinessLevel = 50;
                hungerLevel = 50;
                energyLevel = 50;
              });
              _lossShown = false;
              _winShown = false;
              _hungerTimer ??= Timer.periodic(const Duration(seconds: 30), (_) => _updateHunger());
              _winTimer?.cancel();
              _winTimer = null;
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    _moodColor(),
                    BlendMode.modulate,
                  ),
                  child: Image.network(
                    catImageUrl,
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 16),
                // Mood text + emoji
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mood: ${_moodLabel()}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: _moodColor(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '',
                      style: TextStyle(fontSize: 6),
                    ),
                    Text(
                      _moodEmoji(),
                      style: const TextStyle(fontSize: 36),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // text field + button to set the name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TextField(
                onChanged: (value) => _tempName = value,
                decoration: const InputDecoration(
                  labelText: 'Enter pet name',
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _setPetName,
              child: const Text('Confirm Name'),
            ),
            const SizedBox(height: 24.0),

            Text(
              'Name: $petName',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Happiness Level: $happinessLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Hunger Level: $hungerLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            //Energy text + progress bar
            const SizedBox(height: 16.0),
            Text('Energy: $energyLevel', style: const TextStyle(fontSize: 20.0)),
            const SizedBox(height: 6.0),
            SizedBox(
              width: 240,
              child: LinearProgressIndicator(
                value: (energyLevel.clamp(0, 100)) / 100,
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}
//Tester
