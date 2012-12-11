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

  String _rowOrientation;
  
  void layout(ViewNode parent) {
    if (!parent.model.isLeaf()) {
      Queue<DataModel> queue = new Queue.from(parent.model.children);
      List<DataModel> currentStrip = new List();
      _rowOrientation = _rowOrientation == null ? determineRowOrientation(parent) : _rowOrientation;
      while (!queue.isEmpty) {
        DataModel currentItem = queue.removeFirst();
        var previousStrip = new List.from(currentStrip);
        currentStrip.add(currentItem);
        var prevAvgAspectRatio = _avgAspectRatio(parent.clientWidth, parent.clientHeight,previousStrip);
        var currAvgAspectRatio = _avgAspectRatio(parent.clientWidth, parent.clientHeight,currentStrip);
        if (!previousStrip.isEmpty && currAvgAspectRatio > prevAvgAspectRatio) {
         layoutRow(parent, previousStrip, _rowOrientation);
         currentStrip.clear();
         queue.addFirst(currentItem);
        } else if (!currentStrip.isEmpty && queue.isEmpty) {
          layoutRow(parent, currentStrip, _rowOrientation);
        }
      }
    }
  }
  
  String determineRowOrientation(ViewNode parent) {
    if (parent.clientWidth >= parent.clientHeight) {
      return Row.HORIZONTAL_ORIENTATION;
    } else {
      return Row.VERTICAL_ORIENTATION;
    }
  }

  void layoutRow(ViewNode parent, List<DataModel> dataModels, String rowOrientation) {
    var sizeRow = _percentValue(dataModels.first.parent.size, dataModels.reduce(0, (acc,e) => acc + e.size));
    Row row = new Row(sizeRow, rowOrientation, parent);
    dataModels.forEach((model) {
      var value = _percentValue(dataModels.reduce(0, (acc,e) => acc + e.size), model.size);
      var height = rowOrientation == Row.HORIZONTAL_ORIENTATION ? 100 : value;
      var width = rowOrientation == Row.HORIZONTAL_ORIENTATION ? value : 100;
      ViewNode node = rowOrientation == Row.HORIZONTAL_ORIENTATION ? 
          new ViewNode(model, width, height, ViewNode.HORIZONTAL_ORIENTATION) :
          new ViewNode(model, width, height, ViewNode.VERTICAL_ORIENTATION);
      row.add(node);
      if (!model.isLeaf()) {
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

class Row {
  DivElement _container = new DivElement();
  List<ViewNode> _children = new List();
  ViewNode _parent;
  static const String VERTICAL_ORIENTATION = "left";
  static const String HORIZONTAL_ORIENTATION = "none";
  
  Row(num size, String rowOrientation, this._parent) {
    assert(size > 0 && size <= 100);
    assert(rowOrientation == Row.HORIZONTAL_ORIENTATION 
        || rowOrientation == Row.VERTICAL_ORIENTATION); 
    _container.style..margin = "0px"
        ..padding = "0px"
        ..float = rowOrientation
        ..borderWidth = "0px";
    if (rowOrientation == Row.HORIZONTAL_ORIENTATION) {
      _container.style..width = "100%"
          ..height = "${size}%";
    } else {
      _container.style..width = "${size}%"
          ..height = "100%";
    }
    _parent._content.append(this._container);
  }
  
  void add(ViewNode child) {
    this._container.append(child._container);
    _parent._linkNode(child);
  }
}
