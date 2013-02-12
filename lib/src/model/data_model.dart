part of treemap_model;

abstract class DataModel {

  AbstractBranch _root;
  
  AbstractBranch _parent;

  AbstractBranch get parent => _parent;

  AbstractBranch get root => this.isRoot ? this : parent.root;

  int get depth => this.isRoot ? 0 : 1 + parent.depth;

  bool get isRoot => _parent == null;

  bool get isBranch => !isLeaf;

  bool get isLeaf;

  num get size;
  
  Element provideNodeLabel();
  
  Element provideTooltip();  
}