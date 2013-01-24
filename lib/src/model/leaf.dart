part of treemap_model;

class Leaf extends DataModel {

  final num size;
  
  Leaf(num this.size, [AncillaryData ancillaryData]) : super._internal(ancillaryData) {
      assert(size > 0);
  }
  
  factory Leaf.withTitle(num size, String title) {
    return new Leaf(size, new SimpleTitleData(title));
  }

  Leaf copy() {
    return new Leaf(size, ancillaryData.copy());    
  }
  
  bool get isLeaf => true;
}