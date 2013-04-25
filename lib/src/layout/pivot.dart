part of treemap_ui.layout;

typedef DataModel PivotSelectionStrategy(Iterable<DataModel> models);

PivotSelectionStrategy bySize = 
  (Iterable<DataModel> models) => models.reduce((value, element) {
    if (element.size > value.size) {
      value = element;
    }
    return value;
  });

PivotSelectionStrategy byMiddle = 
  (Iterable<DataModel> models) => models.elementAt(models.length ~/ 2);

/**
 * Implementation of the pivot layout algorithm. For further details see
 * 'Ordered Treemap Layouts' by Ben Shneiderman and Martin Wattenberg.
 * In proceedings of the IEEE Symposium on Information Visualization (INFOVIS),
 * IEEE Computer Society, pp. 73-78, 2001.
 **/
class Pivot extends LayoutAlgorithm with LayoutUtils {
    
  PivotSelectionStrategy _selectionStrategy;
  
  Pivot([PivotSelectionStrategy selectionStrategy]) {
    if (?selectionStrategy) {
      _selectionStrategy = selectionStrategy;
    } else {
      _selectionStrategy = bySize;
    }
  }
  
  void layout(BranchNode parent) {
    _layoutRecursive(parent.dataModel.children, parent);
  }
 
  void _layoutRecursive(Iterable<DataModel> models, NodeContainer container) {
    if (models.isEmpty) {
      return;
    } else if (models.length == 1) {
      Node node = new Node(models.first, container.nodeContainerRoot.viewModel, Percentage.ONE_HUNDRED, Percentage.ONE_HUNDRED, Orientation.VERTICAL);
      container.add(node);
      if (node.isBranch) {
        layout(node);
      }
    } else {
      // Please make sure that your custom pivot selection strategy does not return invalid values
      final pivot = _selectionStrategy(models);
      assert(pivot != null && models.contains(pivot));
      final List<DataModel> l1 = models.takeWhile((e) => !identical(e,pivot)).toList();
      final List<DataModel> l2 = models.skipWhile((e) => !identical(e,pivot)).skip(1).toList();
      final List<DataModel> l3 = [];
      final orientation = _determineOrientation(container);
      num currPivotAspectRatio = _pivotAspectRatio(pivot, l2, models, container, orientation);
      num prevPivotAspectRatio = currPivotAspectRatio + 1;
      while(!l2.isEmpty && currPivotAspectRatio < prevPivotAspectRatio) {
        prevPivotAspectRatio = currPivotAspectRatio;
        l3.insert(0, l2.removeLast());
        currPivotAspectRatio = _pivotAspectRatio(pivot, l2, models, container, orientation);
      }
      if (!l3.isEmpty) {
        l2.add(l3.removeAt(0));
      }
      // Determined pivot,l1,l2,l3 => now create layout
      final sumSizesAllModels = models.fold(0, (acc,e) => acc + e.size);
      if (!l1.isEmpty) {
        final percentageL1 = new Percentage.from(l1.fold(0, (acc,e) => acc + e.size), sumSizesAllModels);
        final r1 = new LayoutAid.expand(percentageL1, container, orientation);
        _layoutRecursive(l1,r1);
      }
      final sumSizesPivotAndL2 = pivot.size + l2.fold(0, (acc,e) => acc + e.size);
      final percentageX = new Percentage.from(sumSizesPivotAndL2, sumSizesAllModels);
      final percentageY = new Percentage.from(pivot.size, sumSizesPivotAndL2);
      final layoutAidRpAndR2 = new LayoutAid.expand(percentageX, container, orientation); 
      final rp = _createNodeForRow(pivot, container.nodeContainerRoot.viewModel, percentageY, orientation);
      layoutAidRpAndR2.add(rp);
      if (rp.isBranch) {
        layout(rp);
      }
      if (!l2.isEmpty) {
        final orientationR2 = orientation.isVertical ? Orientation.HORIZONTAL : Orientation.VERTICAL;
        final r2 = new LayoutAid.expand(Percentage.ONE_HUNDRED - percentageY, layoutAidRpAndR2, orientationR2);
        r2.container.style.float = orientation.isVertical ? "none" : "left";
        _layoutRecursive(l2, r2);
      }
      if (!l3.isEmpty) {
        final percentageR3 = new Percentage.from(l3.fold(0, (acc,e) => acc + e.size), sumSizesAllModels);
        final r3 = new LayoutAid.expand(percentageR3, container, orientation);
        _layoutRecursive(l3, r3);
      }
    }
  }
      
  num _pivotAspectRatio(DataModel pivot, List<DataModel> l2, List<DataModel> allModels, NodeContainer container, Orientation orientation) {
    final sumSizesPivotAndL2 = pivot.size + l2.fold(0, (acc,e) => acc + e.size);
    final percentageX = new Percentage.from(sumSizesPivotAndL2, allModels.fold(0, (acc,e) => acc + e.size));
    final percentageY = new Percentage.from(pivot.size, sumSizesPivotAndL2);
    num x,y;
    if (orientation.isVertical) {
      x = percentageX.percentageValue(container.client.width);
      y = percentageY.percentageValue(container.client.height);
    } else {
      x = percentageX.percentageValue(container.client.height);
      y = percentageY.percentageValue(container.client.width);
    }
    return _aspectRatio(x,y);
  }
  
  Orientation _determineOrientation(NodeContainer parent) =>
      parent.container.client.width >= parent.container.client.height ?
          Orientation.VERTICAL :
          Orientation.HORIZONTAL;
  
  num _availableWidth(NodeContainer nodeContainer) {
    throw new UnsupportedError("Not needed for pivot algorithm");    
  }

  num _availableHeight(NodeContainer nodeContainer) {
    throw new UnsupportedError("Not needed for pivot algorithm");    
  }
  
}
