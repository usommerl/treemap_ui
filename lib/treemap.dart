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

   final TreemapStyle _style = new TreemapStyle();
   final DivElement componentRoot;
   LayoutAlgorithm _layoutAlgorithm;
   DataModel _dataModel;
   StyleElement _currentActiveStyle;
   Node _rootNode;
   StreamSubscription<num> _modelChangeSubscription;
   bool isTraversable = true;
   bool showTooltips = true;
   bool automaticRepaintsEnabled = true;

   Treemap(DivElement this.componentRoot, DataModel this._dataModel, LayoutAlgorithm this._layoutAlgorithm) {
//    assert(componentRoot.clientHeight > 0);
//    assert(componentRoot.children.length == 0);
     _registerModelChangeSubscription();
     _registerStyleUpdateSubscription();
     _setTreemapStyle();
     repaint();
   }

   void repaint() {
     ViewModel viewModel;
     if (_rootNode != null) {
       _rootNode.cancelSubscriptions();
       viewModel = _rootNode.viewModel;
     } else {
       viewModel = new ViewModel(this);
     }
     _rootNode = new Node.forRoot(model, viewModel);
     componentRoot.children.clear();
     componentRoot.append(_rootNode.container);
     if (_rootNode.isBranch) {
       layoutAlgorithm.layout(_rootNode);
     }
     viewModel.resetViewRoot(_rootNode);
   }

   DataModel get model => _dataModel;

   set model(DataModel model) {
     _dataModel = model;
     _registerModelChangeSubscription();
     if (automaticRepaintsEnabled) {
       repaint();
     }
   }

   LayoutAlgorithm get layoutAlgorithm => _layoutAlgorithm;

   set layoutAlgorithm(LayoutAlgorithm algorithm) {
     _layoutAlgorithm = algorithm;
     if (automaticRepaintsEnabled) {
       repaint();
     }
   }

   TreemapStyle get style => _style;
   
   void _registerModelChangeSubscription() {
     if (_modelChangeSubscription != null) {
       _modelChangeSubscription.cancel();
     }
     _modelChangeSubscription = _dataModel.onModelChange.listen((_) {
       if (automaticRepaintsEnabled) {
         repaint();
       }
     });
   }

   void _registerStyleUpdateSubscription() {
     style.onStyleChange.listen((_) {
         _setTreemapStyle();
         repaint();
     });
   }

   void _setTreemapStyle() {
     final StyleElement sty = style.inlineStyle;
     if (_currentActiveStyle != null) {
       document.head.children.remove(_currentActiveStyle);
     }
     final styleOrLinkElements = document.head.children.where((e) => e.runtimeType == StyleElement || e.runtimeType == LinkElement);
     if (styleOrLinkElements.isEmpty) {
       document.head.append(sty);
     } else {
       styleOrLinkElements.first.insertAdjacentElement('beforeBegin', sty);
     }
     _currentActiveStyle = sty;
   }
}