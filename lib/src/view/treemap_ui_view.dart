library treemap_ui_view;

import 'dart:html' hide Node;
import 'dart:async';
import '../../treemap_ui.dart' show Treemap;
import '../model/treemap_ui_model.dart';
import '../utils/treemap_ui_utils.dart';
export '../utils/treemap_ui_utils.dart' show Orientation, Color;

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

abstract class NodeContainer extends Attachable{
  
  void add(Node child);
  
  void addLayoutAid(LayoutAid layoutAid);
  
  BranchNode get nodeContainerRoot;
  
  Rect get client;

}
