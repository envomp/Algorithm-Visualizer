import 'dart:ui';

import 'package:AlgorithmVisualizer/model/lesson.dart';
import 'package:flutter/cupertino.dart';

abstract class TemplateSimulationExecutor {
  final Lesson lesson;

  TemplateSimulationExecutor(this.lesson);

  int speedFactor;

  void render(Canvas canvas, Size size);

  void update(double t, Size size);

  handleTap(Offset globalPosition, double offset);
}
