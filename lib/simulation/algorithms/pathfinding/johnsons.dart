import 'package:AlgorithmVisualizer/simulation/algorithms/pathfinding/bellman_ford.dart';
import 'package:AlgorithmVisualizer/simulation/algorithms/pathfinding/dijkstra.dart';
import 'package:AlgorithmVisualizer/simulation/algorithms/pathfinding/pathfinding_algorithm_template.dart';
import 'package:AlgorithmVisualizer/simulation/templateGenerator/graph/node.dart';

class JohnsonsAlgorithm extends PathFindingAlgorithmTemplate {
  TempNode q;
  List<Path> qPaths;
  BellmanFordAlgorithm bellmanFord;
  DijkstraAlgorithm dijkstraAlgorithm;

  List<List<int>> copy;
  bool reWeightingDone = false;
  bool allOnce = false;
  int i = 0;

  JohnsonsAlgorithm(Node root, Node destination, List<Node> nodes, List<Path> paths) : super(root, destination, nodes, paths) {
    q = new TempNode(100);
    qPaths = new List();
    preSolve = true;

    double x = 0;
    double y = 0;
    for (Node node in nodes) {
      x += node.x;
      y += node.y;
    }

    x /= nodes.length;
    y /= nodes.length;
    q.xCoordinate = x;
    q.yCoordinate = y;
    q.initTempNode();
    q.highLightActivate();
    nodes.add(q);

    for (Node node in nodes) {
      Path path = new Path(q, node);
      path.initPath();
      qPaths.add(path);
      path.highLightActivate();
    }

    paths.addAll(qPaths);

    bellmanFord = new BellmanFordAlgorithm(q, destination, nodes, paths);
  }

  @override
  void allInOne() {
    allOnce = true;
    if (!bellmanFord.done) {
      bellmanFord.allInOne();
      if (bellmanFord.done) {
        for (Path qPath in qPaths) {
          paths.remove(qPath);
        }
      }
    } else if (!done) {
      Path path = paths[i];
      int root = nodes.indexOf(path.rootNode);
      int dest = nodes.indexOf(path.destinationNode);
      graph[root][dest] += bellmanFord.dist[root] - bellmanFord.dist[dest];
      if (i == paths.length - 1) {
        done = true;
        copy = new List.generate(graph.length, (i) => new List.from(graph[i]));
        nodes.remove(q);
      } else {
        i++;
      }
    }
  }

  @override
  void overRideNodeWeights() {
    if (root != null) {
      if (dijkstraAlgorithm == null) {
        print('new djikstra');
        graph = new List.generate(copy.length, (i) => new List.from(copy[i]));
        dijkstraAlgorithm = new DijkstraAlgorithm(root, destination, nodes, paths);
        dijkstraAlgorithm.graph = graph;
      } else if (!dijkstraAlgorithm.done) {
        if (allOnce) {
          dijkstraAlgorithm.allInOne();
        } else {
          dijkstraAlgorithm.step();
        }
        dijkstraAlgorithm.overRideNodeWeights();
        if (dijkstraAlgorithm.done) {
          i = 0;
          reWeightingDone = false;
          dijkstraAlgorithm.graph = graph;
        }
      } else {
        if (!reWeightingDone) {
          int root = nodes.indexOf(dijkstraAlgorithm.root);
          int dest = i;
          dijkstraAlgorithm.dist[dest] += bellmanFord.dist[dest] - bellmanFord.dist[root];
          if (i == nodes.length - 1) {
            reWeightingDone = true;
          } else {
            i++;
          }
        }
        dijkstraAlgorithm.overRideNodeWeights();

        if (destination != null && reWeightingDone) {
          int k = nodes.indexOf(root);
          int i = nodes.indexOf(destination);
          int j = nodes.indexOf(destination);
          while (dijkstraAlgorithm.parent[j] != -1) {
            getConnection(nodes[dijkstraAlgorithm.parent[j]], nodes[j]).highLightActivate();
            j = dijkstraAlgorithm.parent[j];
            if (i != j && k != j) {
              nodes[j].highLightActivate();
            }
          }
        }
      }
    } else {
      dijkstraAlgorithm = null;
    }
  }

  @override
  void step() {
    if (!bellmanFord.done) {
      bellmanFord.step();
      if (bellmanFord.done) {
        for (Path qPath in qPaths) {
          paths.remove(qPath);
        }
      }
    } else if (!done) {
      Path path = paths[i];
      int root = nodes.indexOf(path.rootNode);
      int dest = nodes.indexOf(path.destinationNode);
      graph[root][dest] += bellmanFord.dist[root] - bellmanFord.dist[dest];
      if (i == paths.length - 1) {
        done = true;
        copy = new List.generate(graph.length, (i) => new List.from(graph[i]));
        nodes.remove(q);
      } else {
        i++;
      }
    }
  }
}
