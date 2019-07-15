import 'package:AlgorithmVisualizer/simulation/algorithms/pathfinding/pathfinding_algorithm_template.dart';
import 'package:AlgorithmVisualizer/simulation/templateGenerator/graph/node.dart';

class BellmanFordAlgorithm extends PathFindingAlgorithmTemplate {
  int i = 0;
  List<int> dist;

  BellmanFordAlgorithm(Node root, Node destination, List<Node> nodes, List<Path> paths) : super(root, destination, nodes, paths) {
	  dist = new List<int>.generate(V, (i) => maxInt());
	  dist[nodes.indexOf(root)] = 0;
  }

  @override
  void allInOne() {
    // Step 1: Relax all edges |V| - 1 times. A simple shortest
    // path from src to any other vertex can have at-most |V| - 1 edges
    for (int i = 0; i < V; i++) {
      // Update dist value and parent index of the adjacent vertices of
      // the picked vertex. Consider only those vertices which are still in queue
      for (Path path in paths) {
        path.rootNode.activate();
        path.activate();

        int u = nodes.indexOf(path.rootNode);
        int v = nodes.indexOf(path.destinationNode);

        if (dist[u] != maxInt() && dist[u] + graph[u][v] < dist[v]) {
          dist[v] = dist[u] + graph[u][v];
        }

        if (dist[u] < 0) {
          path.rootNode.activateNegativeCycle();
          path.activateNegativeCycle();
        }
      }
    }

    // Step 3: check for negative-weight cycles.  The above step
    // guarantees shortest distances if graph doesn't contain
    // negative weight cycle.  If we get a shorter path, then there is a cycle.

    // for (Path path in paths) {
    //   int u = nodes.indexOf(path.rootNode);
    //   int v = nodes.indexOf(path.destinationNode);
    //   if (dist[u] != maxInt() && dist[u] + graph[u][v] < dist[v]) {
    //     print('negative cycle'); //there will always be a negative cycle because of the base tree
    //   }
    // }
    done = true;
  }

  @override
  void step() {
    Path path = paths[i % paths.length];
    int u = nodes.indexOf(path.rootNode);
    int v = nodes.indexOf(path.destinationNode);

    path.rootNode.activate();
    path.activate();

    if (dist[u] != maxInt() && dist[u] + graph[u][v] < dist[v]) {
      dist[v] = dist[u] + graph[u][v];
    }

    if (dist[u] < 0) {
      path.rootNode.activateNegativeCycle();
      path.activateNegativeCycle();
    }

    i++;
    if (i == V * paths.length) {
      done = true;
    }
  }

  @override
  void overRideNodeWeights() {
	  for (int v = 0; v < V; v++) {
		  nodes[v].visualWeightAfterPathFinding = dist[v];
	  }
  }
}
