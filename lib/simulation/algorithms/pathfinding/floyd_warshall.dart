import 'dart:math';

import 'package:AlgorithmVisualizer/simulation/algorithms/pathfinding/pathfinding_algorithm_template.dart';
import 'package:AlgorithmVisualizer/simulation/templateGenerator/graph/node.dart';

class FloydWarshall extends PathFindingAlgorithmTemplate {
  List<List<int>> nxt;
  List<List<int>> dist;
  int K = 0;

  FloydWarshall(Node root, Node destination, List<Node> nodes, List<Path> paths) : super(root, destination, nodes, paths) {
    nxt = List<List<int>>.generate(V, (i) => List<int>.generate(V, (j) => 0));
    dist = List<List<int>>.generate(V, (i) => List<int>.generate(V, (j) => maxInt()));
    preSolve = true;

    for (int i = 0; i < V; i++) {
      graph[i][i] = 0;
      dist[i][i] = 0;
    }

    for (Path path in paths) {
      int u = nodes.indexOf(path.rootNode);
      int v = nodes.indexOf(path.destinationNode);
      int w = graph[u][v];

      dist[u][v] = w;
      nxt[u][v] = v;
    }
  }

  @override
  void allInOne() {
    nodes[K].activate();
    for (int i = 0; i < V; i++) {
      Path path = getConnection(nodes[K], nodes[i]);
      if (path != null) {
        path.activate();
      }
      for (int j = 0; j < V; j++) {
        int tempSum = dist[i][K] + dist[K][j];

        if (dist[i][j] > tempSum) {
          dist[i][j] = tempSum;
          nxt[i][j] = nxt[i][K];
        }
      }
    }

    if (K == pow(V, 1) - 1) {
      done = true;
    } else {
      K++;
    }
  }

  @override
  void step() {
    for (int n = 0; n < 1000; n++) {
      int k = (K / pow(V, 2)).floor() % V;
      int i = (K / V).floor() % V;
      int j = K % V;

      nodes[k].activate();

      Path path = getConnection(nodes[k], nodes[i]);
      if (path != null) {
        path.activate();
      }

      int tempSum = dist[i][k] + dist[k][j];
      if (dist[i][j] > tempSum) {
        dist[i][j] = tempSum;
        nxt[i][j] = nxt[i][k];
      }

      if (K == pow(V, 3) - 1) {
        done = true;
      } else {
        K++;
      }
    }
  }

  @override
  void overRideNodeWeights() {
    //path reconstruction
    if (done && root != null) {
      if (destination != null) {
        int i = nodes.indexOf(root);
        int j = nodes.indexOf(destination);
        List<int> path = [i];
        while (path.last != j) {
          path.add(nxt[path[path.length - 1]][j]);
          if (path.last != j) {
            nodes[path[path.length - 1]].highLightActivate();
          }
          getConnection(nodes[path[path.length - 2]], nodes[path[path.length - 1]]).highLightActivate();
        }
        //print(path);
        //print(i.toString() + ' ' + j.toString());
      } else {
        int i = nodes.indexOf(root);
        for (int j = 0; j < V; j++) {
          nodes[j].visualWeightAfterPathFinding = dist[i][j];
        }
      }
    }
  }
}
