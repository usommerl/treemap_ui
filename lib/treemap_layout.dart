library treemapLayout;

import 'dart:math';
import 'treemap_view.dart';
import 'treemap_model.dart';

part 'src/layout/strip.dart';
part 'src/layout/slice_and_dice.dart';

abstract class LayoutAlgorithm {

  void layout(ViewNode parent);

  num _percentValue(num totalAmount, num givenAmount) => (givenAmount / totalAmount) * 100;

  num _aspectRatio(num width, num height) => max(width/height, height/width);
}
