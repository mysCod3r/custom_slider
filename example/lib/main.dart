import 'package:custom_slider/custom_slider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Slider',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const MyHomePage(title: 'Flutter Custom Slider'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int a = 1;
  int b = 1;
  int c = 1;
  int d = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              '$a\t$b\t$c\t$d',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            CustomSlider(
              borderNameOrPath: "assets/svg/rectangle.svg",
              maxValue: 4,
              minValue: 0,
              onChanged: (p0) {
                setState(() {
                  a = p0.round();
                });
              },
              nameOrPath: "hwa",
              width: 64,
              // size: const Size(24, 24),
            ),
            CustomSlider(
              maxValue: 10,
              minValue: 0,
              onChanged: (p0) {
                setState(() {
                  b = p0.round();
                });
              },
              nameOrPath: "assets/svg/star.svg",
              width: 32,
              // size: const Size(25, 25),
            ),
            CustomSlider(
              maxValue: 6,
              minValue: 0,
              onChanged: (p0) {
                setState(() {
                  c = p0.round();
                });
              },
              nameOrPath: "assets/svg/heart.svg",
              width: 50,
              padding: const EdgeInsets.all(1),
              // size: const Size(32, 42),
            ),
            CustomSlider(
              borderNameOrPath: "rectangle",
              maxValue: 4,
              minValue: 0,
              onChanged: (p0) {
                setState(() {
                  d = p0.round();
                });
              },
              nameOrPath: "assets/svg/thumb-up.svg",
              width: 48,
              padding: const EdgeInsets.all(8),
              // size: const Size(70, 70),
            ),
          ],
        ),
      ),
    );
  }
}
