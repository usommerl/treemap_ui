library treemap_ui;

import 'dart:html' hide Node;
import 'dart:async';
import 'model.dart';
export 'model.dart';
import 'view.dart';
export 'view.dart' show TreemapStyle, LeafDecorator, BranchDecorator, Orientation, Color;
import 'layout.dart';
export 'layout.dart';

/// An object which creates and controls a treemap UI-component on a web page.
class Treemap{
 
   /**
    * Enable or disable mouse navigation.
    *
    * If set to [:true:] the user can descend or ascend in the hierarchy of 
    * the data model by clicking on the padding area or label of a branch.
    */
   bool isTraversable = true;

   /**
    * Enable or disable tooltips globally.
    *
    * Regardless of this setting no tooltip will be displayed if the 
    * underlying [DataModel] doesn't provide the necessary content.
    */
   bool showTooltips = true;

   /**
    * Controls whether the treemap instance repaints itself 
    * automatically when the underlying data model has changed.
    *
    * Regardless of this setting the treemap will always be repainted 
    * after the [style] object was altered.
    */
   bool liveUpdates = true;

   TreemapStyle _style;
   LayoutAlgorithm _layoutAlgorithm;
   DataModel _dataModel;
   StyleElement _currentActiveStyle;
   Node _rootNode;
   StreamSubscription<num> _modelChangeSubscription;
   BranchDecorator _branchDecorator;
   LeafDecorator _leafDecorator;
   DisplayArea _displayArea;

   /**
    * Creates a new treemap instance.
    * 
    * The [displayArea] argument has to be attached to the DOM 
    * and has to have a height greater than zero.
    */
   Treemap(DivElement displayArea, DataModel this._dataModel, LayoutAlgorithm this._layoutAlgorithm, 
           {TreemapStyle style, 
            BranchDecorator branchDecorator: const DefaultBranchDecorator(),
            LeafDecorator leafDecorator: const DefaultLeafDecorator()
   }){
     if (displayArea == null || _dataModel == null || _layoutAlgorithm == null 
         || branchDecorator == null || leafDecorator == null) {
       throw nullError;
     }
     _style = style == null ? new TreemapStyle() : style;
     _branchDecorator = branchDecorator;
     _leafDecorator = leafDecorator;
     _displayArea = new DisplayArea(displayArea);
     
     _registerModelChangeSubscription();
     _registerStyleUpdateSubscription();
     _setTreemapStyle();
     repaint();
   }
   
   /// Repaints the treemap.
   void repaint() {
     ViewModel viewModel;
     if (_rootNode == null) {
       viewModel = new ViewModel(this,_displayArea,_branchDecorator,_leafDecorator);
     } else {
       _rootNode.cancelSubscriptions();
       viewModel = _rootNode.viewModel;
     }
     _rootNode = new Node.forRoot(model, viewModel);
     _displayArea.purgeAndSet(viewModel);
     _displayArea.append(_rootNode.shell);
     if (_rootNode.isBranch) {
       layoutAlgorithm.layout(_rootNode as BranchNode);
     }
     viewModel.rootNode = _rootNode;
   }

   /// The data model of this treemap
   DataModel get model => _dataModel;

   set model(DataModel model) {
     if (model == null) {
       throw nullError;
     }
     _dataModel = model;
     _registerModelChangeSubscription();
     if (liveUpdates) {
       repaint();
     }
   }

   /// Algorithm that is used to tile the [displayArea].
   LayoutAlgorithm get layoutAlgorithm => _layoutAlgorithm;

   set layoutAlgorithm(LayoutAlgorithm algorithm) {
     if (algorithm == null) {
       throw nullError;
     }
     _layoutAlgorithm = algorithm;
     if (liveUpdates) {
       repaint();
     }
   }

   /// Style that controls various visual aspects of the treemap.
   TreemapStyle get style => _style;

   void _registerModelChangeSubscription() {
     if (_modelChangeSubscription != null) {
       _modelChangeSubscription.cancel();
     }
     _modelChangeSubscription = _dataModel.onStructuralChange.listen((_) {
       if (liveUpdates) {
         repaint();
       }
     });
   }

   void _registerStyleUpdateSubscription() {
     style.onChange.listen((_) {
         _setTreemapStyle();
         repaint();
     });
   }

   void _setTreemapStyle() {
     final StyleElement styleElement = style.inlineStyle;
     if (_currentActiveStyle != null) {
       document.head.children.remove(_currentActiveStyle);
     }
     final styleOrLinkElements = document.head.children.where((e) => e.runtimeType == StyleElement || e.runtimeType == LinkElement);
     if (styleOrLinkElements.isEmpty) {
       document.head.append(styleElement);
     } else {
       styleOrLinkElements.first.insertAdjacentElement('beforeBegin', styleElement);
     }
     _currentActiveStyle = styleElement;
   }
}
