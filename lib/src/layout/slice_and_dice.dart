part of treemap_layout;

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
        final p = new Percentage.from(model.size, parent.model.size);
        final node = model.depth % 2 == _remainderVerticalOrientation ?
            new ViewNode(model, Percentage.p100, p, Orientation.VERTICAL) :
            new ViewNode(model, p, Percentage.p100, Orientation.HORIZONTAL);
        parent.add(node);
        if (!model.isLeaf()) {
          layout(node);
        }
      }
    }
  }
}