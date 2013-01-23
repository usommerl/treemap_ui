library treemap;

import 'dart:html' hide Node;
import 'src/model/treemap_model.dart';
export 'src/model/treemap_model.dart';
import 'src/view/treemap_view.dart';
export 'src/view/treemap_view.dart' show Orientation, TreemapStyle;
import 'src/layout/treemap_layout.dart';
export 'src/layout/treemap_layout.dart';

class Treemap{

   LayoutAlgorithm layoutAlgorithm;
   TreemapStyle style;
   bool isNavigatable = true;

   Treemap(DivElement htmlRoot, DataModel dataModel, {this.layoutAlgorithm, this.style}) {
     if (layoutAlgorithm == null) {
       layoutAlgorithm = new Squarified();
     }
     if (style == null) {
       style = new TreemapStyle();
     }
     final viewModel = new ViewModel(this, htmlRoot, style);
     final rootNode = new Node.forRoot(dataModel, viewModel);
     if (rootNode.isBranch) {
       layoutAlgorithm.layout(rootNode);
     }
   }
}