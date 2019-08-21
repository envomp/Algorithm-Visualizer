import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlgorithmTypes {
	final IconData _animatedIconData;
	final String _algorithmToString;

	const AlgorithmTypes._internal(this._animatedIconData, this._algorithmToString);

	IconData getIcon() {
		return _animatedIconData;
	}

	String getAlgorithmToString() {
		return _algorithmToString;
	}

	static const all = const AlgorithmTypes._internal(Icons.all_inclusive, 'All algorithms');
	static const pathFinding = const AlgorithmTypes._internal(Icons.grain, 'Pathfinding algorithms');
	static const proofOfConcept = const AlgorithmTypes._internal(Icons.wb_incandescent, 'Proof of concept algorithms');

	static const values = [all, pathFinding, proofOfConcept];
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
  final String level;
  final double indicatorValue;
  final String complexity;
  final String complexityDetails;
  final Icon icon;
  final String usages;
  final String content;
  final AlgorithmTypes algorithmType;
  final AlgorithmTemplate algorithmTemplate;
  String stateDescription = '';
  Function setState;
  double screenSize = 300000;

  double nodes = 2.0;
  double edges = 1.0;

  Lesson({this.title, this.level, this.indicatorValue, this.complexity, this.complexityDetails, this.icon, this.usages, this.simulationDetails, this.additionalInformation, this.content, this.algorithmType, this.algorithmTemplate});

  double getSortingOrder() {
    return indicatorValue;
  }
}
