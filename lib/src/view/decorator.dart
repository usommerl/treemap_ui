part of treemap_ui.view;

abstract class Decorator<T extends DataModel> {
  
  /// Generates a HTML element that will be displayed as the label of [model].
  Element createLabel(T model);

  /// Generates a HTML element that will be displayed as the tooltip of [model].
  Element createTooltip(T model);
  
  /// Defines the background color for the corresponding treemap node.
  Color defineNodeColor(T model);
}

abstract class BranchDecorator<T extends Branch> implements Decorator<T> {}

abstract class LeafDecorator<T extends Leaf> implements Decorator<T> {}