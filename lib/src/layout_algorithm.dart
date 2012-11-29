part of treemap;

abstract class LayoutAlgorithm {

  void layout(ViewNode parent);

  num _percentValue(num totalAmount, num givenAmount) => (givenAmount / totalAmount) * 100;

  num _aspectRatio(num width, num height) => max(width/height, height/width);
}

class SliceAndDice extends LayoutAlgorithm {

  /**
   * Implementation of the Slice-and-dice algorithm. For further details see
   * 'Tree Visualization with Tree-Maps: 2-d Space-filling Approach.' by Ben Shneiderman
   * ACM Transactions on Graphics, 11(1), pp. 92-99, 1992
   *
   **/
  
  void layout(ViewNode parent) {
    if (!parent.model.isLeaf()) {
      Queue<DataModel> queue = new Queue.from(parent.model.children);
      while (!queue.isEmpty) {
        DataModel currentItem = queue.removeFirst();
        ViewNode node;
        num longEdge = 100;
        num shortEdge = _percentValue(parent.model.size, currentItem.size);
        if (currentItem.depth % 2 == 0) {
          node = new ViewNode(currentItem, longEdge, shortEdge, ViewNode.VERTICAL_ORIENTATION);
        } else {
          node = new ViewNode(currentItem, shortEdge, longEdge, ViewNode.HORIZONTAL_ORIENTATION);
        }
        parent.add(node);
        if (!currentItem.isLeaf()) {
          layout(node);
        }
      }
    }
  }
}

class Strip extends LayoutAlgorithm {
  
  void layout(ViewNode parent) {
    if (!parent.model.isLeaf()) {
      Queue<DataModel> queue = new Queue.from(parent.model.children);
      List<DataModel> currentStrip = new List();
      while (!queue.isEmpty) {
        DataModel currentItem = queue.removeFirst();
        var previousStrip = new List.from(currentStrip);
        currentStrip.add(currentItem);
        var prevAvgAspectRatio = _avgAspectRatio(parent.clientWidth, parent.clientHeight,previousStrip);
        var currAvgAspectRatio = _avgAspectRatio(parent.clientWidth, parent.clientHeight,currentStrip);
        if (!previousStrip.isEmpty && currAvgAspectRatio > prevAvgAspectRatio) {
         layoutRow(parent, previousStrip);
         currentStrip.clear();
         queue.addFirst(currentItem);
        } else if (!currentStrip.isEmpty && queue.isEmpty) {
          layoutRow(parent, currentStrip);
        }
      }
    }
  }
  
  void layoutRow(ViewNode parent, List<DataModel> row) {
    row.forEach((e) {
      var height = _percentValue(e.parent.size, row.reduce(0, (acc,e) => acc + e.size));
      var width = _percentValue(row.reduce(0, (acc,e) => acc + e.size), e.size);
      ViewNode node = new ViewNode(e, width, height, ViewNode.HORIZONTAL_ORIENTATION); 
      parent.add(node);
      if (!e.isLeaf()) {
        layout(node);
      }
    });
  }

  num _avgAspectRatio(int parentLongEdge, int parentShortEdge, List<DataModel> items) {
    if (items.isEmpty) {
      return 0;
    } else {
      List<num> aspectRatios = new List();
      num stripLongEdgePercentage = _percentValue(items.last.parent.size, items.reduce(0, (acc,e) => acc + e.size));
      num stripLongEdgePixel = (parentShortEdge / 100) * stripLongEdgePercentage;
      items.forEach( (currentItem) {
        num itemSizePercentage = _percentValue(items.reduce(0, (acc,e) => acc + e.size), currentItem.size);
        num itemSizePixel = (parentLongEdge / 100) * itemSizePercentage;
        aspectRatios.add(_aspectRatio(stripLongEdgePixel, itemSizePixel));
      });
      return aspectRatios.reduce(0, (acc, e) => acc + e) / aspectRatios.length;
    }
  }
}
