import 'dart:math';

import 'package:AlgorithmVisualizer/controllers/Controllers.dart';
import 'package:AlgorithmVisualizer/formulas.dart';
import 'package:AlgorithmVisualizer/model/lesson.dart';
import 'package:AlgorithmVisualizer/simulation/simulation_algorithm.dart';
import 'package:AlgorithmVisualizer/simulation/simulation_state.dart';
import 'package:flutter/material.dart';

class HomePage extends State<DetailPage> {
  final Lesson lesson;
  final Controllers _controllers;

  HomePage(this.lesson, this._controllers);

  @override
  Widget build(BuildContext context) {
    final levelIndicator = Container(
      child: Container(
		  child: LinearProgressIndicator(backgroundColor: Color.fromRGBO(209, 224, 224, 0.2), value: lesson.indicatorValue, valueColor: AlwaysStoppedAnimation(Colors.green)),
      ),
    );

    final complexityLevel = Container(
      padding: const EdgeInsets.all(7.0),
		decoration: new BoxDecoration(border: new Border.all(color: Colors.white), borderRadius: BorderRadius.circular(5.0)),
      child: new Text(
        lesson.complexity.toString(),
        style: TextStyle(color: Colors.white),
      ),
    );

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 70.0),
        Container(
          width: 90.0,
          child: new Divider(color: Colors.green),
        ),
        SizedBox(height: 10.0),
        Text(
          lesson.title,
          style: TextStyle(color: Colors.white, fontSize: 45.0),
        ),
        SizedBox(height: 30.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(flex: 1, child: levelIndicator),
            Expanded(
                flex: 1,
                child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      lesson.level,
                      style: TextStyle(color: Colors.white),
                    ))),
            Expanded(flex: 1, child: complexityLevel)
          ],
        ),
      ],
    );

    final double bottomTopRelation = 0.35;
    final topContent = Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * bottomTopRelation,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ],
    );

    final bottomContentText = Text(
		"Complexity description:\n\n" + lesson.complexityDetails + "\n\n\nIntroduction:\n\n" + lesson.content + "\n\n\nApplications and generalizations:\n\n" + lesson.usages,
      style: TextStyle(fontSize: 18.0),
    );

    final readButton = Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          onPressed: () {
			  Navigator.push(context, MaterialPageRoute(builder: (context) => GameWrapper(new SimulationAlgorithm(lesson), _controllers)));
          },
          color: Colors.green,
			child: Text("Visual demonstration", style: TextStyle(color: Colors.white)),
        ));

    final directedSwitch = lesson.algorithmTemplate == AlgorithmTemplate.graph && askForInformation(lesson.simulationDetails, lesson.askForDirection)
        ? Container(
            padding: EdgeInsets.fromLTRB(10.0, 32.0, 0.0, 0.0),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
				  Text(getDirectedMessage(), style: TextStyle(color: Colors.black)),
                Switch(
					value: askForInformation(lesson.simulationDetails, lesson.directed),
                  onChanged: (value) {
                    setState(() {
                      changeSimulationDetails(lesson.directed);
                      minMaxEdges();
                    });
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
              ],
            ),
          )
        : Container();

    final weightedEdgesSwitch = lesson.algorithmTemplate == AlgorithmTemplate.graph && askForInformation(lesson.additionalInformation, lesson.weightLocation)
        ? Container(
		padding: EdgeInsets.fromLTRB(10.0, 32.0, 0.0, 0.0),
		width: MediaQuery
			.of(context)
			.size
			.width,
		child: Row(
			mainAxisAlignment: MainAxisAlignment.spaceBetween,
			children: <Widget>[
                Text(getWeightedEdgeMessage(), style: TextStyle(color: Colors.black)),
                Switch(
					value: askForEdgeInformation(),
					onChanged: (value) {
						setState(() {
							if (askForEdgeInformation()) {
								lesson.additionalInformation -= lesson.askForEdges;
							} else {
								lesson.additionalInformation += lesson.askForEdges;
							}
						});
					},
					activeTrackColor: Colors.lightGreenAccent,
					activeColor: Colors.green,
                ),
			],
		),
	)
        : Container();

    final weightedNotification = !askForEdgeInformation() && lesson.algorithmTemplate == AlgorithmTemplate.graph && !askForNodeInformation() && askForInformation(lesson.additionalInformation, lesson.weightLocation)
		? Container(padding: EdgeInsets.fromLTRB(10.0, 32.0, 0.0, 0.0), width: MediaQuery
		.of(context)
		.size
		.width, child: Text("I will find a path with the least nodes on path!", style: TextStyle(color: Colors.black)))
        : Container();

    final weightedNodeSwitch = lesson.algorithmTemplate == AlgorithmTemplate.graph && askForInformation(lesson.additionalInformation, lesson.weightLocation)
        ? Container(
		padding: EdgeInsets.fromLTRB(10.0, 32.0, 0.0, 0.0),
		width: MediaQuery
			.of(context)
			.size
			.width,
		child: Row(
			mainAxisAlignment: MainAxisAlignment.spaceBetween,
			children: <Widget>[
                Text(getWeightedNodeMessage(), style: TextStyle(color: Colors.black)),
                Switch(
					value: askForNodeInformation(),
					onChanged: (value) {
						setState(() {
							if (askForNodeInformation()) {
								lesson.additionalInformation -= lesson.askForNodes;
							} else {
								lesson.additionalInformation += lesson.askForNodes;
							}
						});
					},
					activeTrackColor: Colors.lightGreenAccent,
					activeColor: Colors.green,
                ),
			],
		),
	)
        : Container();

    final numberOfNodesText = lesson.algorithmTemplate == AlgorithmTemplate.graph && askForInformation(lesson.simulationDetails, lesson.askForNodes)
        ? Container(
            padding: EdgeInsets.fromLTRB(10.0, 32.0, 0.0, 0.0),
            width: MediaQuery.of(context).size.width,
		child: Text("Number of nodes:", style: TextStyle(color: Colors.black)),
          )
        : Container();

    final numberOfNodesSlider = lesson.algorithmTemplate == AlgorithmTemplate.graph && askForInformation(lesson.simulationDetails, lesson.askForNodes)
        ? Container(
		padding: EdgeInsets.symmetric(vertical: 16.0),
		width: MediaQuery
			.of(context)
			.size
			.width,
		child: Row(
			mainAxisAlignment: MainAxisAlignment.spaceBetween,
			children: <Widget>[
                Flexible(
					flex: 1,
					child: Slider(
						activeColor: Colors.green,
						min: 2.0,
						max: 100.0,
						divisions: 98,
						onChanged: (value) {
							setState(() => lesson.nodes = value);
							minMaxEdges();
						},
						value: lesson.nodes,
					),
                ),
                Container(
					width: 60.0,
					alignment: Alignment.center,
					child: Text('${lesson.nodes.toInt()}', style: Theme
						.of(context)
						.textTheme
						.display1),
                ),
			],
		))
        : Container();

    final numberOfEdgesText = lesson.algorithmTemplate == AlgorithmTemplate.graph && askForInformation(lesson.simulationDetails, lesson.askForEdges)
        ? Container(
            padding: EdgeInsets.fromLTRB(10.0, 32.0, 0.0, 0.0),
            width: MediaQuery.of(context).size.width,
		child: Text(getEdgesMessage(), style: TextStyle(color: Colors.black)),
          )
        : Container();

    final numberOfEdgesSlider = lesson.algorithmTemplate == AlgorithmTemplate.graph && askForInformation(lesson.simulationDetails, lesson.askForEdges)
        ? Container(
		padding: EdgeInsets.symmetric(vertical: 16.0),
		width: MediaQuery
			.of(context)
			.size
			.width,
		child: Row(
			mainAxisAlignment: MainAxisAlignment.spaceBetween,
			children: <Widget>[
                Flexible(
					flex: 1,
					child: Slider(
						activeColor: Colors.green,
						min: minEdges(),
						max: maxEdges(),
						onChanged: (value) {
							setState(() => lesson.edges = value);
						},
						value: minMaxEdges(),
					),
                ),
                Container(
					width: 80.0,
					alignment: Alignment.center,
					child: Text('${lesson.edges.toInt()}', style: Theme
						.of(context)
						.textTheme
						.display1),
                ),
			],
		))
        : Container();

    final simulationStepSwitch = lesson.algorithmTemplate == AlgorithmTemplate.graph
        ? Container(
		padding: EdgeInsets.symmetric(vertical: 16.0),
		width: MediaQuery
			.of(context)
			.size
			.width,
		child: Row(
			mainAxisAlignment: MainAxisAlignment.spaceBetween,
			children: <Widget>[
                Container(
					child: Text(getStepMessage(), style: TextStyle(color: Colors.black)),
                ),
                Switch(
					value: askForInformation(lesson.simulationDetails, lesson.stepByStep),
					onChanged: (value) {
						setState(() {
							changeSimulationDetails(lesson.stepByStep);
						});
					},
					activeTrackColor: Colors.lightGreenAccent,
					activeColor: Colors.green,
                ),
			],
		))
        : Container();

    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(30.0),
      child: Center(
        child: Column(
          children: <Widget>[
            bottomContentText,
            weightedNodeSwitch,
            weightedEdgesSwitch,
            weightedNotification,
            directedSwitch,
            numberOfNodesText,
            numberOfNodesSlider,
            numberOfEdgesText,
            numberOfEdgesSlider,
            simulationStepSwitch,
            readButton
          ],
        ),
      ),
    );

    return Scaffold(
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[topContent, bottomContent],
          ),
        ],
      ),
    );
  }

  void changeSimulationDetails(int whatToChange) {
    if (askForInformation(lesson.simulationDetails, whatToChange)) {
      lesson.simulationDetails -= whatToChange;
    } else {
      lesson.simulationDetails += whatToChange;
    }
  }

  void changeAdditionalInformation(int whatToChange) {
    if (askForInformation(lesson.additionalInformation, whatToChange)) {
      lesson.additionalInformation -= whatToChange;
    } else {
      lesson.additionalInformation += whatToChange;
    }
  }

  String getStepMessage() {
	  return ((askForInformation(lesson.simulationDetails, lesson.stepByStep)) ? "Step by step simulation: " : "All in one go Simulation: ");
  }

  String getEdgesMessage() {
	  return "Number of edges:" + ((lesson.edges == minEdges()) ? "\t(min edges => always a tree)" : "");
  }

  String getDirectedMessage() {
    if (askForInformation(lesson.simulationDetails, lesson.directed)) {
      return "Directed graph:";
    }
    return "Undirected graph:";
  }

  String getWeightedEdgeMessage() {
    if (askForEdgeInformation()) {
      return "Weights on edges:";
    }
    return "No weights on edges:";
  }

  String getWeightedNodeMessage() {
    if (askForNodeInformation()) {
      return "Weights on nodes:";
    }
    return "No weights on nodes:";
  }

  bool askForEdgeInformation() => lesson.additionalInformation | lesson.askForEdges == lesson.additionalInformation;

  bool askForNodeInformation() => lesson.additionalInformation | lesson.askForNodes == lesson.additionalInformation;

  double minMaxEdges() {
    lesson.edges = max(min(lesson.edges, maxEdges()), minEdges());
    return lesson.edges;
  }

  double minEdges() => (lesson.nodes - 1) * (askForInformation(lesson.simulationDetails, lesson.directed) ? 2 : 1);

  double maxEdges() {
    double max = lesson.nodes.floor() * (lesson.nodes.floor() - 1) / 2;
    return askForInformation(lesson.simulationDetails, lesson.directed) ? max * 2 : max;
  }
}

class DetailPage extends StatefulWidget {
  final Lesson lesson;
  final Controllers _controllers;

  DetailPage(this.lesson, this._controllers);

  @override
  HomePage createState() => HomePage(lesson, _controllers);
}
