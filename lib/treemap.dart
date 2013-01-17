library treemap;

import 'treemap_model.dart';
export 'treemap_model.dart';
import 'treemap_view.dart';
export 'treemap_view.dart' show Orientation;
import 'treemap_layout.dart';
export 'treemap_layout.dart';

class TreeMap{
   
   final LayoutAlgorithm algorithm;
   bool isNavigatable = true;

   TreeMap(DivElement htmlRoot, DataModel dataModel, this.algorithm) {
     final viewModel = new ViewModel(this, htmlRoot);
     final rootNode = new Node.forRoot(dataModel, viewModel);
     if (rootNode.isBranch) {
       algorithm.layout(rootNode);       
     }
   }
}