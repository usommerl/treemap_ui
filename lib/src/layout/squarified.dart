part of treemap_layout;

/**
 * Implementation of the squarified layout algorithm. For further details see
 * 'Squarified Treemaps' by Mark Bruls, Kees Huizing, Jarke J. van Wijk.
 * Joint Eurographics and IEEE TCVG Symposium on Visualization, 
 * IEEE Computer Society, pp. 33-42, 2000.
 **/
class Squarified extends RowBasedLayoutAlgorithms {
  
  void layout(BranchNode parent) {
    List<DataModel> currentRow = [];
    final descendingSizes = ((a,b) => b.size.compareTo(a.size));
    Queue<DataModel> queue = new Queue.from(sortedCopy(parent.model.children, descendingSizes));
    while(!queue.isEmpty) {
      final model = queue.removeFirst();
      final previousRow = new List.from(currentRow);
      currentRow.add(model);
      final orientation = _determineOrientation(parent);
      final prevWorstAspectRatio = _worstAspectRatio(parent, previousRow, orientation);
      final currWorstAspectRatio = _worstAspectRatio(parent, currentRow, orientation);
      if (!previousRow.isEmpty && prevWorstAspectRatio < currWorstAspectRatio) {
        _layoutRow(parent, previousRow, orientation);
        currentRow.clear();
        queue.addFirst(model);
      } else if (queue.isEmpty) {
        _layoutRow(parent, currentRow, orientation);
      }
    }
  }

  void _layoutRow(BranchNode parent, List<DataModel> rowModels, Orientation orientation) {
    final availableWidthPercentage = _availableWidthPercentage(parent);
    final availableHeightPercentage = _availableHeightPercentage(parent);
    final num sumModels = rowModels.reduce(0, (acc,model) => acc + model.size);
    final num sumNotPlacedModels = _notPlacedModels(parent).reduce(0, (acc, model) => acc + model.size);
    final percentageRowItems = new Percentage.from(sumModels, sumNotPlacedModels);
    final row = orientation.isHorizontal ?
        new LayoutHelper.rowSquarified(availableWidthPercentage, percentageRowItems.of(availableHeightPercentage), parent, orientation):
        new LayoutHelper.rowSquarified(percentageRowItems.of(availableWidthPercentage), availableHeightPercentage, parent, orientation);
    rowModels.forEach((model) {
      final node = _createNodeForRow(model, new Percentage.from(model.size, sumModels), orientation);
      row.add(node);
      if (node.isBranch) {
        layout(node);
      }
    });
  }

  Orientation _determineOrientation(BranchNode node) => 
      _availableWidth(node) > _availableHeight(node) ?
          Orientation.vertical :
          Orientation.horizontal;
      
  num _worstAspectRatio(BranchNode parent, Collection<DataModel> models, Orientation orientation) =>
      _aspectRatios(parent, models, orientation).reduce(0, (accum,ratio) => max(accum,ratio));
}
