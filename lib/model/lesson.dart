import 'package:flutter/cupertino.dart';

enum AlgorithmType {
  pathFinding,
  proofOfConcept
}

enum AlgorithmTemplate {
  graph,
  maze
}

class Lesson {
  // more information and bits where information is stored
  int additionalInformation;
  final int askForDirection = 1;
  final int askForNodes = 2;
  final int askForEdges = 4;
  final int negativeWeights = 8;

  // details on simulation and where information is stored
  int simulationDetails;
  final int weightLocation = 1;
  final int weightsOnNodes = 2;
  final int weightsOnEdges = 4;

  final String title;
  String level;
  double indicatorValue;
  String complexity;
  String complexityDetails;
  Icon icon;
  String usages;
  String content;
  AlgorithmType algorithmType;
  AlgorithmTemplate algorithmTemplate;

  bool directed = true;
  double nodes = 2.0;
  double edges = 1.0;

  Lesson(
      {this.title,
      this.level,
      this.indicatorValue,
      this.complexity,
      this.complexityDetails,
      this.icon,
      this.usages,
      this.simulationDetails,
      this.additionalInformation,
      this.content,
      this.algorithmType,
      this.algorithmTemplate});

  double getSortingOrder() {
    return indicatorValue;
  }

}
