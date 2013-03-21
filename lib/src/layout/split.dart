part of treemap_ui_layout;

/**
 * Implementation of the split layout algorithm. For further details see
 * 'Ordered and Unordered Treemap Algorithms and their Applications on Handheld Devices' 
 * by Björn Engdahl.
 * Master's Degree Project, Royal Institute of Technology Stockholm, Sweden (2005).
 **/
class Split implements LayoutAlgorithm {
  
  void layout(BranchNode parent) {
    final partitions = _partition(parent.dataModel.children);
    _layoutPartitions(partitions, parent);
  }
  
  void _layoutPartitions(List<List<DataModel>> partitions, LayoutAid parentAid) {
    if (partitions.isEmpty) {
      return;
    } else if (partitions.length == 1) {
      DataModel model = partitions.first.first;
      Node node = new Node(model, parentAid.aidRoot.viewModel, Percentage.ONE_HUNDRED, Percentage.ONE_HUNDRED, Orientation.VERTICAL);
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
      final aidL1 = new InvisibleLayoutAid.expand(percentageL1, parentAid.aidRoot, orientation);
      final aidL2 = new InvisibleLayoutAid.expand(percentageL2, parentAid.aidRoot, orientation);
      if (parentAid != parentAid.aidRoot) {
        parentAid.addAid(aidL1);
        parentAid.addAid(aidL2);        
      }
      _layoutPartitions(_partition(l1), aidL1);
      _layoutPartitions(_partition(l2), aidL2);
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
      while (currWeightDelta <= prevWeightDelta && !l2.isEmpty) {
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
      parent.container.client.width > parent.container.client.height ?
          Orientation.VERTICAL :
          Orientation.HORIZONTAL;
}