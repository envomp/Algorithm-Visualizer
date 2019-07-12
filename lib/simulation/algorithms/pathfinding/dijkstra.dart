import 'dart:math';

import 'package:AlgorithmVisualizer/simulation/algorithms/pathfinding/pathfinding_algorithm_template.dart';

import '../../node.dart';

class DijkstraAlgorithm extends PathFindingAlgorithmTemplate {
  int V;
  List<List<int>> graph;
  List<int> dist;
  List<bool> sptSet;
  int i = 0;
  int u;

  DijkstraAlgorithm(
      Node root, Node destination, List<Node> nodes, List<Path> paths)
      : super(root, destination, nodes, paths) {
    V = nodes.length;
    dist = new List<int>.generate(V, (i) => maxInt());
    dist[nodes.indexOf(root)] = 0;
    sptSet = new List<bool>.generate(V, (i) => false);
    graph = new List();

    for (Node source in nodes) {
      List<int> temp = new List();
      for (Node dest in nodes) {
        Path path = getConnection(source, dest);
        if (path == null) {
          temp.add(-1);
        } else {
          temp.add(path.weight + dest.weight);
        }
      }
      graph.add(temp);
    }
  }

  @override
  void step() {
    if (done) {
      return;
    }

    if (i % V == 0) {
      // Pick the minimum distance vertex from
      // the set of vertices not yet processed.
      // u is always equal to src in first iteration
      u = minDistance();

      // Put the minimum distance vertex in the
      // shortest path tree
      sptSet[u] = true;
      nodes[u].activate();

      // Update dist value of the adjacent vertices
      // of the picked vertex only if the current
      // distance is greater than new distance and
      // the vertex in not in the shortest path tree
    }

    int v = i % V;

    if (graph[u][v] >= 0 &&
        sptSet[v] == false &&
        dist[v] > dist[u] + graph[u][v]) {
      dist[v] = dist[u] + graph[u][v];
      getConnection(nodes[u], nodes[v]).activate();
    }

    if (i == pow(V, 2) - 1) {
      done = true;
    } else {
      i++;
    }
  }

  // @override
  // void step(){
  //   if (done) {
  //     return;
  //   }
  //   for (int cout = 0; cout < V; cout++) {
  //     // Pick the minimum distance vertex from
  //     // the set of vertices not yet processed.
  //     // u is always equal to src in first iteration
  //     int u = minDistance();
  //
  //     // Put the minimum distance vertex in the
  //     // shortest path tree
  //     sptSet[u] = true;
  //
  //     // Update dist value of the adjacent vertices
  //     // of the picked vertex only if the current
  //     // distance is greater than new distance and
  //     // the vertex in not in the shortest path tree
  //
  //     for (int v = 0; v < V; v++) {
  //       if (graph[u][v] >= 0 &&
  //           sptSet[v] == false &&
  //           dist[v] > dist[u] + graph[u][v]) {
  //         dist[v] = dist[u] + graph[u][v];
  //       }
  //
  //     }
  //   }
  //   done = true;
  // }

  int minDistance() {
    int minimum = maxInt();
    int minIndex;

    for (int v = 0; v < V; v++) {
      if (dist[v] < minimum && sptSet[v] == false) {
        minimum = dist[v];
        minIndex = v;
      }
    }
    return minIndex;
  }

  int maxInt() => pow(2, 20);

  @override
  void overRideNodeWeights() {
    for (int v = 0; v < V; v++) {
      nodes[v].visualWeightAfterPathFinding = dist[v];
    }
  }

  @override
  void allInOne() {
    if (done) {
      return;
    }
    for (int cout = 0; cout < V; cout++) {
      // Pick the minimum distance vertex from
      // the set of vertices not yet processed.
      // u is always equal to src in first iteration
      int u = minDistance();
      // Put the minimum distance vertex in the
      // shortest path tree
      sptSet[u] = true;
      // Update dist value of the adjacent vertices
      // of the picked vertex only if the current
      // distance is greater than new distance and
      // the vertex in not in the shortest path tree
      for (int v = 0; v < V; v++) {
        if (graph[u][v] >= 0 &&
            sptSet[v] == false &&
            dist[v] > dist[u] + graph[u][v]) {
          dist[v] = dist[u] + graph[u][v];
        }
      }
    }
    done = true;
  }
}

//https://www.geeksforgeeks.org/dijkstras-shortest-path-algorithm-greedy-algo-7/
