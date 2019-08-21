import 'package:AlgorithmVisualizer/controllers/Controllers.dart';
import 'package:AlgorithmVisualizer/simulation/simulation_algorithm.dart';
import 'package:flame/flame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Game extends State<GameWrapper> with TickerProviderStateMixin {
  final SimulationAlgorithm simulation;
  final Controllers _controllers;
  AnimationController animationController;
  Animation<double> animation;

  Game(this.simulation, this._controllers) {
    Flame.util.addGestureRecognizer(_controllers.gestureController
      ..onTapUp = (TapUpDetails details) {
        try {
			simulation.abstractSimulationExecutor.handleTap(details.globalPosition, _controllers.scrollController.offset);
        } catch (Exception) {
			simulation.abstractSimulationExecutor.handleTap(details.globalPosition, 0);
        }
      });
  }

  @override
  void initState() {
	  super.initState();

	  animationController = AnimationController(
		  vsync: this,
		  duration: Duration(seconds: 1),
	  )
		  ..addListener(() => setState(() {}));

	  animation = Tween<double>(
		  begin: 0.0,
		  end: 1.0,
	  ).animate(animationController);

	  animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
		  child: FadeTransition(
			  opacity: animation,
			  child: buildListView(context),
		  ),
      ),
    );
  }

  ListView buildListView(BuildContext context) {
	  simulation.lesson.setState = setState;
	  List<Widget> widgets = <Widget>[buildAppBar(context), buildDivider(context), buildSimulator(context), buildSlider(context), buildContainer()];

	  ListView listView = ListView.builder(
		  controller: _controllers.scrollController,
		  itemCount: widgets.length,
		  itemBuilder: (BuildContext context, int index) {
			  return widgets[index];
		  },
	  );
	  simulation.controller = _controllers.scrollController;
	  return listView;
  }

  Container buildContainer() {
    return Container(
      height: 1000,
    );
  }

  Column buildSlider(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            'Simulation speed:',
            style: TextStyle(color: Colors.black),
          ),
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Slider(
                    activeColor: Colors.green,
                    min: 0.0,
                    max: 10.0,
					  divisions: 1000,
                    onChanged: (value) {
						setState(() => simulation.abstractSimulationExecutor.speedFactor = value.floor());
                    },
					  value: simulation.abstractSimulationExecutor.speedFactor.floorToDouble(),
                  ),
                ),
                Container(
                  width: 60.0,
                  alignment: Alignment.centerLeft,
					child: Text('${simulation.abstractSimulationExecutor.speedFactor}', style: Theme
						.of(context)
						.textTheme
						.display1),
                ),
              ],
            ))
      ],
    );
  }

  Container buildSimulator(BuildContext context) {
	  return Container(padding: EdgeInsets.fromLTRB(30.0, 24.0, 30.0, 24.0), width: MediaQuery
		  .of(context)
		  .size
		  .width, height: MediaQuery
		  .of(context)
		  .size
		  .height - 124, child: simulation.widget);
  }

  Container buildDivider(BuildContext context) {
    return Container(
      width: 90.0,
		padding: EdgeInsets.fromLTRB(24, 0, MediaQuery
			.of(context)
			.size
			.width - 48 - 90, 0),
      alignment: Alignment.centerLeft,
      child: new Divider(color: Colors.green),
    );
  }

  Row buildAppBar(BuildContext context) {
    return Row(
		mainAxisAlignment: MainAxisAlignment.start,
		children: <Widget>[
			Container(
				padding: EdgeInsets.symmetric(horizontal: 24),
				child: InkWell(
					onTap: () {
						Navigator.pop(context);
					},
					child: Icon(Icons.arrow_back, color: Colors.black, size: 24),
				),
			),
			Container(
				child: new Text(
					simulation.lesson.stateDescription,
					style: TextStyle(color: Colors.black),
				),
			)
		],
    );
  }
}

class GameWrapper extends StatefulWidget {
  final SimulationAlgorithm simulation;
  final Controllers _controllers;

  GameWrapper(this.simulation, this._controllers);

  @override
  Game createState() => Game(simulation, _controllers);
}
