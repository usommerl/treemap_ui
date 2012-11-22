library treemap;

import 'dart:html';

part 'src/model.dart';

class TreeMap{

   DivElement rootArea;
   DataModel dataModel;

   TreeMap(this.rootArea, this.dataModel) {
     sliceAndDice(rootArea,dataModel);
   }

   Element sliceAndDice(DivElement parent, DataModel model) {
     String percent = model.isRoot() ? "100%" : "${percentValue(model.parent.size, model.size)}%";
     DivElement node = createNode(model);
     if (model.depth % 2 == 0) {
       node.style..width = "100%"
                 ..height = percent;
     } else {
       node.style..width = percent
                 ..height = "100%"
                 ..float = "left";
     }
     if (model.isLeaf()) {
       parent.elements.add(node);
     } else {
       parent.elements.addAll(model.children.map((c) => sliceAndDice(node,c)));
     }
     return parent;
   }

   DivElement createNode(DataModel model) {
     DivElement node = new DivElement();
     node.style..boxSizing = "border-box"
               ..padding = "0px"
               ..margin = "0px"
               ..backgroundColor = "#999"
               ..border = "1px solid black";
     if (model.isLeaf()) {
       SpanElement title = new SpanElement();
       title.text = model.title;
       node.elements.add(title);
     }
     return node;
   }

   num percentValue(num totalAmount, num givenAmount) => (givenAmount / totalAmount) * 100;

}