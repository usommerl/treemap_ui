library treemap;

import 'treemap_model.dart';
export 'treemap_model.dart';
import 'treemap_view.dart';
export 'treemap_view.dart' show Orientation;
import 'treemap_layout.dart';
export 'treemap_layout.dart';

class TreeMap{

   DivElement rootArea;
   TreemapNode rootNode;
   DataModel dataModel;
   LayoutAlgorithm algorithm;

   TreeMap(this.rootArea, this.dataModel, this.algorithm) {
     rootNode = new TreemapNode.root(rootArea, dataModel);
     if (rootNode.model.isBranch) {
       algorithm.layout(rootNode);       
     }
   }
}