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
    this.borderNameOrPath,
    required this.width,
  });

  final String nameOrPath;
  final String? borderNameOrPath;
  final double maxValue;
  final double minValue;
  final double width;

  final EdgeInsets padding;
  final void Function(double) onChanged;

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  final StreamController<double> _streamController = StreamController<double>();
  final double _sliderValue = 1.0;
  late final String _path;
  late final String _borderPath;

  @override
  void initState() {
    _path = nameToPath(widget.nameOrPath);
    if (widget.borderNameOrPath != null) {
      _borderPath = nameToPath(widget.borderNameOrPath!);
    }
    super.initState();
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
      width: widget.width * widget.maxValue + widget.padding.horizontal,
      height: widget.width,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          (widget.borderNameOrPath != null)
              ? SvgPicture.asset(
                  _borderPath,
                  fit: BoxFit.fill,
                )
              : const Center(),
          _sliderItem(
            path: widget.nameOrPath,
            width: widget.width,
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

  StreamBuilder<double> _sliderItem({
    required StreamController<double> streamController,
    required double sliderValue,
    required String path,
    required double width,
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
                width: width,
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
