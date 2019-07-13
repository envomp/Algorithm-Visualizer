import 'package:AlgorithmVisualizer/controllers/Controllers.dart';
import 'package:AlgorithmVisualizer/model/lesson.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'detail_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Controllers _controllers = Controllers();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primaryColor: Color.fromRGBO(58, 66, 86, 1.0),
        fontFamily: 'Raleway',
        primaryColorBrightness: Brightness.dark,
      ),

      home: new ListPage(
        controllers: _controllers,
      ),
      // home: DetailPage(),
    );
  }
}

class ListPage extends StatefulWidget {
  ListPage({Key key, this.controllers}) : super(key: key);

  final Controllers controllers;

  @override
  _ListPageState createState() => _ListPageState(controllers);
}

class _ListPageState extends State<ListPage> {
  final Controllers _controllers;
  int activePage = 0;

  _ListPageState(this._controllers);

  @override
  Widget build(BuildContext context) {
    ListTile makeListTile(Lesson lesson) => ListTile(
		contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
			  decoration: new BoxDecoration(border: new Border(right: new BorderSide(width: 1.0, color: Colors.white24))),
            child: lesson.icon,
          ),
          title: Text(
            lesson.title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

          subtitle: Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                    // tag: 'hero',
					  child: LinearProgressIndicator(backgroundColor: Color.fromRGBO(209, 224, 224, 0.2), value: lesson.indicatorValue, valueColor: AlwaysStoppedAnimation(Colors.green)),
                  )),
              Expanded(
                flex: 4,
				  child: Padding(padding: EdgeInsets.only(left: 10.0), child: Text(lesson.level, style: TextStyle(color: Colors.white))),
              )
            ],
          ),
		trailing: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
          onTap: () {
			  Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(lesson, _controllers)));
          },
        );

    Card makeCard(Lesson lesson) => Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
            child: makeListTile(lesson),
          ),
        );

    final makeBody = Container(
        decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
        child: PageView(
          controller: _controllers.pageController,
          physics: AlwaysScrollableScrollPhysics(),
          pageSnapping: true,
          scrollDirection: Axis.horizontal,
          onPageChanged: (int newPage) {
            setState(() {
              activePage = newPage;
            });
          },
          children: createChildren(makeCard),
        ));

    final makeBottom = Container(
      height: 55.0,
      child: BottomAppBar(
        color: Color.fromRGBO(58, 66, 86, 1.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: AlgorithmType.values.length,
          itemBuilder: (BuildContext context, int index) {
            return IconButton(
				icon: Icon(AlgorithmIcon.getAlgorithmIcon(AlgorithmType.values[index]), color: activePage == index ? Colors.green : Colors.white),
              onPressed: () {
                setState(() {
                  activePage = index;
                  _controllers.pageController.jumpToPage(index);
                });
              },
            );
          },
        ),
      ),
    );
    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      title: Text(AlgorithmToString.getAlgorithmToString(activePage)),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.list),
          onPressed: () {},
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: topAppBar,
      body: makeBody,
      bottomNavigationBar: makeBottom,
    );
  }

  List<Widget> createChildren(Card makeCard(Lesson lesson)) {
    List<Widget> widgets = [];
    for (int i = 0; i < AlgorithmType.values.length; i++) {
      widgets.add(buildListView(makeCard, i));
    }
    return widgets;
  }

  ListView buildListView(Card makeCard(Lesson lesson), int index) {
    List<Lesson> listLessons = getLessons();
    listLessons.sort((a, b) => a.getSortingOrder().compareTo(b.getSortingOrder()));
    if (index != 0) {
		listLessons = listLessons.where((f) => f.algorithmType == AlgorithmType.values[index]).toList();
    }
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: listLessons.length,
      itemBuilder: (BuildContext context, int listIndex) {
        return makeCard(listLessons[listIndex]);
      },
    );
  }
}

