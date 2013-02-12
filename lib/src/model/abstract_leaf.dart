part of treemap_model;

abstract class AbstractLeaf extends DataModel {

  final num size;

  AbstractLeaf(num this.size) {
      assert(size > 0);
  }
  
  bool get isLeaf => true;
  
  Color provideBackgroundColor();
}

