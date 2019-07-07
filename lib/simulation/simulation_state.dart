import 'package:AlgorithmVisualizer/simulation/simulation_algorithm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Game extends State<GameWrapper> {
  SimulationAlgorithm simulation;
  ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  Game(this.simulation);

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
      BuildDivider(context),
      buildSimulator(context),
      buildSlider(context),
      buildContainer()
    ];
    ListView listView = ListView.builder(
      controller: _controller,
      itemCount: widgets.length,
      itemBuilder: (BuildContext context, int index) {
        return widgets[index];
      },
    );
    simulation.controller = listView.controller;
    print(simulation.controller);
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

  Container BuildDivider(BuildContext context) {
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
                  child:
                      Icon(Icons.arrow_back, color: Colors.black, size: 24),
                ),
              )
            ],
          );
  }
}

class GameWrapper extends StatefulWidget {
  final SimulationAlgorithm simulation;

  GameWrapper(this.simulation);

  @override
  Game createState() => Game(simulation);
}
