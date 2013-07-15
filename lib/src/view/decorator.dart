part of treemap_ui.view;

abstract class Decorator<T extends DataModel> {
  
  /// Generates a HTML element that will be displayed as the label of [model].
  Element createLabel(T model);

  /// Generates a HTML element that will be displayed as the tooltip of [model].
  Element createTooltip(T model);
  
  /// Defines the background color for the corresponding treemap node of [model].
  Color defineColor(T model);
}

abstract class BranchDecorator<E extends Branch> implements Decorator<E> {}

abstract class LeafDecorator<E extends Leaf> implements Decorator<E> {}