part of treemapLayout;

class Squarified extends LayoutAlgorithm {
  
  void layout(ViewNode parent) {
    if (!parent.model.isLeaf()) {
      List<DataModel> currentRow = [];
      Queue<DataModel> queue = new Queue.from(_descendingSortedCopy(parent.model.children));
      while(!queue.isEmpty) {
        var model = queue.removeFirst();
        var previousRow = new List.from(currentRow);
        currentRow.add(model);
        var prevWorstAspectRatio = _worstAspectRatio(parent, previousRow);
        var currWorstAspectRatio = _worstAspectRatio(parent, currentRow);
        if (!previousRow.isEmpty && prevWorstAspectRatio < currWorstAspectRatio) {
          _layoutRow(parent, previousRow, _determineStripOrientation(parent));
          currentRow.clear();
          queue.addFirst(model);
        } else if (queue.isEmpty) {
          _layoutRow(parent, currentRow, _determineStripOrientation(parent));
        }
      }
    }
  }
  
  Orientation _determineStripOrientation(ViewNode parent) {
    return parent.clientWidth >= parent.clientHeight ? 
        Orientation.VERTICAL : 
        Orientation.HORIZONTAL;
  }
  
  num _worstAspectRatio(ViewNode parent, Collection<DataModel> dataModels) {
    var aspectRatios = _aspectRatios(parent, dataModels);
    return aspectRatios.reduce(0, (acc,ratio){ if (ratio > acc) {acc = ratio;} return acc; });  
  }
  
  Collection<DataModel> _descendingSortedCopy(Collection<DataModel> original) {
    var copy = new List.from(original);
    copy.sort(compare(a,b) {
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
  
}
