import '../../node.dart';

abstract class PathFindingAlgorithmTemplate {
  final Node root;
  final Node destination;
  final List<Node> nodes;
  final List<Path> paths;
  bool done = false;

  PathFindingAlgorithmTemplate(
      this.root, this.destination, this.nodes, this.paths);

  Object step();

  Object allInOne();

  void overRideNodeWeights();

  Path getConnection(Node root, Node destination) {
    for (Path path in paths) {
      if (path.rootNode == root && path.destinationNode == destination) {
        return path;
      }
    }
    return null;
  }
}
