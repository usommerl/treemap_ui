part of treemap_model;

abstract class AncillaryData {

    DataModel _model;
    
    DataModel get model => this._model;

    Element provideNodeLabel();
    
    Element provideTooltip();

    AncillaryData copy();
}

class SimpleTitleData extends AncillaryData {

  final String nodeTitle;

  SimpleTitleData(String this.nodeTitle);

  Element provideNodeLabel() {
    Element element = new ParagraphElement();
    element.style..marginAfter = "0px"
                 ..marginBefore = "0px";
    element.text = this.nodeTitle;
    if (model.isBranch) {
      element.attributes["align"] = "center";
    }
    return element;
  }
  
  Element provideTooltip() => new Element.html("<span></span>");

  SimpleTitleData copy() => new SimpleTitleData(nodeTitle);
}

class DebugData extends AncillaryData {

  Element provideNodeLabel() {
    Element element = new ParagraphElement();
    element.style..marginAfter = "0px"
                 ..marginBefore = "0px";
    if (model.isBranch) {
      element.attributes["align"] = "center";
      element.text = "Branch";
    } else {
      element.text = "Leaf";
    }
    return element;
  }
  
  Element provideTooltip() {
    Element element = new Element.html("<div></div>");
    element.style..backgroundColor = "white"
        ..fontSize = "0.8em"
        ..padding = "1px 5px 1px 5px";
    if (model.isLeaf) {
      element.text = "Leaf, size: ${model.size}";
    } else {
      element.text = "Branch, size: ${model.size}";      
    }
    return element;
  }
  
  DebugData copy() => new DebugData();
}

