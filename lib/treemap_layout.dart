library treemap_layout;

import 'dart:math';
import 'treemap_view.dart';
import 'treemap_model.dart';
import 'treemap_utils.dart';

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
   * Calculates the aspect ratio for the provided [width] and [height] arguments.
   */
  num _aspectRatio(num width, num height) {
    assert(width > 0 && height > 0);
    return max(width/height, height/width);
  }
}
