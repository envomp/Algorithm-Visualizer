import 'package:AlgorithmVisualizer/simulation/simulation_algorithm.dart';
import 'package:flame/flame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Game extends State<GameWrapper> {
  final SimulationAlgorithm simulation;
  ScrollController _scrollController;
  TapGestureRecognizer _gestureController;

  Game(this.simulation, this._scrollController, this._gestureController) {
    Flame.util.addGestureRecognizer(_gestureController
      ..onTapUp = (TapUpDetails details) {
        simulation.abstractSimulationExecutor
            .handleTap(details.globalPosition, _scrollController.offset);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: buildListView(context),
      ),
    );
  }

  ListView buildListView(BuildContext context) {
    List<Widget> widgets = <Widget>[
      buildAppBar(context),
      buildDivider(context),
      buildSimulator(context),
      buildSlider(context),
      buildContainer()
    ];
    ListView listView = ListView.builder(
      controller: _scrollController,
      itemCount: widgets.length,
      itemBuilder: (BuildContext context, int index) {
        return widgets[index];
      },
    );
    simulation.controller = _scrollController;
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
                    min: 1.0,
                    max: 10.0,
                    divisions: 100,
                    onChanged: (value) {
                      setState(() => simulation.abstractSimulationExecutor
                          .speedFactor = value.floor());
                    },
                    value: simulation.abstractSimulationExecutor.speedFactor
                        .floorToDouble(),
                  ),
                ),
                Container(
                  width: 60.0,
                  alignment: Alignment.centerLeft,
                  child: Text(
                      '${simulation.abstractSimulationExecutor.speedFactor}',
                      style: Theme.of(context).textTheme.display1),
                ),
              ],
            ))
      ],
    );
  }

  Container buildSimulator(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(30.0, 24.0, 30.0, 24.0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 124,
      child: simulation.widget,
    );
  }

  Container buildDivider(BuildContext context) {
    return Container(
      width: 90.0,
      padding: EdgeInsets.fromLTRB(
          24, 0, MediaQuery.of(context).size.width - 48 - 90, 0),
      alignment: Alignment.centerLeft,
      child: new Divider(color: Colors.green),
    );
  }

  Row buildAppBar(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 24,
          height: 24,
        ),
        Container(
          width: 10,
          alignment: Alignment.topLeft,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.black, size: 24),
          ),
        )
      ],
    );
  }
}

class GameWrapper extends StatefulWidget {
  final SimulationAlgorithm simulation;
  final ScrollController _scrollController;
  final TapGestureRecognizer _gestureController;

  GameWrapper(this.simulation, this._scrollController, this._gestureController);

  @override
  Game createState() => Game(simulation, _scrollController, _gestureController);

}