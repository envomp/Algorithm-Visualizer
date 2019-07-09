import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Controllers {
  final scrollController = ScrollControl();
  final gestureController = GestureControl();
  final pageController =
      PageController(keepPage: false, viewportFraction: 0.98);
}

class ScrollControl extends ScrollController {}

class GestureControl extends TapGestureRecognizer {}

class PageControl extends PageController {}
