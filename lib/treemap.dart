library treemap;

import 'dart:html' hide Node;
import 'dart:async';
import 'src/model/treemap_model.dart';
export 'src/model/treemap_model.dart';
import 'src/view/treemap_view.dart';
export 'src/view/treemap_view.dart' show TreemapStyle, Orientation, Color;
import 'src/layout/treemap_layout.dart';
export 'src/layout/treemap_layout.dart';

class Treemap{

   LayoutAlgorithm _layoutAlgorithm;
   DataModel _dataModel;
   TreemapStyle _style;
   DivElement _htmlRoot;
   StreamSubscription<num> _sizeUpdateSubscription;
   bool isNavigatable = true;
   bool showTooltips = true;
   bool automaticUpdates = true;
   
   Treemap(DivElement this._htmlRoot, DataModel this._dataModel, 
           {LayoutAlgorithm algorithm, TreemapStyle this._style}) {
     if (algorithm == null) {
       _layoutAlgorithm = new Squarified();
     } else {
       _layoutAlgorithm = algorithm;
     }
     if (_style == null) {
       _style = new TreemapStyle();
     }
     _registerSizeUpdateSubscription();
     repaint();
   }
   
   void repaint() {
     _htmlRoot.children.clear();
     final viewModel = new ViewModel(this, _htmlRoot, _style);
     final rootNode = new Node.forRoot(model, viewModel);
     if (rootNode.isBranch) {
       layoutAlgorithm.layout(rootNode);
     }
   }
   
   void _registerSizeUpdateSubscription() {
     if (_sizeUpdateSubscription != null) {
       _sizeUpdateSubscription.cancel();
     }
     _sizeUpdateSubscription = _dataModel.onSizeChange.listen((_) { if (automaticUpdates) { repaint(); } });
   }
   
   DataModel get model => _dataModel;
   
   set model(DataModel model) {
     _dataModel = model;
     _registerSizeUpdateSubscription();
     if (automaticUpdates) { 
       repaint(); 
     }
   }
   
   LayoutAlgorithm get layoutAlgorithm => _layoutAlgorithm;
   
   set layoutAlgorithm(LayoutAlgorithm algorithm) {
     _layoutAlgorithm = algorithm;
     if (automaticUpdates) { 
       repaint(); 
     }
   }
}