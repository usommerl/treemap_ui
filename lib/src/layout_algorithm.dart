part of treemap;

abstract class LayoutAlgorithm {
  
  DivElement layout(DivElement parent, DataModel model);
  
  num _percentValue(num totalAmount, num givenAmount) => (givenAmount / totalAmount) * 100;
  
  num _aspectRatio(num width, num height) => max(width/height, height/width);
  
  DivElement _createNode(DataModel model, String width, String height, String orientation) {
    DivElement node = new DivElement();
    node.style..boxSizing = "border-box"
        ..padding = "0px"
        ..margin = "0px"
        ..width = width
        ..height = height
        ..float = orientation
        ..backgroundColor = "#999";
    if (model.isLeaf()) {
      node.style.border = "1px solid black";
      SpanElement title = new SpanElement();
      title.text = model.title;
      node.elements.add(title);
    }
    return node;
  }
}

class SliceAndDice extends LayoutAlgorithm {
  
  /**
   * Implementation of the Slice-and-dice algorithm. For further details see 
   * 'Tree Visualization with Tree-Maps: 2-d Space-filling Approach.' by Ben Shneiderman 
   * ACM Transactions on Graphics, 11(1), pp. 92-99, 1992 
   *
   **/
  
  DivElement layout(DivElement parent, DataModel model) {
    DivElement node;
    String longEdge = "100%";
    String shortEdge = model.isRoot() ? longEdge : "${_percentValue(model.parent.size, model.size)}%";
    if (model.depth % 2 == 0) {
      node = _createNode(model, longEdge, shortEdge, "none");
    } else {
      node = _createNode(model, shortEdge, longEdge, "left");
    }
    if (model.isLeaf()) {
      parent.elements.add(node);
    } else {
      parent.elements.addAll(model.children.map((c) => this.layout(node,c)));
    }
    return parent;
  }
}

class Strip extends LayoutAlgorithm {
  
  DivElement layout(DivElement parent, DataModel model) {
    if (!model.isLeaf()) {
      Queue<DataModel> queue = new Queue.from(model.children);
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
    } else {
      throw new Error();
    }
  }
  
  void layoutRow(DivElement parent, List<DataModel> row) {
    row.forEach((e) {
      var height = _percentValue(e.parent.size, row.reduce(0, (acc,e) => acc + e.size));
      var width = _percentValue(row.reduce(0, (acc,e) => acc + e.size), e.size);
      var node = _createNode(e, "${width}%", "${height}%", "left");
      parent.elements.add(node);
      if (!e.isLeaf()) {
        layout(node,e);
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
