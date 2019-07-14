import 'dart:math';

import 'package:AlgorithmVisualizer/simulation/templateGenerator/graph/node.dart';

abstract class PathFindingAlgorithmTemplate {
  final Node root;
  final Node destination;
  final List<Node> nodes;
  final List<Path> paths;
  List<int> dist;
  int V;
  List<List<int>> graph;
  bool done = false;

  PathFindingAlgorithmTemplate(this.root, this.destination, this.nodes, this.paths) {
    V = nodes.length;
    graph = new List();
    dist = new List<int>.generate(V, (i) => maxInt());
    dist[nodes.indexOf(root)] = 0;

    for (Node source in nodes) {
      List<int> temp = new List();
      for (Node dest in nodes) {
        Path path = getConnection(source, dest);
        if (path == null) {
          temp.add(null);
        } else {
          temp.add(path.weight + dest.weight);
        }
      }
      graph.add(temp);
    }
  }

  Object step();

  Object allInOne();

  void overRideNodeWeights() {
    for (int v = 0; v < V; v++) {
      nodes[v].visualWeightAfterPathFinding = dist[v];
    }
  }

  Path getConnection(Node root, Node destination) {
    for (Path path in paths) {
      if (path.rootNode == root && path.destinationNode == destination) {
        return path;
      }
    }
    return null;
  }

  int maxInt() => pow(2, 20);
}
