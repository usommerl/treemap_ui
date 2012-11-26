library treemap;

import 'dart:html';
import 'dart:math';
part 'src/layout_algorithm.dart';
part 'src/model.dart';

class TreeMap{

   DivElement rootArea;
   DataModel dataModel;
   LayoutAlgorithm algorithm;

   TreeMap(this.rootArea, this.dataModel, this.algorithm) {
     algorithm.layout(rootArea,dataModel);
   }
}