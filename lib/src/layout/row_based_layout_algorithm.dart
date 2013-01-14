part of treemap_layout;

abstract class RowBasedLayoutAlgorithms extends LayoutAlgorithm {
    
  num _availableWidth(BranchNode node) => 
      _availableWidthPercentage(node).percentageValue(node.clientWidth);
  
  num _availableHeight(BranchNode node) => 
      _availableHeightPercentage(node).percentageValue(node.clientHeight);
  
  Percentage _availableWidthPercentage(BranchNode node) {
    final verticalRows = node.layoutHelpers.filter((row) => row.orientation.isVertical);
    return Percentage.x100 - verticalRows.reduce(Percentage.x0, (sum,elem) => sum + elem.width);
  }
  
  Percentage _availableHeightPercentage (BranchNode node) {
    final horizontalRows = node.layoutHelpers.filter((row) => row.orientation.isHorizontal);
    return Percentage.x100 - horizontalRows.reduce(Percentage.x0, (sum,elem) => sum + elem.height);
  }
  
  /**
   * Filters the [DataModel] of [node] for children, which have no corresponding
   * [TmNode] instance connecteted to [node]
   */
  List<DataModel> _notPlacedModels(BranchNode node) {
    final placedModels = node.children.map((Node child) => child.model);
    return node.model.children.filter((DataModel child) => !placedModels.contains(child));
  }
  
  /** Calculates the aspect ratio for the provided [width] and [height] arguments. */
  num _aspectRatio(num width, num height) {
    assert(width > 0 && height > 0);
    return max(width/height, height/width);
  }
  
  /**
   * Calculates the aspect ratios for every element of [models] as if all of them 
   * were placed in the available area of [parent] along a row with the provided [orientation].
   */
  List<num> _aspectRatios(BranchNode parent, Collection<DataModel> models, Orientation orientation) {
    if (models.isEmpty) {
      return [];
    } else {
      assert(models.every((child) => parent.model.children.contains(child)));
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
  
  Node _createNodeForRow(DataModel model, Percentage sizeNode, Orientation orientation) {
    final height = orientation.isHorizontal ? Percentage.x100 : sizeNode;
    final width = orientation.isHorizontal ? sizeNode : Percentage.x100;
    return new Node(model, width, height, orientation);
  }
}