part of treemap.layout;

/**
 * Implementation of the slice-and-dice layout algorithm. For further details see
 * 'Tree Visualization with Tree-Maps: 2-d Space-filling Approach' by Ben Shneiderman.
 * ACM Transactions on Graphics, 11(1), pp. 92-99, 1992.
 **/
class SliceAndDice implements LayoutAlgorithm {

  int _remainderVerticalOrientation;

  SliceAndDice([Orientation initialOrientation]){
    if (initialOrientation == null) {
      initialOrientation = Orientation.VERTICAL;
    }
    if (initialOrientation.isVertical) {
      _remainderVerticalOrientation = 0;
    } else {
      _remainderVerticalOrientation = 1;
    }
  }

  void layout(BranchNode parent) {
    Queue<DataModel> queue = new Queue.from(parent.dataModel.children);
    while (!queue.isEmpty) {
      DataModel dataModel = queue.removeFirst();
      final p = new Percentage.from(dataModel.size, parent.dataModel.size);
      final node = dataModel.depth % 2 == _remainderVerticalOrientation ?
          new Node(dataModel, parent.viewModel, Percentage.ONE_HUNDRED, p, Orientation.VERTICAL) :
          new Node(dataModel, parent.viewModel, p, Percentage.ONE_HUNDRED, Orientation.HORIZONTAL);
      parent.add(node);
      if (node.isBranch) {
        layout(node);
      }
    }
  }
}