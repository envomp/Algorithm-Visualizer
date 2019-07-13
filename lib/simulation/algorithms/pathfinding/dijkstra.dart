import 'dart:math';

import '../../node.dart';
import 'pathfinding_algorithm_template.dart';

class DijkstraAlgorithm extends PathFindingAlgorithmTemplate {
  List<List<Path>> activeNodesForShortestPath;
  List<bool> sptSet;
  int i = 0;
  int u;

  DijkstraAlgorithm(Node root, Node destination, List<Node> nodes, List<Path> paths) : super(root, destination, nodes, paths) {
    sptSet = new List<bool>.generate(V, (i) => false);
    activeNodesForShortestPath = new List();
    for (var i = 0; i < V; i++) {
      List<Path> list = new List();
      for (var j = 0; j < V; j++) {
        list.add(null);
      }
      activeNodesForShortestPath.add(list);
    }
  }

  @override
  void step() {
    if (done) {
      return;
    }

    if (i % V == 0) {
      u = minDistance();
      sptSet[u] = true;
      nodes[u].activate();
    }

    int v = i % V;

    if (graph[u][v] != null && sptSet[v] == false && dist[v] > dist[u] + graph[u][v]) {
      if (activeNodesForShortestPath[u][v] != null) {
        activeNodesForShortestPath[u][v].deactivate();
      }
      activeNodesForShortestPath[u][v] = getConnection(nodes[u], nodes[v]);
      activeNodesForShortestPath[u][v].activate();
      dist[v] = dist[u] + graph[u][v];
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
    int minIndex = 0;

    for (int v = 0; v < V; v++) {
      if (dist[v] < minimum && sptSet[v] == false) {
        minimum = dist[v];
        minIndex = v;
      }
    }
    return minIndex;
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
      nodes[u].activate();
      // Put the minimum distance vertex in the
      // shortest path tree
      sptSet[u] = true;
      // Update dist value of the adjacent vertices
      // of the picked vertex only if the current
      // distance is greater than new distance and
      // the vertex in not in the shortest path tree
      for (int v = 0; v < V; v++) {
        if (graph[u][v] != null && sptSet[v] == false && dist[v] > dist[u] + graph[u][v]) {
          if (activeNodesForShortestPath[u][v] != null) {
            activeNodesForShortestPath[u][v].deactivate();
          }
          activeNodesForShortestPath[u][v] = getConnection(nodes[u], nodes[v]);
          activeNodesForShortestPath[u][v].activate();
          dist[v] = dist[u] + graph[u][v];
        }
      }
    }
    done = true;
  }
}

//https://www.geeksforgeeks.org/dijkstras-shortest-path-algorithm-greedy-algo-7/
