import 'dart:math';

import 'package:AlgorithmVisualizer/simulation/templateGenerator/graph/node.dart';

import 'pathfinding_algorithm_template.dart';

class DijkstraAlgorithm extends PathFindingAlgorithmTemplate {
	List<int> dist;
	List<bool> sptSet;
	List<int> parent;
	int u;

	DijkstraAlgorithm(Node root, Node destination, List<Node> nodes, List<Path> paths) : super(root, destination, nodes, paths) {
		sptSet = new List<bool>.generate(V, (i) => false);
		dist = new List<int>.generate(V, (i) => maxInt());
		dist[nodes.indexOf(root)] = 0;
		parent = new List<int>.generate(V, (i) => -1);
	}

	@override
	void step() {
		if (i % V == 0) {
			u = minDistance();
			sptSet[u] = true;
			nodes[u].activate();
		}

		int v = i % V;

		if (graph[u][v] != null) {
			getConnection(nodes[u], nodes[v]).activate();
			if (sptSet[v] == false && dist[v] > dist[u] + graph[u][v]) {
				dist[v] = dist[u] + graph[u][v];
				parent[v] = u;
			}
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
			if (graph[u][v] != null) {
				getConnection(nodes[u], nodes[v]).activate();
				if (sptSet[v] == false && dist[v] > dist[u] + graph[u][v]) {
					dist[v] = dist[u] + graph[u][v];
					parent[v] = u;
				}
			}
		}

		if (i == V - 1) {
			done = true;
		} else {
			i++;
		}
	}

	@override
	void overRideNodeWeights() {
		for (int v = 0; v < V; v++) {
			nodes[v].visualWeightAfterPathFinding = dist[v];
		}
	}
}

//https://www.geeksforgeeks.org/dijkstras-shortest-path-algorithm-greedy-algo-7/
