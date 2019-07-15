import 'dart:math';
import 'dart:ui';

import 'package:AlgorithmVisualizer/formulas/formulas.dart';
import 'package:AlgorithmVisualizer/model/lesson.dart';
import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';

const NODE_SIZE = 128.0;
const DEGREE_TO_RADIAN = 57.29577957;
const PROPORTIONAL_ROTATION_RATE = 40;

class TempNode extends Node {
	double nodeSize;

	TempNode(this.nodeSize) : super(null, null, nodeSize);

	void initTempNode() {
		x = xCoordinate;
		y = yCoordinate;
		anchor = Anchor.center;
	}

	@override
	void render(Canvas canvas) {
		prepareCanvas(canvas);
		sprite.render(canvas, width, height);

		ParagraphBuilder paragraph = new ParagraphBuilder(new ParagraphStyle());
		paragraph.pushStyle(new TextStyle(color: new Color(0xffc4ff0e), fontSize: nodeSize / 2));
		paragraph.addText('q');
		Paragraph nodeWeightText = paragraph.build()
			..layout(new ParagraphConstraints(width: 180.0));
		canvas.drawParagraph(nodeWeightText, new Offset((nodeSize - nodeWeightText.minIntrinsicWidth) / 2, (nodeSize - nodeWeightText.height) / 2));
	}
}

class Node extends SpriteComponent {
  int weight = 1;
  int visualWeightAfterPathFinding;
  Lesson lesson;
  bool userOverrideSprite = false;

  double xCoordinate;
  double yCoordinate;
  final double nodeSize;

  List<Path> outgoingConnectedNodes = [];

  Node(this.xCoordinate, this.yCoordinate, this.nodeSize) : super.square(nodeSize, 'node.png');

  Node.weighted(this.xCoordinate, this.yCoordinate, this.nodeSize, this.weight) : super.square(nodeSize, weight < 0 ? 'nodeNegative.png' : 'node.png');

  void initNode(Lesson lesson) {
    x = xCoordinate;
    y = yCoordinate;
    anchor = Anchor.center;
    this.lesson = lesson;

    if (weight != null) {
      visualWeightAfterPathFinding = weight;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (visualWeightAfterPathFinding != null) {
      ParagraphBuilder paragraph = new ParagraphBuilder(new ParagraphStyle());
      paragraph.pushStyle(new TextStyle(color: new Color(0xff000000), fontSize: min(max(8, 10 + weight.abs() / 6 - lesson.nodes / 10), nodeSize / 2)));
      paragraph.addText(pow(2, 20) == visualWeightAfterPathFinding ? '∞' : visualWeightAfterPathFinding.floor().toString());
	  Paragraph nodeWeightText = paragraph.build()
		  ..layout(new ParagraphConstraints(width: 180.0));

      canvas.drawParagraph(nodeWeightText, new Offset((nodeSize - nodeWeightText.minIntrinsicWidth) / 2, (nodeSize - nodeWeightText.height) / 2));
    }
  }

  @override
  void update(double t) {
    //this.angle += nodeSize / (PROPORTIONAL_ROTATION_RATE * DEGREE_TO_RADIAN);
  }

  void activate() {
    if (!userOverrideSprite) {
      sprite = new Sprite('nodeActive.png');
    }
  }

  void highLightActivate() {
	  sprite = new Sprite('node_path.png');
	  userOverrideSprite = true;
  }

  void activateUserOverride() {
    sprite = new Sprite('node_user.png');
    userOverrideSprite = true;
  }

  void deactivate() {
    userOverrideSprite = false;
    if (weight < 0) {
      sprite = new Sprite('nodeNegative.png');
    } else {
      sprite = new Sprite('node.png');
    }
  }

  void activateNegativeCycle() {
    if (!userOverrideSprite) {
      sprite = new Sprite('nodeNegative.png');
      userOverrideSprite = true;
    }
  }
}

class Path extends SpriteComponent {
  int weight = 0;
  bool full;
  bool userOverrideSprite = false;
  final Node rootNode;
  final Node destinationNode;

  Path(this.rootNode, this.destinationNode) : super.rectangle(1, pythagoreanTheorem(rootNode, destinationNode) - rootNode.nodeSize / 2 - destinationNode.nodeSize / 2, 'path_reversed.png') {
    full = true;
  }

  Path.half(this.rootNode, this.destinationNode) : super.rectangle(1, pythagoreanTheorem(rootNode, destinationNode) / 2, 'path.png') {
    full = false;
  }

  Path.weighted(this.rootNode, this.destinationNode, this.weight)
      : super.rectangle(1, pythagoreanTheorem(rootNode, destinationNode) - rootNode.nodeSize / 2 - destinationNode.nodeSize / 2, weight < 0 ? 'path_reversed_negative.png' : 'path_reversed.png') {
    full = true;
  }

  Path.weightedHalf(this.rootNode, this.destinationNode, this.weight) : super.rectangle(1, pythagoreanTheorem(rootNode, destinationNode) / 2, weight < 0 ? 'path_negative' : 'path.png') {
    full = false;
  }

  void initPath() {
    double deltaX = destinationNode.x - rootNode.x;
    double deltaY = destinationNode.y - rootNode.y;

    double coeff = 1 - (pythagoreanTheorem(rootNode, destinationNode) - rootNode.nodeSize / 2) / pythagoreanTheorem(rootNode, destinationNode);

    x = rootNode.x + coeff * deltaX;
    y = rootNode.y + coeff * deltaY;
    anchor = Anchor.bottomCenter;
    angle = angleInBetween(rootNode, destinationNode) - pi / 2;
  }

  void activate() {
	  if (!userOverrideSprite) {
		  if (full) {
			  sprite = new Sprite('path_reversed_active.png');
		  } else {
			  sprite = new Sprite('path_active.png');
		  }
    }
  }

  void highLightActivate() {
	  if (full) {
		  sprite = new Sprite('path_reversed_path.png');
	  } else {
		  sprite = new Sprite('path_path.png');
	  }
	  userOverrideSprite = true;
  }

  void deactivate() {
    if (full) {
      if (weight < 0) {
        sprite = new Sprite('path_negative_reversed.png');
      } else {
        sprite = new Sprite('path_reversed.png');
      }
    } else {
      if (weight < 0) {
        sprite = new Sprite('path_negative.png');
      } else {
        sprite = new Sprite('path.png');
      }
    }

	userOverrideSprite = false;
  }

  void activateNegativeCycle() {
	  userOverrideSprite = true;
	  if (full) {
		  sprite = new Sprite('path_reversed_negative.png');
	  } else {
		  sprite = new Sprite('path_negative.png');
	  }
  }
}
