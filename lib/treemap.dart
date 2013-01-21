library treemap;

import 'dart:html' hide Node;
import 'src/model/treemap_model.dart';
export 'src/model/treemap_model.dart';
import 'src/view/treemap_view.dart';
import 'src/layout/treemap_layout.dart';
export 'src/layout/treemap_layout.dart';

part 'treemap_style.dart';

class Treemap{
   
   final LayoutAlgorithm algorithm;
   bool isNavigatable = true;

   Treemap(DivElement htmlRoot, DataModel dataModel, this.algorithm) {
     final style = new TreemapStyle(branchPadding : 2);
     final viewModel = new ViewModel(this, htmlRoot, style);
     final rootNode = new Node.forRoot(dataModel, viewModel);
     if (rootNode.isBranch) {
       algorithm.layout(rootNode);       
     }
   }
}