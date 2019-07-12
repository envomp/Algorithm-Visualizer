import 'dart:math';

import 'simulation/node.dart';

bool askForInformation(int whereToAsk, int whatToAsk) => whereToAsk | whatToAsk == whereToAsk;

double pythagoreanTheorem(Node node, Node existing) => sqrt((pow(node.xCoordinate - existing.xCoordinate, 2)) + (pow(node.yCoordinate - existing.yCoordinate, 2)));

double pythagoreanTheoremAll(double x1, double y1, double x2, double y2) => sqrt((pow(x1 - x2, 2)) + (pow(y1 - y2, 2)));

double angleInBetween(Node a, Node b) => (atan2(a.x - b.x, b.y - a.y) - pi / 2) % (2 * pi);
