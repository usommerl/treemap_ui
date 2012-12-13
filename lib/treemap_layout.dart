library treemapLayout;

import 'dart:math';
import 'treemap_view.dart';
import 'treemap_model.dart';

part 'src/layout/strip.dart';
part 'src/layout/slice_and_dice.dart';
part 'src/layout/squarified.dart';

abstract class LayoutAlgorithm {

  void layout(ViewNode parent);
  
  /**
   *  Calculates [part] as percentage of [total].
   */
  num _percentageValue(num total, num part) {
    assert(total >= part && part >= 0);    
    return (part / total) * 100;
  }
  
  /**
   * Calculates the absolute 
   */
  num _absoluteValue(num totalAmount, num percentageValue) {
    assert(percentageValue >= 0 && percentageValue <= 100);
    assert(totalAmount > 0);
    return (totalAmount / 100) * percentageValue;
  }

  /**
   * Calculates the aspect ratio for the provided [width] and [height] arguments.
   * 
   */
  num _aspectRatio(num width, num height) {
    assert(width > 0 && height > 0);
    return max(width/height, height/width);
  } 
  
  /**
   * Calculates the aspect ratios for every element of [childrenSubset] as if  
   * it is placed inside the [ViewNode] [parent].
   * 
   **/
  List<num> _aspectRatios(ViewNode parent, Collection<DataModel> childrenSubset) {
    assert(parent.clientWidth > 0 && parent.clientHeight > 0);
    if (childrenSubset.isEmpty) {
      return [];
    } else {
      assert(childrenSubset.every((child) {return parent.model.children.contains(child);}));
      List<num> aspectRatios = new List();
      final num sumOfAllChildren = childrenSubset.reduce(0, (acc,model) => acc + model.size);
      var x = _absoluteValue(parent.clientHeight, _percentageValue(parent.model.size, sumOfAllChildren));
      childrenSubset.forEach((child) {
        var y = _absoluteValue(parent.clientWidth,_percentageValue(sumOfAllChildren, child.size));
        aspectRatios.add(_aspectRatio(x, y));
      });
      return aspectRatios;      
    }
  }
  
  void _layoutRow(ViewNode parent, List<DataModel> dataModels, Orientation orientation) {
    final num sumOfAllModels = dataModels.reduce(0, (acc,model) => acc + model.size);
    var dimensionRow = _percentageValue(dataModels.first.parent.size, sumOfAllModels);
    Row row = new Row(dimensionRow, orientation, parent);
    dataModels.forEach((model) {
      var dimensionNode = _percentageValue(sumOfAllModels, model.size);
      var height = orientation.isHorizontal() ? 100 : dimensionNode;
      var width = orientation.isHorizontal() ? dimensionNode : 100;
      var node = new ViewNode(model, width, height, orientation);
      row.add(node);
      if (!model.isLeaf()) {
        layout(node);
      }
    });
  }
}
