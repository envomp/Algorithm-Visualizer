import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum AlgorithmType { all, pathFinding, proofOfConcept }

class AlgorithmIcon {
  static IconData getAlgorithmIcon(AlgorithmType algo) {
    switch (algo) {
      case AlgorithmType.all:
        return Icons.all_inclusive;
      case AlgorithmType.pathFinding:
        return Icons.gps_fixed;
      case AlgorithmType.proofOfConcept:
        return Icons.work;
    }
    return Icons.add;
  }
}

class AlgorithmToString {
  static String getAlgorithmToString(int algo) {
    switch (algo) {
      case 0:
        return 'All algorithms';
      case 1:
        return 'Pathfinding algorithms';
        break;
      case 2:
        return 'Proof of concept algorithms';
        break;
    }
    return 'Hi mom!';
  }
}

enum AlgorithmTemplate { graph, maze }

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
  final int directed = 8;
  final int stepByStep = 16;

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
  String stateDescription = '';
  Function setState;

  double nodes = 2.0;
  double edges = 1.0;

  Lesson({this.title, this.level, this.indicatorValue, this.complexity, this.complexityDetails, this.icon, this.usages, this.simulationDetails, this.additionalInformation, this.content, this.algorithmType, this.algorithmTemplate});

  double getSortingOrder() {
    return indicatorValue;
  }
}
