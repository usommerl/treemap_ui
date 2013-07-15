library treemap_ui.view;

import 'dart:html' hide Node;
import 'dart:html' as html show Node;
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
part 'src/view/decorator.dart';
part 'src/view/default_branch_decorator.dart';
part 'src/view/default_leaf_decorator.dart';
part 'src/view/display_area.dart';

const String NAVIGATION_ELEMENT = "navigation-element";
final ArgumentError nullError = new ArgumentError("Please pass a valid reference. NULL is not supported!");

abstract class Attachable {
  Element get shell;
}

abstract class NodeContainer extends Attachable{
  
  void add(Node child);
  
  void mount(LayoutAid layoutAid);
  
  BranchNode get node;
  
  Rect get client;

}
