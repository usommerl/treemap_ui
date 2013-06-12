library treemap_ui.view;

import 'dart:html' hide Node;
import 'dart:async';
import 'treemap_ui.dart' show Treemap;
import 'model.dart';
import 'utils.dart';
export 'utils.dart' show Orientation, Color;

part 'src/view/node.dart';
part 'src/view/leaf_node.dart';
part 'src/view/branch_node.dart';
part 'src/view/layout_aid.dart';
part 'src/view/view_model.dart';
part 'src/view/treemap_style.dart';
part 'src/view/tooltip.dart';
part 'src/view/node_label.dart';

const String NAVIGATION_ELEMENT = "navigation-element";
final ArgumentError nullError = new ArgumentError("Please pass a valid reference. NULL is not supported!");

abstract class Attachable {
  Element get container;
}

abstract class NodeContainer extends Attachable{
  
  void add(Node child);
  
  void mount(LayoutAid layoutAid);
  
  BranchNode get node;
  
  Rect get client;

}
