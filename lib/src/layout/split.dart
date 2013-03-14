part of treemap.layout;

/**
 * Implementation of the split layout algorithm. For further details see
 * 'Ordered and Unordered Treemap Algorithms and their Applications on Handheld Devices' 
 * by Björn Engdahl.
 * Master's Degree Project, Royal Institute of Technology Stockholm, Sweden (2005).
 **/
class Split implements LayoutAlgorithm {
  
  void layout(BranchNode parent) {
    final partitions = _partition(parent.dataModel.children);
    final layoutAid = new LayoutAid.expand(Percentage.ONE_HUNDRED, parent, Orientation.VERTICAL);
    _layoutPartitions(partitions, layoutAid);
  }
  
  void _layoutPartitions(List<List<DataModel>> partitions, LayoutAid parentAid) {
    if (partitions.isEmpty) {
      return;
    } else if (partitions.length == 1) {
      DataModel model = partitions.first.first;
      Node node = new Node(model, parentAid.parentNode.viewModel, Percentage.ONE_HUNDRED, Percentage.ONE_HUNDRED, Orientation.VERTICAL);
      parentAid.add(node);
      if (node.isBranch) {
        layout(node);
      } 
    } else {
      List<DataModel> l1 = partitions[0];
      List<DataModel> l2 = partitions[1];
      final weightL1 = _weight(l1);
      final weightL2 = _weight(l2);
      final percentageL1 = new Percentage.from(weightL1, weightL1 + weightL2);
      final percentageL2 = Percentage.ONE_HUNDRED - percentageL1;
      final orientation = _determineOrientation(parentAid);
      final helperL1 = new LayoutAid.expand(percentageL1, parentAid.parentNode, orientation);
      final helperL2 = new LayoutAid.expand(percentageL2, parentAid.parentNode, orientation);
      parentAid.addAid(helperL1);
      parentAid.addAid(helperL2);
      _layoutPartitions(_partition(l1),helperL1);
      _layoutPartitions(_partition(l2), helperL2);
    }
  }
  
  List<List<DataModel>> _partition(List<DataModel> l) {
    if (l.isEmpty) {
      return [];
    } else if (l.length == 1) {
      return [l];
    } else {
      Queue<DataModel> l1 = new Queue.from([]);
      Queue<DataModel> l2 = new Queue.from(l);
      num currWeightDelta = _weightDelta(l1,l2);
      num prevWeightDelta = _weightDelta(l1,l2);
      while (currWeightDelta <= prevWeightDelta) {
        l1.add(l2.removeFirst());
        prevWeightDelta = currWeightDelta;
        currWeightDelta = _weightDelta(l1,l2);
      }
      l2.addFirst(l1.removeLast());
      return [l1.toList(growable: false),l2.toList(growable: false)];      
    }
  }
  
  num _weight(Iterable<DataModel> l) => l.reduce(0, (acc,e) => acc + e.size);
  
  num _weightDelta(Iterable<DataModel> l1, Iterable<DataModel> l2) =>
      (_weight(l1) - _weight(l2)).abs();
  
  Orientation _determineOrientation(LayoutAid parent) =>
      parent.container.clientWidth > parent.container.clientHeight ?
          Orientation.VERTICAL :
          Orientation.HORIZONTAL;
}