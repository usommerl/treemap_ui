part of treemap_layout;

/**
 * Implementation of the slice-and-dice layout algorithm. For further details see
 * 'Tree Visualization with Tree-Maps: 2-d Space-filling Approach' by Ben Shneiderman.
 * ACM Transactions on Graphics, 11(1), pp. 92-99, 1992.
 **/
class SliceAndDice extends LayoutAlgorithm {

  int _remainderVerticalOrientation;

  SliceAndDice([Orientation initialOrientation]){
    if (initialOrientation == null) {
      initialOrientation = Orientation.vertical;
    }
    if (initialOrientation.isVertical) {
      _remainderVerticalOrientation = 0;
    } else {
      _remainderVerticalOrientation = 1;
    }
  }

  void layout(TreemapNode parent) {
    assert(parent.model.isBranch);
    Queue<DataModel> queue = new Queue.from(parent.model.children);
    while (!queue.isEmpty) {
      DataModel model = queue.removeFirst();
      final p = new Percentage.from(model.size, parent.model.size);
      final node = model.depth % 2 == _remainderVerticalOrientation ?
          new TreemapNode(model, Percentage.x100, p, Orientation.vertical) :
          new TreemapNode(model, p, Percentage.x100, Orientation.horizontal);
      parent.add(node);
      if (model.isBranch) {
        layout(node);
      }
    }
  }
}