import 'dart:math';

import '../../node.dart';
import 'pathfinding_algorithm_template.dart';

class AStar extends PathFindingAlgorithmTemplate {
  List<int> heuristic;
  List<bool> sptSet;
  int i = 0;
  int u;

  AStar(Node root, Node destination, List<Node> nodes, List<Path> paths) : super(root, destination, nodes, paths) {
    heuristic = new List<int>.generate(V, (i) => 0);
    sptSet = new List<bool>.generate(V, (i) => false);
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
      if (nodes[u] == destination) {
        done = true;
        return;
      }
      nodes[u].activate();
      // Put the minimum distance vertex in the
      // shortest path tree
      sptSet[u] = true;
      // Update dist value of the adjacent vertices
      // of the picked vertex only if the current
      // distance is greater than new distance and
      // the vertex in not in the shortest path tree
      for (int v = 0; v < V; v++) {
        if (graph[u][v] != null) {
          getConnection(nodes[u], nodes[v]).activate();
          if (sptSet[v] == false && dist[v] > dist[u] + graph[u][v]) {
            dist[v] = dist[u] + graph[u][v];
          }
        }
      }
    }
    done = true;
  }

  int heuristicFunction(int v) => dist[v] + heuristic[v]; //todo: add an actual heuristic function.. maybe..

  @override
  void step() {
    if (done) {
      return;
    }

    if (i % V == 0) {
      u = minDistance();
      sptSet[u] = true;
      if (nodes[u] == destination) {
        done = true;
        return;
      }
      nodes[u].activate();
    }

    int v = i % V;

    if (graph[u][v] != null) {
      getConnection(nodes[u], nodes[v]).activate();
      if (sptSet[v] == false && dist[v] > dist[u] + graph[u][v]) {
        dist[v] = dist[u] + graph[u][v];
      }
    }

    if (i == pow(V, 2) - 1) {
      done = true;
    } else {
      i++;
    }
  }

  int minDistance() {
    int minimum = maxInt();
    int minIndex = 0;

    for (int v = 0; v < V; v++) {
      if (heuristicFunction(v) < minimum && sptSet[v] == false) {
        minimum = dist[v];
        minIndex = v;
      }
    }
    return minIndex;
  }
}
