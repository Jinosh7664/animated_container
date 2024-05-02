import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: GradientBox()),
    );
  }
}

class GradientBox extends StatefulWidget {
  const GradientBox({super.key});

  @override
  State<GradientBox> createState() => _GradientBoxState();
}

class _GradientBoxState extends State<GradientBox>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  var staticColor = [
    const Color(0xFF205639),
    const Color(0xFF08150E),
    const Color(0xFF0A1B12),
    const Color(0xFF205639),
  ];

  final stops = [0.0554, 0.2177, 0.66, 0.9391];
  var color = <Color>[];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    );
    _animation = IntTween(begin: 0, end: 99).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.repeat(reverse: true);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _set();
    });
  }

  void _set() {
    setState(() {
      color = interpolateColors(staticColor, stops, 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (color.length < 100) {
      return const SizedBox();
    }
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        var cl1 = [
          color.last,
          ...color.sublist(
            0,
            color.length - 1,
          )
        ];
        color = cl1;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: color,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        );
      },
    );
  }
}

List<Color> interpolateColors(
    List<Color> colors, List<double> stops, int numberOfSteps) {
  if (colors.length != stops.length) {
    throw ArgumentError("The number of colors and stops must be the same.");
  }

  List<Color> interpolatedColors = [];
  List<double> interpolatedStops = [];

  for (int i = 0; i < colors.length - 1; i++) {
    Color startColor = colors[i];
    Color endColor = colors[i + 1];
    double startStop = stops[i];
    double endStop = stops[i + 1];

    double stepSize = (endStop - startStop) / (numberOfSteps - 1);

    for (int j = 0; j < numberOfSteps; j++) {
      double ratio = j * stepSize / (endStop - startStop);
      double currentStop = startStop + j * stepSize;

      Color interpolatedColor = Color.lerp(startColor, endColor, ratio)!;
      interpolatedColors.add(interpolatedColor);
      interpolatedStops.add(currentStop);
    }
  }

  // Add the last color and stop
  interpolatedColors.add(colors.last);
  interpolatedStops.add(stops.last);

  return interpolatedColors;
}
