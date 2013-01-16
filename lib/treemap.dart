library treemap;

import 'treemap_model.dart';
export 'treemap_model.dart';
import 'treemap_view.dart';
export 'treemap_view.dart' show Orientation;
import 'treemap_layout.dart';
export 'treemap_layout.dart';

class TreeMap{

   DivElement htmlRoot;
   Node rootNode;
   DataModel dataModel;
   LayoutAlgorithm algorithm;

   TreeMap(this.htmlRoot, this.dataModel, this.algorithm) {
     rootNode = new Node.forRoot(htmlRoot, dataModel);
     if (rootNode.isBranch) {
       algorithm.layout(rootNode);       
     }
   }
}