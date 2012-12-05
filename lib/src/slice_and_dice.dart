part of treemap;

/**
 * Implementation of the Slice-and-dice algorithm. For further details see
 * 'Tree Visualization with Tree-Maps: 2-d Space-filling Approach.' by Ben Shneiderman
 * ACM Transactions on Graphics, 11(1), pp. 92-99, 1992
 *
 **/
class SliceAndDice extends LayoutAlgorithm {
  
  int _remainderVerticalOrientation;
  
  SliceAndDice([String initialOrientation = ViewNode.HORIZONTAL_ORIENTATION]){
    if (initialOrientation == ViewNode.VERTICAL_ORIENTATION) {
      _remainderVerticalOrientation = 1;
    } else {
      _remainderVerticalOrientation = 0;
    }
  }

  void layout(ViewNode parent) {
    if (!parent.model.isLeaf()) {
      Queue<DataModel> queue = new Queue.from(parent.model.children);
      while (!queue.isEmpty) {
        DataModel currentItem = queue.removeFirst();
        ViewNode node;
        num longEdge = 100;
        num shortEdge = _percentValue(parent.model.size, currentItem.size);
        if (currentItem.depth % 2 == _remainderVerticalOrientation) {
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