library treemap.view;

import 'dart:html' hide Node;
import 'dart:async';
import '../../treemap.dart' show Treemap;
import '../model/treemap_model.dart';
import '../utils/treemap_utils.dart';
export '../utils/treemap_utils.dart' show Orientation, Color;

part 'node.dart';
part 'leaf_node.dart';
part 'branch_node.dart';
part 'layout_aid.dart';
part 'view_model.dart';
part 'treemap_style.dart';
part 'tooltip.dart';
part 'node_label.dart';

const String NAVIGATION_ELEMENT = "navigation-element";
final ArgumentError nullError = new ArgumentError("Please pass a valid reference. NULL is not supported!");

abstract class Attachable {
  Element get container;
}
