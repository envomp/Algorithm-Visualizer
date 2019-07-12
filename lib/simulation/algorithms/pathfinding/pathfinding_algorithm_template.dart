import 'dart:math';

import '../../node.dart';

abstract class PathFindingAlgorithmTemplate {
    final Node root;
    final Node destination;
    final List<Node> nodes;
    final List<Path> paths;
    int V;
    List<List<int>> graph;
    bool done = false;

    PathFindingAlgorithmTemplate(this.root, this.destination, this.nodes, this.paths) {
        V = nodes.length;
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

    int maxInt() => pow(2, 20);
}
