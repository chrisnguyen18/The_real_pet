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

  final String catImageUrl = 'https://www.vhv.rs/dpng/d/28-287493_orange-cat-png-transparent-png.png';

  // temporary holder for the text input
  String _tempName = '';

  // Color based on happiness
  Color _moodColor() {
    if (happinessLevel > 70) return Colors.green;
    if (happinessLevel >= 30) return Colors.yellow;
    return Colors.red;
  }

  // NEW: text label for mood
  String _moodLabel() {
    if (happinessLevel > 70) return 'Happy';
    if (happinessLevel >= 30) return 'Neutral';
    return 'Unhappy';
  }

  // NEW: emoji for mood
  String _moodEmoji() {
    if (happinessLevel > 70) return '😀';
    if (happinessLevel >= 30) return '😐';
    return '😞';
  }

  // simple handler to confirm the name
  void _setPetName() {
    final name = _tempName.trim();
    if (name.isNotEmpty) {
      setState(() {
        petName = name;
      });
    }
  }

  void _playWithPet() {
    setState(() {
      happinessLevel += 10;
      _updateHunger();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel -= 10;
      _updateHappiness();
    });
  }

  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel -= 20;
    } else {
      happinessLevel += 10;
    }
  }

  void _updateHunger() {
    setState(() {
      hungerLevel += 5;
      if (hungerLevel > 100) {
        hungerLevel = 100;
        happinessLevel -= 20;
      }
    });
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
