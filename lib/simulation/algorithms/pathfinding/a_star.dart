import 'package:AlgorithmVisualizer/simulation/algorithms/pathfinding/pathfinding_algorithm_template.dart';
import 'package:AlgorithmVisualizer/simulation/node.dart';

class AStar extends PathFindingAlgorithmTemplate {
  AStar(Node root, Node destination, List<Node> nodes, List<Path> paths) : super(root, destination, nodes, paths);

  @override
  Object allInOne() {
    print(graph);
    done = true;
    return null;
  }

  @override
  void overRideNodeWeights() {
    // TODO: implement overRideNodeWeights
  }

  @override
  Object step() {
    // TODO: implement step
    return null;
  }
}
