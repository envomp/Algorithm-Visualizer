import 'dart:math';

import 'package:AlgorithmVisualizer/model/lesson.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'algorithms/templateGenerator/Graph.dart';
import 'algorithms/templateGenerator/template_simulation_executor.dart';

final Random rnd = new Random();
enum States { drawNodes, drawConnections, algorithm, finisher }

class SimulationAlgorithm extends BaseGame {
  final Lesson lesson;
  TemplateSimulationExecutor abstractSimulationExecutor;
  ScrollController controller;

  SimulationAlgorithm(this.lesson) {
    switch (lesson.algorithmTemplate) {
      case AlgorithmTemplate.graph:
        abstractSimulationExecutor =
            new Graph(lesson) as TemplateSimulationExecutor;
        break;
      case AlgorithmTemplate.maze:
        // TODO: Handle this case.
        break;
    }

    Flame.util.addGestureRecognizer(createDragRecognizer());
    Flame.util.addGestureRecognizer(createTapRecognizer());
  }

  GestureRecognizer createDragRecognizer() {
    return new ImmediateMultiDragGestureRecognizer()
      ..onStart = (Offset position) => this.handleDrag(position);
  }

  TapGestureRecognizer createTapRecognizer() {
    return new TapGestureRecognizer()
      ..onTapUp =
          (TapUpDetails details) => this.handleTap(details.globalPosition);
  }

  @override
  void render(Canvas canvas) {
    abstractSimulationExecutor.render(canvas, size);
  }

  @override
  void update(double t) {
    switch (lesson.algorithmTemplate) {
      case AlgorithmTemplate.graph:
        abstractSimulationExecutor.update(t, size);
        break;
      case AlgorithmTemplate.maze:
        // TODO: Handle this case.
        break;
    }
  }

  handleDrag(Offset position) {}

  handleTap(Offset globalPosition) {
    switch (lesson.algorithmTemplate) {
      case AlgorithmTemplate.graph:
        abstractSimulationExecutor.handleTap(globalPosition, controller.offset);
        break;
      case AlgorithmTemplate.maze:
        // TODO: Handle this case.
        break;
    }
  }
}

// https://mathematica.stackexchange.com/questions/11632/how-to-generate-a-random-tree
