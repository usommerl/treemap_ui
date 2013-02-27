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
   LayoutAlgorithm _layoutAlgorithm;
   DataModel _dataModel;
   StyleElement _currentActiveStyle;
   DivElement _componentRoot;
   Node _rootNode;
   StreamSubscription<num> _modelChangeSubscription;
   bool isNavigatable = true;
   bool showTooltips = true;
   bool automaticUpdates = true;

   Treemap(DivElement this._componentRoot, DataModel this._dataModel, {LayoutAlgorithm algorithm}) {
     if (algorithm == null) {
       _layoutAlgorithm = new Squarified();
     } else {
       _layoutAlgorithm = algorithm;
     }
     _registerModelChangeSubscription();
     _registerStyleUpdateSubscription();
     _setTreemapStyle();
     repaint();
   }

   void repaint() {
     if (_rootNode != null) {
       _rootNode.cancelSubscriptions();
       _componentRoot.children.clear();
     }
     final viewModel = new ViewModel(this, _componentRoot, _style);
     _rootNode = new Node.forRoot(model, viewModel);
     if (_rootNode.isBranch) {
       layoutAlgorithm.layout(_rootNode);
     }
   }

   void _registerModelChangeSubscription() {
     if (_modelChangeSubscription != null) {
       _modelChangeSubscription.cancel();
     }
     _modelChangeSubscription = _dataModel.onModelChange.listen((_) {
       if (automaticUpdates) {
         repaint();
       }
     });
   }

   void _registerStyleUpdateSubscription() {
     _style.onStyleChange.listen((_) {
         _setTreemapStyle();
         repaint();
     });
   }

   void _setTreemapStyle() {
     final StyleElement style = _style.inlineStyle;
     if (_currentActiveStyle != null) {
       document.head.children.remove(_currentActiveStyle);
     }
     final styleOrLinkElements = document.head.children.where((e) => e.runtimeType == StyleElement || e.runtimeType == LinkElement);
     if (styleOrLinkElements.isEmpty) {
       document.head.append(style);
     } else {
       styleOrLinkElements.first.insertAdjacentElement('beforeBegin', style);
     }
     _currentActiveStyle = style;
   }

   DataModel get model => _dataModel;

   set model(DataModel model) {
     _dataModel = model;
     _registerModelChangeSubscription();
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

   TreemapStyle get style => _style;
}