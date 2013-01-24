part of treemap_model;

abstract class AncillaryData {
    
    DataModel _model;
  
    Element provideNodeLabel();
    
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
    if (_model.isBranch) {
      element.attributes["align"] = "center";
    } 
    return element;
  }
  
  SimpleTitleData copy() => new SimpleTitleData(nodeTitle);
}

class DebugData extends AncillaryData {
  
  Element provideNodeLabel() {
    Element element = new ParagraphElement();
    element.style..marginAfter = "0px"
                 ..marginBefore = "0px";
    if (_model.isBranch) {
      element.attributes["align"] = "center";
      element.text = "Branch [${_model.size}]";
    } else {
      element.text = "Leaf [${_model.size}]";
    }
    return element;
  }
  DebugData copy() => new DebugData();
}

