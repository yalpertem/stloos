import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'shittheyleaveonourstreets',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Ortalanmış başlık
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'shittheyleaveonourstreets',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // Scrollable görseller
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset('assets/image1.jpeg'),
                    const SizedBox(height: 16),
                    Image.asset('assets/image2.jpeg'),
                    const SizedBox(height: 16),
                    Image.asset('assets/image3.jpeg'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
