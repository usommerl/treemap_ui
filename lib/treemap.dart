library treemap;

import 'dart:html';
import 'dart:math';
part 'src/layout_algorithm.dart';
part 'src/slice_and_dice.dart';
part 'src/model.dart';
part 'src/view_node.dart';

class TreeMap{

   DivElement rootArea;
   ViewNode rootNode;
   DataModel dataModel;
   LayoutAlgorithm algorithm;

   TreeMap(this.rootArea, this.dataModel, this.algorithm) {
     rootNode = new ViewNode.from(rootArea, dataModel);
     algorithm.layout(rootNode);
   }
}