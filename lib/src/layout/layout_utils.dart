part of treemap_ui_layout;

abstract class LayoutUtils {
  
  num _availableWidth(NodeContainer nodeContainer);

  num _availableHeight(NodeContainer nodeContainer);
  
  /** Calculates the aspect ratio for the provided [width] and [height] arguments. */
  num _aspectRatio(num width, num height) {
    return max(width/height, height/width);
  }
  
  /**
   * Calculates the aspect ratios for every element of [models] as if all of them
   * were placed in the available area of [parent] along a row with the provided [orientation].
   */
  List<num> _aspectRatios(NodeContainer parent, Collection<DataModel> models, Orientation orientation) {
    if (models.isEmpty) {
      return [];
    } else {
      assert(models.every((child) => parent.nodeContainerRoot.dataModel.children.contains(child)));
      List<num> aspectRatios = new List();
      final shortEdge = orientation.isVertical ? _availableWidth(parent) : _availableHeight(parent);
      final longEdge = orientation.isVertical ? _availableHeight(parent) : _availableWidth(parent);
      final sumModels = models.reduce(0, (acc,model) => acc + model.size);
      final sumNotPlacedModels = _notPlacedModels(parent).reduce(0, (acc, model) => acc + model.size);
      final x = new Percentage.from(sumModels, sumNotPlacedModels).percentageValue(shortEdge);
      models.forEach((child) {
        final y = new Percentage.from(child.size, sumModels).percentageValue(longEdge);
        aspectRatios.add(_aspectRatio(x, y));
      });
      return aspectRatios;
    }
  }
  
  /**
   * Filters the [DataModel] of the root [BranchNode] of [nodeContainer] for children, 
   * which have no corresponding [Node] instance registered
   */
  Iterable<DataModel> _notPlacedModels(NodeContainer nodeContainer) {
    final parentBranch = nodeContainer.nodeContainerRoot;
    final placedModels = parentBranch.children.map((Node child) => child.dataModel);
    return parentBranch.dataModel.children.where((DataModel child) => !placedModels.contains(child));
  }

  Node _createNodeForRow(DataModel dModel, ViewModel vModel, Percentage sizeNode, Orientation orientation) {
    final height = orientation.isHorizontal ? Percentage.ONE_HUNDRED : sizeNode;
    final width = orientation.isHorizontal ? sizeNode : Percentage.ONE_HUNDRED;
    return new Node(dModel, vModel, width, height, orientation);
  }
}