import 'dart:math';

import 'package:AlgorithmVisualizer/controllers/Controllers.dart';
import 'package:AlgorithmVisualizer/formulas/formulas.dart';
import 'package:AlgorithmVisualizer/model/lesson.dart';
import 'package:AlgorithmVisualizer/simulation/simulation_algorithm.dart';
import 'package:AlgorithmVisualizer/simulation/simulation_state.dart';
import 'package:flutter/material.dart';

part 'empty_detail_page.dart';

part 'graph_detail_page.dart';

part 'maze_detail_page.dart';

abstract class HomePage extends State<DetailPage> {
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

	return Scaffold(
		body: ListView(
			children: <Widget>[
				Column(
					children: <Widget>[topContent, bottomContent()],
				),
			],
		),
    );
  }

  Container bottomContent();

  Container getStartButton(BuildContext context) {
	  return Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          onPressed: () {
			  Navigator.push(context, MaterialPageRoute(builder: (context) => GameWrapper(new SimulationAlgorithm(lesson), _controllers)));
          },
          color: Colors.green,
			child: Text("Visual demonstration", style: TextStyle(color: Colors.white)),
        ));
  }

  Text getBottomContentText() {
	  return Text(
		  "Complexity description:\n\n" + lesson.complexityDetails + "\n\n\nIntroduction:\n\n" + lesson.content + "\n\n\nApplications and generalizations:\n\n" + lesson.usages,
		  style: TextStyle(fontSize: 18.0),
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
}

class DetailPage extends StatefulWidget {
  final Lesson lesson;
  final Controllers _controllers;

  DetailPage(this.lesson, this._controllers);

  @override
  HomePage createState() {
	  switch (lesson.algorithmTemplate) {
		  case AlgorithmTemplate.graph:
			  return GraphHomePage(lesson, _controllers);
			  break;
		  case AlgorithmTemplate.maze:
			  return MazeHomePage(lesson, _controllers);
			  break;
	  }
	  return EmptyHomePage(lesson, _controllers);
  }
}
