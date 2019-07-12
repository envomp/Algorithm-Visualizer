import '../../node.dart';

class MinPriorityQueue {
  // Simple min-priority queue.
  // The complexity of Dijkstra's shortest-path algorithm depends on the
  // implementation of this priority queue. For this implementation, we
  // have a linear scan for extract which means at each step we scan up
  // to |V|, e.g., once for each node/vertice. Since we do |V| extracts,
  // the total complexity is O(V * V).  A smarter backend, e.g. binary
  // heap, for the queue can reduce this, e.g., to O(E * log V).
//  List<Node> _queue = [];
  Map<Node, num> _costs = new Map();

  MinPriorityQueue(List<Node> nodes) {
    for (Node node in nodes) {
      _costs[node] = double.infinity;
    }
  }

  void updateCost(Node n, num cost) {
    _costs[n] = cost;
  }
}
