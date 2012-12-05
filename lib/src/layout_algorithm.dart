part of treemap;

abstract class LayoutAlgorithm {

  void layout(ViewNode parent);

  num _percentValue(num totalAmount, num givenAmount) => (givenAmount / totalAmount) * 100;

  num _aspectRatio(num width, num height) => max(width/height, height/width);
}

/**
 * Implementation of the strip algorithm. For further details see
 * 'Ordered and Quantum Treemaps: Making Effective Use of 2D Space to Display Hierarchies' 
 * by Benjamin B. Bederson, Martin Wattenberg and Ben Shneiderman, pp. 7-9, 2001
 *
 **/
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
      var height = _percentValue(row.first.parent.size, row.reduce(0, (acc,e) => acc + e.size));
      var width = _percentValue(row.reduce(0, (acc,e) => acc + e.size), e.size);
      ViewNode node = new ViewNode(e, width, height, ViewNode.HORIZONTAL_ORIENTATION);
      parent.add(node);
      if (!e.isLeaf()) {
        layout(node);
      }
    });
  }

  num _avgAspectRatio(int availableWidth, int avilableHeight, List<DataModel> items) {
    if (items.isEmpty) {
      return 0;
    } else {
      List<num> aspectRatios = new List();
      num dimensionXPercentage = _percentValue(items.first.parent.size, items.reduce(0, (acc,e) => acc + e.size));
      num dimensionX = (avilableHeight / 100) * dimensionXPercentage;
      items.forEach( (currentItem) {
        num dimensionYPercentage = _percentValue(items.reduce(0, (acc,e) => acc + e.size), currentItem.size);
        num dimensionY = (availableWidth / 100) * dimensionYPercentage;
        aspectRatios.add(_aspectRatio(dimensionX, dimensionY));
      });
      return aspectRatios.reduce(0, (acc, e) => acc + e) / aspectRatios.length;
    }
  }
}
