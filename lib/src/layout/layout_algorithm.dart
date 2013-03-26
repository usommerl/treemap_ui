part of treemap_ui.layout;

/**
 * Base class for all concrete layout algorithm implementations.
 *
 */
abstract class LayoutAlgorithm {

  /**
   * Partitions the area occupied by [node] according to the concrete implementation
   * and places a [Node] instances for every child of [node]'s [DataModel].
   */
  void layout(BranchNode node);

}
