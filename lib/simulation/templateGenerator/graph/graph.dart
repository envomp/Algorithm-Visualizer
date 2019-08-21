import 'dart:math';
import 'dart:ui';

import 'package:AlgorithmVisualizer/formulas/formulas.dart';
import 'package:AlgorithmVisualizer/model/lesson.dart';
import 'package:AlgorithmVisualizer/simulation/algorithms/pathfinding/a_star.dart';
import 'package:AlgorithmVisualizer/simulation/algorithms/pathfinding/bellman_ford.dart';
import 'package:AlgorithmVisualizer/simulation/algorithms/pathfinding/dijkstra.dart';
import 'package:AlgorithmVisualizer/simulation/algorithms/pathfinding/floyd_warshall.dart';
import 'package:AlgorithmVisualizer/simulation/algorithms/pathfinding/johnsons.dart';
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
	this.minNodeSize = max((38 - lesson.nodes / 5) * min(pow(lesson.screenSize / 300000, 0.5), 2), 28 - lesson.nodes / 5);
	this.maxNodeSize = max((48 - lesson.nodes / 5) * min(pow(lesson.screenSize / 300000, 0.5), 2), 38 - lesson.nodes / 5);
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
			  case AlgorithmTypes.pathFinding:
              pathFindingSimulationStates();
              break;
			  case AlgorithmTypes.proofOfConcept:
              switch (lesson.title) {
                case "Four color theorem":
                  break;
              }
              break;
			  case AlgorithmTypes.all:
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
		  if (executiveAlgorithm.preSolve) {
			  if (root == null) {
				  setAppBarMessage('Select root');
			  } else if (destination == null) {
				  setAppBarMessage('Select destination');
			  } else {
				  hardReset = true;
				  setAppBarMessage('Press on screen to reset root and destination');
			  }
			  executiveAlgorithm.root = root;
			  executiveAlgorithm.destination = destination;
		  } else {
			  //reset simulation
			  setAppBarMessage('Press on screen to reset the simulation');
			  hardReset = true;
		  }
		  isHandleInput = true;
      } else {
        // run simulation
		  setAppBarMessage('Running simulation');
		  if (!executiveAlgorithm.done) {
			  if (askForInformation(lesson.simulationDetails, lesson.stepByStep)) {
				  executiveAlgorithm.step();
			  } else {
				  executiveAlgorithm.allInOne();
			  }
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
        }
        break;
      case "A-star algorithm":
        if (checkRequirementsFull()) {
			executiveAlgorithm = AStarAlgorithm(root, destination, nodes, paths);
        }
        break;
      case "Bellman–Ford algorithm":
        if (checkRequirementsToAllNodes()) {
			executiveAlgorithm = BellmanFordAlgorithm(root, destination, nodes, paths);
        }
        break;
      case "Floyd-Warshall algorithm":
		  if (checkRequirements()) {
			  executiveAlgorithm = FloydWarshallAlgorithm(root, destination, nodes, paths);
		  }
		  break;
      case "Johnson's algorithm":
		  if (checkRequirements()) {
			  executiveAlgorithm = JohnsonsAlgorithm(root, destination, nodes, paths);
		  }
		  break;
    }
	isHandleInput = executiveAlgorithm == null;
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
		  if (executiveAlgorithm != null && executiveAlgorithm.preSolve) {
			  for (Node node in nodes) {
				  node.visualWeightAfterPathFinding = node.weight;
				  node.userOverrideSprite = false;
				  if (node.weight < 0) {
					  node.activateNegativeCycle();
				  } else {
					  node.activate();
				  }
			  }
			  for (Path path in paths) {
				  path.userOverrideSprite = false;
				  path.activate();
			  }
		  } else {
			  for (Node node in nodes) {
				  node.visualWeightAfterPathFinding = node.weight;
				  node.userOverrideSprite = false;
				  node.deactivate();
			  }
			  for (Path path in paths) {
				  path.deactivate();
			  }
			  executiveAlgorithm = null;
		  }

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
		this.newNode(t, askForInformation(lesson.additionalInformation, lesson.weightsOnNodes) ? weightedNodeCreation : nodeCreation, size);
    } else {
      state = States.drawConnections;
      elapsedTime = 0;
    }
  }

  void newNode(double t, creationMethod, Size size) {
    // creates a new node with no overlap
    elapsedTime += t;
	if (elapsedTime > 1) {
		int counter = 10;
		while (counter > 0) {
			Node node = creationMethod(size);
			bool overlapping = false;
			// check that it is not overlapping with any existing circle
			// another brute force approach
			for (var i = 0; i < nodes.length; i++) {
				var existing = nodes[i];
				double d = pythagoreanTheorem(node, existing);
				if (d < (existing.nodeSize + maxNodeSize) / 1.6) {
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
			counter--;
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

  double generateYCoordinate(nodeSize, size) => min(size.height, ((elapsedTime - 0.5) / lesson.nodes * proportionalMultiplier) * rnd.nextDouble() * size.height);

  double generateXCoordinate(nodeSize, size) => rnd.nextDouble() * size.width;

  ///////////////////////// PATH INITIALIZATION CODE ///////////////////////////

  void pathInitialization(double t) {
	  int negativeNodes = nodes
		  .where((f) => f.weight < 0)
		  .toList()
		  .length;
	  if (paths.length < min(lesson.edges.floor(), ((nodes.length * (nodes.length - 1)) / 2 - (negativeNodes * (negativeNodes - 1)) / 2)) * (askForInformation(lesson.simulationDetails, lesson.directed) ? 1 : 2)) {
      //every undirected path counts as 2
		  try {
			  newPath(t, askForInformation(lesson.additionalInformation, lesson.weightsOnEdges) ? weightedPathCreation : pathCreation, (paths.length < (lesson.nodes.floor() - 1) * 2) ? treeGeneration : graphGeneration);
		  } catch (Exception) {
			  state = States.algorithm;
      }
    } else {
      state = States.algorithm;
	  destination = root = null;
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
	  root = notUsedNodes.where((f) => f.weight > 0).toList()[0];
	  notUsedNodes.remove(root);
      usedNodes.add(root);
    } else {
		List temp = usedNodes.where((f) => f.weight > 0).toList();
		temp = temp.sublist(max(0, temp.length - 10));
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

		if (tempAbs < closestDistance && potentiallyClosest.weight > 0) {
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
		if (outgoingPathsPerNode[i] < nodes.length - 1 && nodes[i].weight > 0) {
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
