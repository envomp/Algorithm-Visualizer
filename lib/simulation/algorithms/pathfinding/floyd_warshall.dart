import 'dart:math';

import 'package:AlgorithmVisualizer/simulation/algorithms/pathfinding/pathfinding_algorithm_template.dart';
import 'package:AlgorithmVisualizer/simulation/templateGenerator/graph/node.dart';

class FloydWarshallAlgorithm extends PathFindingAlgorithmTemplate {
  List<List<int>> nxt;
  List<List<int>> dist;

  FloydWarshallAlgorithm(Node root, Node destination, List<Node> nodes, List<Path> paths) : super(root, destination, nodes, paths) {
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
	  if (nodes[i].weight < 0) {
		  nodes[i].activateNegativeCycle();
	  } else {
		  nodes[i].activate();
	  }
	  for (int k = 0; k < V; k++) {
		  Path path = getConnection(nodes[i], nodes[k]);
      if (path != null) {
        path.activate();
      }
      for (int j = 0; j < V; j++) {
		  int tempSum = dist[k][i] + dist[i][j];

		  if (dist[k][j] > tempSum) {
			  dist[k][j] = tempSum;
			  nxt[k][j] = nxt[k][i];
        }
      }
    }

	  if (i == pow(V, 1) - 1) {
      done = true;
    } else {
		  i++;
    }
  }

  @override
  void step() {
    for (int n = 0; n < 1000; n++) {
		int k = (i / pow(V, 2)).floor() % V;
		int l = (i / V).floor() % V;
		int m = i % V;

		if (nodes[k].weight < 0) {
			nodes[k].activateNegativeCycle();
		} else {
			nodes[k].activate();
		}

		Path path = getConnection(nodes[k], nodes[l]);
      if (path != null) {
        path.activate();
      }

		int tempSum = dist[l][k] + dist[k][m];
		if (dist[l][m] > tempSum) {
			dist[l][m] = tempSum;
			nxt[l][m] = nxt[l][k];
      }

		if (i == pow(V, 3) - 1) {
        done = true;
      } else {
			i++;
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
