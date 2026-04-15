import 'package:flutter/material.dart';
import 'api_functions.dart';

class StressPage extends StatefulWidget {
  const StressPage({super.key});

  @override
  State<StressPage> createState() => _StressPageState();
}

class _StressPageState extends State<StressPage> {
  Future<String>? futureStress;

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = '2026-03-16';
  }

  @override
  void dispose() {
    _dateController.dispose();
    _scoreController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitStress() {
    final date = _dateController.text.trim();
    final scoreText = _scoreController.text.trim();
    final notes = _notesController.text.trim();

    if (date.isEmpty || scoreText.isEmpty) {
      setState(() {
        futureStress =
            Future.value('Please enter both date and stress score.');
      });
      return;
    }

    final score = int.tryParse(scoreText);
    if (score == null) {
      setState(() {
        futureStress = Future.value('Stress score must be a number.');
      });
      return;
    }

    if (score < 1 || score > 10) {
      setState(() {
        futureStress =
            Future.value('Stress score must be between 1 and 10.');
      });
      return;
    }

    setState(() {
      futureStress = saveStress(date, score, notes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 60),

            const Text(
              'Daily Stress Check-in',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _dateController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Date',
                  hintText: 'yyyy-mm-dd',
                ),
              ),
            ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _scoreController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Stress Score (1–10)',
                ),
              ),
            ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _notesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Notes (optional)',
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 60,
              width: 320,
              child: ElevatedButton(
                onPressed: _submitStress,
                child: const Text(
                  'Save Stress Data',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(20),
              child: FutureBuilder<String>(
                future: futureStress,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    );
                  } else if (snapshot.hasData) {
                    return Text(
                      snapshot.data!,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                      ),
                    );
                  } else {
                    return const Text('No submission yet.');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}