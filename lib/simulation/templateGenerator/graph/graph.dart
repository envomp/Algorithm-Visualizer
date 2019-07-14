import 'dart:math';
import 'dart:ui';

import 'package:AlgorithmVisualizer/formulas/formulas.dart';
import 'package:AlgorithmVisualizer/model/lesson.dart';
import 'package:AlgorithmVisualizer/simulation/algorithms/pathfinding/a_star.dart';
import 'package:AlgorithmVisualizer/simulation/algorithms/pathfinding/bellman_ford.dart';
import 'package:AlgorithmVisualizer/simulation/algorithms/pathfinding/dijkstra.dart';
import 'package:AlgorithmVisualizer/simulation/algorithms/pathfinding/pathfinding_algorithm_template.dart';
import 'package:AlgorithmVisualizer/simulation/simulation_algorithm.dart';
import 'package:AlgorithmVisualizer/simulation/templateGenerator/graph/node.dart';
import 'package:AlgorithmVisualizer/simulation/templateGenerator/template_simulation_executor.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class Graph extends TemplateSimulationExecutor {
  final Lesson lesson;
  PathFindingAlgorithmTemplate executiveAlgorithm;
  bool isHandleInput = true;

  // constants that are calculated from lesson
  double minWeight;
  double maxWeight;
  double minNodeSize;
  double maxNodeSize;
  double proportionalMultiplier;

  // variables used in all states
  int speedFactor = 1; // variable used in the slider and game loop
  States state = States.drawNodes;
  List<Node> nodes = new List();
  List<Path> paths = new List();

  // temp variables
  List<Node> usedNodes = new List();
  List<Node> notUsedNodes = new List();
  List<int> incomingPathsPerNode;
  List<int> outgoingPathsPerNode;

  var preCalculatedEdges = new EqualityMap.from(const ListEquality(), {});

  bool hardReset = false;
  Node root;
  Node destination;
  int weight;
  double elapsedTime = 0;

  Graph(this.lesson) : super(lesson) {
    this.maxWeight = 99;
    if (askForInformation(lesson.additionalInformation, lesson.negativeWeights)) {
      this.minWeight = -this.maxWeight;
    } else {
      this.minWeight = 0;
    }
    this.minNodeSize = 30 - lesson.nodes / 5;
    this.maxNodeSize = 50 - lesson.nodes / 5;
    this.proportionalMultiplier = 120 - lesson.nodes; // time to finish loading
    this.outgoingPathsPerNode = new List<int>.filled(lesson.nodes.ceil() + 1, 0, growable: false);
    this.incomingPathsPerNode = new List<int>.filled(lesson.nodes.ceil() + 1, 0, growable: false);
  }

  @override
  void render(Canvas canvas, size) {
    canvas.save();
    paths.forEach((x) {
      x.render(canvas);
      canvas.restore();
      canvas.save();
    });

    nodes.forEach((x) {
      x.render(canvas);
      canvas.restore();
      canvas.save();
    });
  }

  @override
  void update(double t, Size size) {
    for (int i = 0; i < speedFactor; i++) {
      switch (state) {
        case States.drawNodes:
			setAppBarMessage('Drawing nodes');
			nodeInitialization(t, size);
			break;
        case States.drawConnections:
			setAppBarMessage('Drawing paths');
			pathInitialization(t);
			break;
        case States.algorithm:
          switch (lesson.algorithmType) {
            case AlgorithmType.pathFinding:
              pathFindingSimulationStates();
              break;
            case AlgorithmType.proofOfConcept:
              switch (lesson.title) {
                case "Four color theorem":
                  break;
              }
              break;
            case AlgorithmType.all:
              //it should never get here
              break;
          }
          break;
      }
    }

    nodes.forEach((x) {
      x.update(t);
    });
    paths.forEach((x) {
      x.update(t);
    });
  }

  void pathFindingSimulationStates() {
    if (executiveAlgorithm == null) {
      pathFindingAlgorithmSelector();
	  if (executiveAlgorithm == null) {
		  if (root == null) {
			  setAppBarMessage('Select root');
		  } else if (destination == null) {
			  setAppBarMessage('Select destination');
		  }
	  }
    } else {
      if (executiveAlgorithm.done) {
        //reset simulation
		  setAppBarMessage('Press on screen to reset the simulation');
		  hardReset = true;
		  isHandleInput = true;
      } else {
        // run simulation
		  setAppBarMessage('Running simulation');
		  if (askForInformation(lesson.simulationDetails, lesson.stepByStep)) {
			  executiveAlgorithm.step();
		  } else {
			  executiveAlgorithm.allInOne();
		  }
      }
      executiveAlgorithm.overRideNodeWeights();
    }
  }

  void pathFindingAlgorithmSelector() {
    switch (lesson.title) {
      case "Dijkstra's algorithm":
        if (checkRequirementsToAllNodes()) {
          executiveAlgorithm = DijkstraAlgorithm(root, destination, nodes, paths);
          isHandleInput = false;
        }
        break;
      case "A-star algorithm":
        if (checkRequirementsFull()) {
          executiveAlgorithm = AStar(root, destination, nodes, paths);
          isHandleInput = false;
        }
        break;
      case "Bellman–Ford algorithm":
        if (checkRequirementsToAllNodes()) {
          executiveAlgorithm = BellmanFord(root, destination, nodes, paths);
          isHandleInput = false;
        }
        break;
      case "Floyd-Warshall algorithm":
        break;
      case "Johnson's algorithm":
        break;
    }
  }

  bool checkRequirementsFull() => root != null && destination != null && nodes != null && paths != null;

  bool checkRequirementsToAllNodes() => root != null && nodes != null && paths != null;

  bool checkRequirements() => nodes != null && paths != null;

  @override
  handleTap(Offset globalPosition, double offset) {
    if (state == States.algorithm && isHandleInput) {
      double paddingLeft = 30.0;
      double paddingTop = 90.0;
      if (hardReset) {
        for (Node node in nodes) {
          node.visualWeightAfterPathFinding = node.weight;
          node.deactivate();
        }
        for (Path path in paths) {
          path.deactivate();
        }
        executiveAlgorithm = null;
        root = null;
        destination = null;
        hardReset = false;
      } else if (root == null) {
        for (Node node in nodes) {
          if (pythagoreanTheoremAll(node.x, node.y, globalPosition.dx - paddingLeft, globalPosition.dy + offset - paddingTop) < minNodeSize) {
            root = node;
            root.activateUserOverride();
          }
        }
      } else if (destination == null) {
        for (Node node in nodes) {
          if (pythagoreanTheoremAll(node.x, node.y, globalPosition.dx - paddingLeft, globalPosition.dy + offset - paddingTop) < minNodeSize) {
            destination = node;
            destination.activateUserOverride();
          }
        }
      } else if (destination != null && pythagoreanTheoremAll(destination.x, destination.y, globalPosition.dx - paddingLeft, globalPosition.dy + offset - paddingTop) < minNodeSize) {
        destination.deactivate();
        destination = null;
      } else if (pythagoreanTheoremAll(root.x, root.y, globalPosition.dx - paddingLeft, globalPosition.dy + offset - paddingTop) < minNodeSize) {
        root.deactivate();
        root = null;
      }
    }
  }

  ///////////////////////// NODE INITIALIZATION CODE ///////////////////////////

  void nodeInitialization(double t, size) {
    if (nodes.length < lesson.nodes) {
      if (askForInformation(lesson.additionalInformation, lesson.weightsOnNodes)) {
        this.newNode(t, weightedNodeCreation, size);
      } else {
        this.newNode(t, nodeCreation, size);
      }
    } else {
      state = States.drawConnections;
      elapsedTime = 0;
    }
  }

  void newNode(double t, creationMethod, Size size) {
    // creates a new node with no overlap
    elapsedTime += t;
    while (true) {
      Node node = creationMethod(size);
      bool overlapping = false;
      // check that it is not overlapping with any existing circle
      // another brute force approach
      for (var i = 0; i < nodes.length; i++) {
        var existing = nodes[i];
        double d = pythagoreanTheorem(node, existing);
        if (d < 1.9 * (maxNodeSize - minNodeSize)) {
          overlapping = true;
          break;
        }
      }
      // add valid circles to array
      if (!overlapping) {
        node.initNode(lesson);
        nodes.add(node);
        break;
      }
    }
  }

  Node nodeCreation(Size size) => new Node(generateXCoordinate(minNodeSize, size), generateYCoordinate(minNodeSize, size), minNodeSize);

  Node weightedNodeCreation(Size size) {
    double weight = (rnd.nextInt(maxWeight.floor()).ceilToDouble());
    if (askForInformation(lesson.additionalInformation, lesson.negativeWeights)) {
      if (rnd.nextDouble() > 0.9) {
        weight *= -0.1;
      } else {
        weight *= 0.9;
        weight += 10;
      }
    }
    return new Node.weighted(generateXCoordinate(maxNodeSize, size), generateYCoordinate(maxNodeSize, size), (weight.abs() / maxWeight * (maxNodeSize - minNodeSize) + minNodeSize), weight.floor());
  }

  double generateYCoordinate(nodeSize, size) => min(size.height, (elapsedTime / lesson.nodes * proportionalMultiplier) * rnd.nextDouble() * size.height);

  double generateXCoordinate(nodeSize, size) => rnd.nextDouble() * size.width;

  ///////////////////////// PATH INITIALIZATION CODE ///////////////////////////

  void pathInitialization(double t) {
    if (paths.length < lesson.edges.floor() * (askForInformation(lesson.simulationDetails, lesson.directed) ? 1 : 2)) {
      //every undirected path counts as 2
      if (paths.length < (lesson.nodes.floor() - 1) * 2) {
        if (askForInformation(lesson.additionalInformation, lesson.weightsOnEdges)) {
          newPath(t, weightedPathCreation, treeGeneration);
        } else {
          newPath(t, pathCreation, treeGeneration);
        }
      } else {
        if (askForInformation(lesson.additionalInformation, lesson.weightsOnEdges)) {
          newPath(t, weightedPathCreation, graphGeneration);
        } else {
          newPath(t, pathCreation, graphGeneration);
        }
      }
    } else {
      state = States.algorithm;
      root = null;
      destination = null;
      elapsedTime = 0;
    }
  }

  Path newPath(double t, creationMethod, generationFunction) {
    generationFunction(creationMethod);
    Path outgoing = creationMethod(root, destination);
    outgoing.initPath();
    paths.add(outgoing);
    outgoingPathsPerNode[nodes.indexOf(root)]++;
    incomingPathsPerNode[nodes.indexOf(destination)]++;

    if (paths.length < (lesson.nodes.floor() - 1) * 2 || !askForInformation(lesson.simulationDetails, lesson.directed)) {
      Path incoming = creationMethod(destination, root);
      incoming.initPath();
      paths.add(incoming);
      outgoingPathsPerNode[nodes.indexOf(destination)]++;
      incomingPathsPerNode[nodes.indexOf(root)]++;
    }
  }

  void treeGeneration(creationMethod) {
    if (usedNodes.isEmpty) {
      notUsedNodes = new List.from(nodes);
      root = notUsedNodes.removeAt(0);
      usedNodes.add(root);
    } else {
      List temp = usedNodes.sublist(max(0, usedNodes.length - 10));
      root = temp[rnd.nextInt(temp.length)];
    }
    destination = notUsedNodes[rnd.nextInt(notUsedNodes.length)];
    double closestDistance = pythagoreanTheorem(destination, root).abs();

    for (Node potentiallyClosest in notUsedNodes) {
      double tempAbs;
      tempAbs = pythagoreanTheorem(potentiallyClosest, root).abs();

      if (tempAbs < closestDistance) {
        destination = potentiallyClosest;
        closestDistance = tempAbs;
      }
    }

    if (closestDistance > 250) {
      for (Node potentiallyClosest in usedNodes) {
        double tempAbs;
        tempAbs = pythagoreanTheorem(potentiallyClosest, destination).abs();

        if (tempAbs < closestDistance) {
          root = potentiallyClosest;
          closestDistance = tempAbs;
        }
      }
    }

    notUsedNodes.remove(destination);
    usedNodes.add(destination);
  }

  void graphGeneration(creationMethod) {
    List<Node> potentialSources = new List();
    List<Node> potentialDestinations = new List();

    for (int i = 0; i < nodes.length; i++) {
      if (outgoingPathsPerNode[i] < nodes.length - 1) {
        potentialSources.add(nodes[i]);
      }
      if (incomingPathsPerNode[i] < nodes.length - 1) {
        potentialDestinations.add(nodes[i]);
      }
    }
    root = potentialSources[rnd.nextInt(potentialSources.length)];

    for (Path path in paths) {
      if (path.rootNode == root) {
        if (potentialDestinations.contains(path.destinationNode)) {
          potentialDestinations.remove(path.destinationNode);
        }
      }
    }

    if (potentialDestinations.contains(root)) {
      potentialDestinations.remove(root);
    }
    destination = potentialDestinations[rnd.nextInt(potentialDestinations.length)];
    double closestDistance = pythagoreanTheorem(destination, root).abs();

    for (Node potentiallyClosest in potentialDestinations) {
      double tempAbs;
      if (preCalculatedEdges.containsKey([root, potentialDestinations])) {
        tempAbs = preCalculatedEdges[[root, potentialDestinations]];
      } else {
        tempAbs = pythagoreanTheorem(potentiallyClosest, root).abs();
        preCalculatedEdges[[root, potentialDestinations]] = tempAbs;
      }
      if (tempAbs < closestDistance) {
        destination = potentiallyClosest;
        closestDistance = tempAbs;
      }
    }
  }

  Path pathCreation(Node root, Node destination) {
    for (Path path in paths) {
      if (path.destinationNode == root && path.rootNode == destination) {
        return new Path.half(root, destination);
      }
    }
    return new Path(root, destination);
  }

  Path weightedPathCreation(Node root, Node destination) {
    if (askForInformation(lesson.simulationDetails, lesson.directed) || paths.length % 2 == 0) {
      weight = (rnd.nextInt(maxNodeSize.floor() - minNodeSize.floor()) + minNodeSize).floor();
    }

    for (Path path in paths) {
      if (path.destinationNode == root && path.rootNode == destination) {
        return new Path.weightedHalf(root, destination, weight);
      }
    }
    return new Path.weighted(root, destination, weight);
  }
}