List<Lesson> getLessons() => [
      Lesson(
          title: "Dijkstra's algorithm",
          level: "Basic",
          indicatorValue: 0.2,
          complexity: "O(N²)",
          complexityDetails: "N-number of nodes",
          icon: Icon(Icons.directions_car, color: Colors.white),
          usages: "Single-source shortest path in a graph",
          simulationDetails: 7,
          additionalInformation: 3,
          algorithmTemplate: AlgorithmTemplate.graph,
          algorithmType: AlgorithmType.pathFinding,
          content:
              "Dijkstra's algorithm is an algorithm for finding the shortest paths between nodes in a graph, which may represent, for example, road networks. The algorithm exists in many variants; Dijkstra's original variant found the shortest path between two nodes, but a more common variant fixes a single node as the 'source' node and finds shortest paths from the source to all other nodes in the graph, producing a shortest-path tree."),
      Lesson(
          title: "A-star algorithm",
          level: "Beginner",
          indicatorValue: 0.4,
          complexity: "O(b^d)",
          complexityDetails: "d-shortest path\nb-branching factor",
          icon: Icon(Icons.directions_bus, color: Colors.white),
          usages: "Finding the shortest route (GPS)",
          simulationDetails: 7,
          additionalInformation: 3,
          algorithmTemplate: AlgorithmTemplate.graph,
          algorithmType: AlgorithmType.pathFinding,
          content:
              "A* is just like Dijkstra, the only difference is that A* tries to look for a better path by using a heuristic function which gives priority to nodes that are supposed to be better than others while Dijkstra's just explore all possible paths."),
      Lesson(
          title: "Bellman–Ford algorithm",
          level: "Intermidiate",
          indicatorValue: 0.6,
          complexity: "O(V*E)",
          complexityDetails: "V-number of vertices\nE-number of edges",
          icon: Icon(Icons.network_check, color: Colors.white),
          usages: "Network routing\nMoney exchange manipulation",
          simulationDetails: 7,
          additionalInformation: 11,
          algorithmTemplate: AlgorithmTemplate.graph,
          algorithmType: AlgorithmType.pathFinding,
          content:
              "The Bellman–Ford algorithm is an algorithm that computes shortest paths from a single source vertex to all of the other vertices in a weighted digraph. It is slower than Dijkstra's algorithm for the same problem, but more versatile, as it is capable of handling graphs in which some of the edge weights are negative numbers."),
      Lesson(
          title: "Floyd-Warshall algorithm",
          level: "Hard",
          indicatorValue: 0.8,
          complexity: "O(N³)",
          complexityDetails: "N-number of nodes",
          icon: Icon(Icons.wifi, color: Colors.white),
          additionalInformation: 11,
          usages: "Maximum Bandwidth Paths in Flow Networks.\nInversion of real matrices.\nFast computation of Pathfinder networks",
          simulationDetails: 7,
          algorithmTemplate: AlgorithmTemplate.graph,
          algorithmType: AlgorithmType.pathFinding,
          content:
              "Floyd–Warshall algorithm is an algorithm for finding shortest paths in a weighted graph with positive or negative edge weights (but with no negative cycles).A single execution of the algorithm will find the lengths (summed weights) of shortest paths between all pairs of vertices. Although it does not return details of the paths themselves, it is possible to reconstruct the paths with simple modifications to the algorithm. Floyd-Warshall's algorithm is used when any of all the nodes can be a source, so you want the shortest distance to reach any destination node from any source node. Floyd-Warshall computes shortest paths from each node to every other node."),
      Lesson(
          title: "Johnson's algorithm",
          level: "Advanced",
          indicatorValue: 1.0,
          complexity: "O(V²log V + VE)",
          complexityDetails: "V-number of vertices\nE-number of edges",
          icon: Icon(Icons.computer, color: Colors.white),
          usages: "optimized CPU computing",
          simulationDetails: 7,
          additionalInformation: 11,
          algorithmTemplate: AlgorithmTemplate.graph,
          algorithmType: AlgorithmType.pathFinding,
          content:
              "Johnson's algorithm is a way to find the shortest paths between all pairs of vertices in a edge-weighted, directed graph. It allows some of the edge weights to be negative numbers, but no negative-weight cycles may exist. It works by using the Bellman–Ford algorithm to compute a transformation of the input graph that removes all negative weights, allowing Dijkstra's algorithm to be used on the transformed graph. Johnson's algorithm is very similar to the Floyd-Warshall algorithm; however, Floyd-Warshall is most effective for dense graphs (many edges), while Johnson's algorithm is most effective for sparse graphs (few edges). Proposed algorithmic and architectural optimizations results in more than 4.5 times speed up of all-pairs shortest path calculation for large graphs with respect to the CPU. "),
      Lesson(
          title: "Flood fill algorithm",
          level: "Basic",
          indicatorValue: 0.2,
          complexity: "O(N²)",
          complexityDetails: "N-number of nodes",
          icon: Icon(Icons.format_paint, color: Colors.white),
          usages: "Paint\nGo and Minesweeper",
          simulationDetails: 0,
          additionalInformation: 0,
          algorithmTemplate: AlgorithmTemplate.maze,
          algorithmType: AlgorithmType.pathFinding,
          content:
              "Flood fill, also called seed fill, is an algorithm that determines the area connected to a given node in a multi-dimensional array. It is used in the 'bucket' fill tool of paint programs to fill connected, similarly-colored areas with a different color, and in games such as Go and Minesweeper for determining which pieces are cleared."),
      Lesson(
          title: "Four color theorem",
          level: "Advanced",
          indicatorValue: 1.0,
          complexity: "NP-complete",
          complexityDetails: "Solution has not yet been mathematically proven.",
          icon: Icon(Icons.map, color: Colors.white),
          usages: "Mensuring that two mobile phone masts that overlap has a different frequency.",
          simulationDetails: 6,
          additionalInformation: 0,
          algorithmTemplate: AlgorithmTemplate.graph,
          algorithmType: AlgorithmType.proofOfConcept,
          content:
              "In mathematics, the four color theorem states that, given any separation of a plane into contiguous regions, producing a figure called a map, no more than four colors are required to color the regions of the map so that no two adjacent regions have the same color.")
    ];

/* sources>

  https://brilliant.org/wiki/shortest-path-algorithms/

 */
