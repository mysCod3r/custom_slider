import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'extensions/path_extension.dart';

class CustomSlider extends StatefulWidget {
  const CustomSlider({
    super.key,
    required this.maxValue,
    required this.minValue,
    required this.onChanged,
    required this.nameOrPath,
    this.padding = EdgeInsets.zero,
    this.size = 32,
    this.showInActive = true,
    this.borderNameOrPath,
  });

  final String nameOrPath;
  final String? borderNameOrPath;
  final double maxValue;
  final double minValue;
  final double size;
  final bool showInActive;
  final EdgeInsets padding;
  final void Function(double) onChanged;

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  final StreamController<double> _streamController = StreamController<double>();
  final double _sliderValue = 1.0;
  late String _path;
  late String _borderPath;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomSlider oldWidget) {
    if (widget.nameOrPath != oldWidget.nameOrPath || widget.borderNameOrPath != oldWidget.borderNameOrPath) {
      _init();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _init() {
    _path = nameToPath(widget.nameOrPath);
    if (widget.borderNameOrPath != null) {
      _borderPath = nameToPath(widget.borderNameOrPath!);
    }
  }

  String nameToPath(String name) {
    if (name.contains("/")) {
      return name;
    }
    return name.svgFromAssets;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size * widget.maxValue + widget.padding.horizontal,
      height: widget.size,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          (widget.borderNameOrPath != null)
              ? SvgPicture.asset(
                  _borderPath,
                  fit: BoxFit.fill,
                )
              : const Center(),
          widget.showInActive ? _showInActive(max: widget.maxValue, size: widget.size, padding: widget.padding) : const Center(),
          _sliderItem(
            path: _path,
            size: widget.size,
            sliderValue: _sliderValue,
            streamController: _streamController,
            padding: widget.padding,
          ),
          _transparentSlider(
            maxValue: widget.maxValue,
            minValue: widget.minValue,
            value: _sliderValue,
            onChanged: widget.onChanged,
            streamController: _streamController,
          ),
        ],
      ),
    );
  }

  Widget _transparentSlider({
    required void Function(double) onChanged,
    required StreamController<double> streamController,
    required double value,
    required double maxValue,
    required double minValue,
  }) {
    return Opacity(
      opacity: 0.0,
      child: SliderTheme(
        data: SliderThemeData(
          trackShape: CustomTrackShape(),
        ),
        child: Slider(
          value: value,
          max: maxValue,
          min: minValue,
          onChanged: (value) {
            setState(() {
              value = value;
              streamController.add(value);
              onChanged(value);
            });
          },
        ),
      ),
    );
  }

  Widget _showInActive({required double max, required double size, required EdgeInsets padding}) {
    return Padding(
      padding: padding,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(
            max.round(),
            (index) {
              return Opacity(
                opacity: 0.3,
                child: SvgPicture.asset(
                  _path,
                  width: size,
                ),
              );
            },
          )),
    );
  }

  StreamBuilder<double> _sliderItem({
    required StreamController<double> streamController,
    required double sliderValue,
    required String path,
    required double size,
    required EdgeInsets padding,
  }) {
    return StreamBuilder<double>(
      stream: streamController.stream,
      initialData: sliderValue,
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
        int itemCount = snapshot.data!.round();
        return Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
              itemCount,
              (index) => SvgPicture.asset(
                _path,
                width: size,
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
