import 'dart:math';
import 'dart:ui';

import 'package:AlgorithmVisualizer/formulas.dart';
import 'package:AlgorithmVisualizer/model/lesson.dart';
import 'package:box2d_flame/box2d.dart';
import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';

const NODE_SIZE = 128.0;
const DEGREE_TO_RADIAN = 57.29577957;
const PROPORTIONAL_ROTATION_RATE = 40;

class Node extends SpriteComponent {
  double weight;
  Paragraph nodeWeightText;

  final double xCoordinate;
  final double yCoordinate;
  final double nodeSize;

  Body body;
  List<Path> outgoingConnectedNodes = [];

  Node(this.xCoordinate, this.yCoordinate, this.nodeSize)
      : super.square(nodeSize, 'node.png');

  Node.weighted(this.xCoordinate, this.yCoordinate, this.nodeSize, this.weight)
      : super.square(nodeSize, weight < 0 ? 'nodeNegative.png' : 'node.png');

  void initNode(Lesson lesson) {
    x = xCoordinate;
    y = yCoordinate;
    anchor = Anchor.center;

    if (weight != null) {
      ParagraphBuilder paragraph = new ParagraphBuilder(new ParagraphStyle());
      paragraph.pushStyle(new TextStyle(
          color: new Color(0xff000000),
          fontSize: min(max(8, 10 + weight.abs() / 6 - lesson.nodes / 10),
              nodeSize / 2)));
      paragraph.addText(weight.floor().toString());
      nodeWeightText = paragraph.build()
        ..layout(new ParagraphConstraints(width: 180.0));
    }
  }

  @override
  void update(double t) {
    //this.angle += nodeSize / (PROPORTIONAL_ROTATION_RATE * DEGREE_TO_RADIAN);
  }

  void activate() {
    sprite = new Sprite('nodeActive.png');
  }

  void deactivate() {
    if (weight < 0) {
      sprite = new Sprite('nodeNegative.png');
    } else {
      sprite = new Sprite('node.png');
    }
  }
}

class Path extends SpriteComponent {
  double weight;

  final Node rootNode;
  final Node destinationNode;

  Path(this.rootNode, this.destinationNode)
      : super.rectangle(
            1,
            pythagoreanTheorem(rootNode, destinationNode) -
                rootNode.nodeSize / 2 -
                destinationNode.nodeSize / 2,
            'path_reversed.png');

  Path.half(this.rootNode, this.destinationNode)
      : super.rectangle(
            1, pythagoreanTheorem(rootNode, destinationNode) / 2, 'path.png');

  Path.weighted(this.rootNode, this.destinationNode, this.weight)
      : super.rectangle(
            1,
            pythagoreanTheorem(rootNode, destinationNode) -
                rootNode.nodeSize / 2 -
                destinationNode.nodeSize / 2,
            'path_reversed.png');

  Path.weightedHalf(this.rootNode, this.destinationNode, this.weight)
      : super.rectangle(
            1, pythagoreanTheorem(rootNode, destinationNode) / 2, 'path.png');

  void initPath() {
    double deltaX = destinationNode.x - rootNode.x;
    double deltaY = destinationNode.y - rootNode.y;

    double coeff = 1 -
        (pythagoreanTheorem(rootNode, destinationNode) -
                rootNode.nodeSize / 2) /
            pythagoreanTheorem(rootNode, destinationNode);

    x = rootNode.x + coeff * deltaX;
    y = rootNode.y + coeff * deltaY;
    anchor = Anchor.bottomCenter;
    angle = angleInBetween(rootNode, destinationNode) - pi / 2;
  }
}
