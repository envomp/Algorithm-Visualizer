part of 'detail_page.dart';

class GraphHomePage extends HomePage {
  GraphHomePage(Lesson lesson, Controllers controllers) : super(lesson, controllers);

  Container getSimulationStepSwitch(BuildContext context) {
	  return Container(
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
		  ));
  }

  Container getNumberOfEdgesSlider(BuildContext context) {
    return askForInformation(lesson.simulationDetails, lesson.askForEdges)
        ? Container(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            width: MediaQuery.of(context).size.width,
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
                      setState(() {
                        return lesson.edges = value;
                      });
                    },
                    value: minMaxEdges(),
                  ),
                ),
                Container(
                  width: 80.0,
                  alignment: Alignment.center,
                  child: Text('${lesson.edges.toInt()}', style: Theme.of(context).textTheme.display1),
                ),
              ],
            ))
        : Container();
  }

  Container getNumberOfEdgesText(BuildContext context) {
    return askForInformation(lesson.simulationDetails, lesson.askForEdges)
        ? Container(
            padding: EdgeInsets.fromLTRB(10.0, 32.0, 0.0, 0.0),
            width: MediaQuery.of(context).size.width,
            child: Text(getEdgesMessage(), style: TextStyle(color: Colors.black)),
          )
        : Container();
  }

  Container getNumberOfNodesSlider(BuildContext context) {
    return askForInformation(lesson.simulationDetails, lesson.askForNodes)
        ? Container(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Slider(
                    activeColor: Colors.green,
                    min: 2.0,
                    max: 100.0,
					  divisions: 1000,
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
                  child: Text('${lesson.nodes.toInt()}', style: Theme.of(context).textTheme.display1),
                ),
              ],
            ))
        : Container();
  }

  Container getNumberOfNodesText(BuildContext context) {
    return askForInformation(lesson.simulationDetails, lesson.askForNodes)
        ? Container(
            padding: EdgeInsets.fromLTRB(10.0, 32.0, 0.0, 0.0),
            width: MediaQuery.of(context).size.width,
            child: Text("Number of nodes:", style: TextStyle(color: Colors.black)),
          )
        : Container();
  }

  Container getWeightedNotification(BuildContext context) {
    return !askForEdgeInformation() && !askForNodeInformation() && askForInformation(lesson.additionalInformation, lesson.weightLocation)
        ? Container(padding: EdgeInsets.fromLTRB(10.0, 32.0, 0.0, 0.0), width: MediaQuery.of(context).size.width, child: Text("I will find a path with the least nodes on path!", style: TextStyle(color: Colors.black)))
        : Container();
  }

  Container getWeightedEdgesSwitch(BuildContext context) {
    return askForInformation(lesson.additionalInformation, lesson.weightLocation)
        ? Container(
            padding: EdgeInsets.fromLTRB(10.0, 32.0, 0.0, 0.0),
            width: MediaQuery.of(context).size.width,
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
  }

  Container getWeightedNodeSwitch(BuildContext context) {
    return askForInformation(lesson.additionalInformation, lesson.weightLocation)
        ? Container(
            padding: EdgeInsets.fromLTRB(10.0, 32.0, 0.0, 0.0),
            width: MediaQuery.of(context).size.width,
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
  }

  Container getDirectedSwitch(BuildContext context) {
    return askForInformation(lesson.simulationDetails, lesson.askForDirection)
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
  }

  String getStepMessage() {
	  return ((askForInformation(lesson.simulationDetails, lesson.stepByStep)) ? "Step by step simulation: " : "Speed mode Simulation: ");
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

  @override
  Container bottomContent() {
	  int delayAmount = 600;
	  return Container(
		  width: MediaQuery.of(context).size.width,
		  padding: EdgeInsets.all(30.0),
		  child: Center(
			  child: Column(
				  children: <Widget>[
					  getBottomContentText(), // 600 delay goes here
					  ShowUp(
						  child: getWeightedNodeSwitch(context),
						  delay: delayAmount + 50,
					  ),
					  ShowUp(
						  child: getWeightedEdgesSwitch(context),
						  delay: delayAmount + 100,
					  ),
					  ShowUp(
						  child: getWeightedNotification(context),
						  delay: delayAmount + 150,
					  ),
					  ShowUp(
						  child: getDirectedSwitch(context),
						  delay: delayAmount + 200,
					  ),
					  ShowUp(
						  child: getNumberOfNodesText(context),
						  delay: delayAmount + 250,
					  ),
					  ShowUp(
						  child: getNumberOfNodesSlider(context),
						  delay: delayAmount + 300,
					  ),
					  ShowUp(
						  child: getNumberOfEdgesText(context),
						  delay: delayAmount + 350,
					  ),
					  ShowUp(
						  child: getNumberOfEdgesSlider(context),
						  delay: delayAmount + 400,
					  ),
					  ShowUp(
						  child: getSimulationStepSwitch(context),
						  delay: delayAmount + 450,
					  ),
					  ShowUp(
						  child: getStartButton(context),
						  delay: delayAmount + 500,
					  ),
				  ],
			  ),
		  ),
	  );
  }
}
