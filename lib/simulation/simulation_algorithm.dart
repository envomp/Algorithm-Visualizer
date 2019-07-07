import 'dart:math';

import 'package:AlgorithmVisualizer/model/lesson.dart';
import 'package:flame/game.dart';
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
}

// https://mathematica.stackexchange.com/questions/11632/how-to-generate-a-random-tree
