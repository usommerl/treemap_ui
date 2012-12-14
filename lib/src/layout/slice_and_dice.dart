part of treemapLayout;

/**
 * Implementation of the Slice-and-dice algorithm. For further details see
 * 'Tree Visualization with Tree-Maps: 2-d Space-filling Approach.' by Ben Shneiderman
 * ACM Transactions on Graphics, 11(1), pp. 92-99, 1992
 *
 **/
class SliceAndDice extends LayoutAlgorithm {

  int _remainderVerticalOrientation;

  SliceAndDice([Orientation initialOrientation]){
    if (initialOrientation == null) {
      initialOrientation = Orientation.VERTICAL;
    }
    if (initialOrientation.isVertical()) {
      _remainderVerticalOrientation = 0;
    } else {
      _remainderVerticalOrientation = 1;
    }
  }

  void layout(ViewNode parent) {
    if (!parent.model.isLeaf()) {
      Queue<DataModel> queue = new Queue.from(parent.model.children);
      while (!queue.isEmpty) {
        DataModel model = queue.removeFirst();
        ViewNode node;
        num percentageA = 100;
        num percentageB = _percentageValue(model.size, parent.model.size);
        if (model.depth % 2 == _remainderVerticalOrientation) {
          node = new ViewNode(model, percentageA, percentageB, Orientation.VERTICAL);
        } else {
          node = new ViewNode(model, percentageB, percentageA, Orientation.HORIZONTAL);
        }
        parent.add(node);
        if (!model.isLeaf()) {
          layout(node);
        }
      }
    }
  }
}