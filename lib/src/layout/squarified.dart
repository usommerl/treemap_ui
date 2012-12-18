part of treemapLayout;

class Squarified extends LayoutAlgorithm {

  void layout(ViewNode parent) {
    if (!parent.model.isLeaf()) {
      List<DataModel> currentRow = [];
      Queue<DataModel> queue = new Queue.from(_descendingSortedCopy(parent.model.children));
      num availableWidthPercentage = 100.0;
      num availableHeightPercentage = 100.0;
      while(!queue.isEmpty) {
        final model = queue.removeFirst();
        final previousRow = new List.from(currentRow);
        currentRow.add(model);
        final availableWidth = _computeAvailableWidth(parent, availableWidthPercentage);
        final availableHeight = _computeAvailableHeight(parent, availableHeightPercentage);
        final rowOrientation = _determineRowOrientation(availableWidth, availableHeight);
        final prevWorstAspectRatio = _worstAspectRatio(availableWidth, availableHeight, parent, previousRow);
        final currWorstAspectRatio = _worstAspectRatio(availableWidth, availableHeight, parent, currentRow);
        num consumedPercentage = 0;
        if (!previousRow.isEmpty && prevWorstAspectRatio < currWorstAspectRatio) {
          consumedPercentage = _layoutRow(parent, previousRow, rowOrientation, availableWidthPercentage, availableHeightPercentage);
          currentRow.clear();
          queue.addFirst(model);
        } else if (queue.isEmpty) {
          consumedPercentage = _layoutRow(parent, currentRow, rowOrientation, availableWidthPercentage, availableHeightPercentage);
        }
        if (rowOrientation.isHorizontal()) {
          availableHeightPercentage = availableHeightPercentage - consumedPercentage;
        } else {
          availableWidthPercentage = availableWidthPercentage - consumedPercentage;
        }
      }
    }
  }

  Orientation _determineRowOrientation(num availableWidth, num availableHeight) {
    return availableWidth > availableHeight ?
        Orientation.VERTICAL :
        Orientation.HORIZONTAL;
  }

  num _worstAspectRatio(num availableWidth, num availableHeight, ViewNode parent, Collection<DataModel> dataModels) {
    var aspectRatios = availableWidth >= availableHeight ? 
        _aspectRatios(availableWidth, availableHeight, parent, dataModels) :
        _aspectRatios(availableHeight, availableWidth, parent, dataModels);
    return aspectRatios.reduce(0, (acc,ratio) => max(acc,ratio));
  }

  List<num> _aspectRatios(num longEdge, num shortEdge, ViewNode parent, Collection<DataModel> childrenSubset) {
    assert(longEdge >= shortEdge);
    if (childrenSubset.isEmpty) {
      return [];
    } else {
      assert(childrenSubset.every((child) {return parent.model.children.contains(child);}));
      List<num> aspectRatios = new List();
      final alreadyPlacedModels = parent.children.map((viewNode) => viewNode.model);
      final remainingModels = childrenSubset.iterator().next().parent.children.filter((child) => !alreadyPlacedModels.contains(child));
      final num sumChildrenSizes = childrenSubset.reduce(0, (acc,model) => acc + model.size);
      final num sumModelSizesRemaining = remainingModels.reduce(0, (acc, model) => acc + model.size);
      var x = percentageValue(longEdge, percentage(sumChildrenSizes, sumModelSizesRemaining));
      childrenSubset.forEach((child) {
        var y = percentageValue(shortEdge, percentage(child.size, sumChildrenSizes));
        aspectRatios.add(_aspectRatio(x, y));
      });
      return aspectRatios;
    }
  }

  num _layoutRow(ViewNode parent, List<DataModel> dataModels, Orientation rowOrientation, num availableWidthPercentage, num availableHeightPercentage) {
    Row row;
    num percentageConsumedByRow;
    final alreadyPlacedModels = parent.children.map((viewNode) => viewNode.model);
    final remainingModels = dataModels.first.parent.children.filter((child) => !alreadyPlacedModels.contains(child));
    final num sumModelSizesRow = dataModels.reduce(0, (acc,model) => acc + model.size);
    final num sumModelSizesRemaining = remainingModels.reduce(0, (acc, model) => acc + model.size);
    final percentageOfAvailableArea = percentage(sumModelSizesRow, sumModelSizesRemaining);
    if (rowOrientation.isHorizontal()) {
      percentageConsumedByRow = availableHeightPercentage * (percentageOfAvailableArea / 100.0);
      row = new Row.forSquarifiedLayout(availableWidthPercentage, percentageConsumedByRow, parent);
    } else {
      percentageConsumedByRow = availableWidthPercentage * (percentageOfAvailableArea / 100.0);
      row = new Row.forSquarifiedLayout(percentageConsumedByRow, availableHeightPercentage, parent);
    }
    row.classes.add(rowOrientation.toString());
    dataModels.forEach((model) {
      var percentageNode = percentage(model.size, sumModelSizesRow);
      var height = rowOrientation.isHorizontal() ? 100 : percentageNode;
      var width = rowOrientation.isHorizontal() ? percentageNode : 100;
      var node = new ViewNode(model, width, height, rowOrientation);
      row.add(node);
      if (!model.isLeaf()) {
        layout(node);
      }
    });
    return percentageConsumedByRow;
  }

  Collection<DataModel> _descendingSortedCopy(Collection<DataModel> original) {
    var copy = new List.from(original);
    copy.sort((a,b) {
      if (a.size == b.size) {
        return 0;
      } else if (a.size < b.size) {
        return 1;
      } else {
        return -1;
      }
    });
    return copy;
  }
  
  num _computeAvailableHeight(ViewNode node, num availableHeightPercentage) {
    return percentageValue(node.clientHeight, availableHeightPercentage);
  }
  
  num _computeAvailableWidth(ViewNode node, num availableWidthPercentage) {
    return percentageValue(node.clientWidth, availableWidthPercentage);
  }

}
