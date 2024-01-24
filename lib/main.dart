// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:js' as js;

import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'colors.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  Color _value = Colors.white;
  final _debouncer = Debouncer(milliseconds: 500);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, dimens) => Material(
        child: Center(
          child: ColorPicker(
            pickerColor: _value,
            colorPickerWidth: dimens.maxWidth / 2,
            onColorChanged: (val) {
              if (mounted) {
                setState(() {
                  _value = val;
                });
              }
              _debouncer.run(() {
                final color = UIColors.colorToString(val.value);
                if (kDebugMode) {
                  print('Color -> $color');
                }
                js.context.callMethod('changeColor', ['$color']);
                js.context.callMethod('changeCode', ['Test123']);
              });
            },
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.add),
        //   onPressed: () {
        //     js.context.callMethod('changeColor', ['#3aa757']);
        //   },
        // ),
      ),
    );
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
