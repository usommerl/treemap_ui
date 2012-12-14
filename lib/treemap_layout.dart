library treemapLayout;

import 'dart:math';
import 'treemap_view.dart';
import 'treemap_model.dart';

part 'src/layout/strip.dart';
part 'src/layout/slice_and_dice.dart';
part 'src/layout/squarified.dart';

/**
 * Base class for all concrete layout algorithm implementations.
 * 
 */
abstract class LayoutAlgorithm {
  
  /**
   * Partitions the area occupied by [parent] according to the concrete 
   * implementation and places a [ViewNode] instance for every child of [parent].
   */
  void layout(ViewNode parent);
  
  /**
   *  Calculates [amount] as percentage of [basicValue].
   */
  num _percentage(num amount, num basicValue) {
    assert(basicValue >= amount && amount >= 0);    
    return (amount / basicValue) * 100;
  }
  
  /**
   *  Calculates the percentage value from [basicValue] and [percentage].
   */
  num _percentageValue(num basicValue, num percentage) {
    assert(percentage >= 0 && percentage <= 100);
    return (basicValue / 100) * percentage;
  }

  /**
   * Calculates the aspect ratio for the provided [width] and [height] arguments.
   */
  num _aspectRatio(num width, num height) {
    assert(width > 0 && height > 0);
    return max(width/height, height/width);
  } 
  
  /**
   * Calculates the aspect ratios for every element of [childrenSubset] as if  
   * all of them are placed inside the [parent] [ViewNode].
   * 
   **/
  List<num> _aspectRatios(ViewNode parent, Collection<DataModel> childrenSubset) {
    assert(parent.clientWidth > 0 && parent.clientHeight > 0);
    if (childrenSubset.isEmpty) {
      return [];
    } else {
      assert(childrenSubset.every((child) {return parent.model.children.contains(child);}));
      List<num> aspectRatios = new List();
      final num sumChildrenSizes = childrenSubset.reduce(0, (acc,model) => acc + model.size);
      var x = _percentageValue(parent.clientHeight, _percentage(sumChildrenSizes, parent.model.size));
      childrenSubset.forEach((child) {
        var y = _percentageValue(parent.clientWidth, _percentage(child.size, sumChildrenSizes));
        aspectRatios.add(_aspectRatio(x, y));
      });
      return aspectRatios;      
    }
  }
  
  /**
   *  Creates [ViewNode] instances for the provided [dataModels] and places them 
   *  inside [parent] along a invisible row.
   * 
   *  The parameter [orientation] determines the layout direction of the row.
   */
  void _layoutRow(ViewNode parent, List<DataModel> dataModels, Orientation orientation) {
    final num sumModelSizes = dataModels.reduce(0, (acc,model) => acc + model.size);
    var dimensionRow = _percentage(sumModelSizes, dataModels.first.parent.size);
    Row row = new Row(dimensionRow, orientation, parent);
    dataModels.forEach((model) {
      var dimensionNode = _percentage(model.size, sumModelSizes);
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
