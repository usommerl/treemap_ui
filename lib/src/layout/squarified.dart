part of treemap_ui.layout;

/**
 * Implementation of the squarified layout algorithm. For further details see
 * 'Squarified Treemaps' by Mark Bruls, Kees Huizing, Jarke J. van Wijk.
 * Joint Eurographics and IEEE TCVG Symposium on Visualization,
 * IEEE Computer Society, pp. 33-42, 2000.
 **/
class Squarified extends LayoutAlgorithm with LayoutUtils {

  void layout(BranchNode parent) {
    List<DataModel> currentRow = [];
    final descendingSizes = ((a,b) => b.size.compareTo(a.size));
    Queue<DataModel> queue = new Queue.from(sortedCopy(parent.dataModel.children, descendingSizes));
    NodeContainer layoutParent = parent;
    while(!queue.isEmpty) {
      final model = queue.removeFirst();
      final previousRow = new List.from(currentRow);
      currentRow.add(model);
      final orientation = _determineOrientation(layoutParent);
      final prevWorstAspectRatio = _worstAspectRatio(layoutParent, previousRow, orientation);
      final currWorstAspectRatio = _worstAspectRatio(layoutParent, currentRow, orientation);
      if (!previousRow.isEmpty && prevWorstAspectRatio < currWorstAspectRatio) {
        layoutParent = _layoutRow(layoutParent, previousRow, orientation);
        currentRow.clear();
        queue.addFirst(model);
      } else if (queue.isEmpty) {
        layoutParent = _layoutRow(layoutParent, currentRow, orientation);
      }
    }
    if (layoutParent is LayoutAid) {
      layoutParent.container.remove();      
    }
  }

  NodeContainer _layoutRow(NodeContainer parent, List<DataModel> rowModels, Orientation orientation) {
    final num sumModels = rowModels.reduce(0, (acc,model) => acc + model.size);
    final num sumNotPlacedModels = _notPlacedModels(parent).reduce(0, (acc, model) => acc + model.size);
    final percentageRowItems = new Percentage.from(sumModels, sumNotPlacedModels);
    final row = new LayoutAid.expand(percentageRowItems, parent, orientation);
    final newLayoutParent = new LayoutAid.expand(Percentage.ONE_HUNDRED - percentageRowItems, parent, orientation);
    rowModels.forEach((model) {
      final node = _createNodeForRow(model, parent.nodeContainerRoot.viewModel, new Percentage.from(model.size, sumModels), orientation);
      row.add(node);
      if (node.isBranch) {
        layout(node);
      }
    });
    return newLayoutParent;
  }

  Orientation _determineOrientation(NodeContainer node) =>
      node.client.width > node.client.height ?
          Orientation.VERTICAL :
          Orientation.HORIZONTAL;
  
  num _availableWidth(NodeContainer nodeContainer) => nodeContainer.client.width;

  num _availableHeight(NodeContainer nodeContainer) => nodeContainer.client.height;

  num _worstAspectRatio(NodeContainer parent, Collection<DataModel> models, Orientation orientation) =>
      _aspectRatios(parent, models, orientation).reduce(0, (accum,ratio) => max(accum,ratio));

}
