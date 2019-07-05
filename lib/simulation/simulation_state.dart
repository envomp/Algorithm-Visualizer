import 'package:AlgorithmVisualizer/simulation/simulation_algorithm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Game extends State<GameWrapper> {
  final SimulationAlgorithm simulation;

  Game(this.simulation);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(30.0, 24.0, 30.0, 24.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 100,
            child: simulation.widget,
          ),
          Column(
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
                            setState(
                                () => simulation.speedFactor = value.floor());
                          },
                          value: simulation.speedFactor.floorToDouble(),
                        ),
                      ),
                      Container(
                        width: 60.0,
                        alignment: Alignment.centerLeft,
                        child: Text('${simulation.speedFactor}',
                            style: Theme.of(context).textTheme.display1),
                      ),
                    ],
                  ))
            ],
          ),
        ]),
      ),
    );
  }
}

class GameWrapper extends StatefulWidget {
  final SimulationAlgorithm simulation;

  GameWrapper(this.simulation);

  @override
  Game createState() => Game(simulation);
}
