library treemapTestRessources;

import 'package:treemap/treemap.dart';

class TestRessources {

  static final DataModel dataModel0 = new Leaf(10);
  static final DataModel dataModel1 = new Branch([dataModel0.copy(), new Leaf(20), new Leaf(100)]);
  static final DataModel dataModel2 = new Branch([dataModel1.copy(), new Leaf(70)]);
  static final DataModel dataModel3 = new Branch([new Leaf(10), new Leaf(10),
                                     new Leaf(10), new Leaf(369),
                                     new Leaf(804), new Leaf(10),
                                     new Leaf(634), new Leaf(120),
                                     new Leaf(731), new Leaf(384),
                                     new Leaf(450), new Leaf(10),
                                     new Leaf(10), new Leaf(10)]);

  static final DataModel dataModel4 = new Branch([new Leaf(1000),new Leaf(2000), new Branch([new Leaf(2), new Leaf(5), new Branch([new Leaf(3)])])]);
  static final DataModel dataModel5 = new Branch([dataModel0.copy(), dataModel2.copy()]);

  static final List<DataModel> testDataModels = [dataModel0,dataModel1,dataModel2,dataModel3, dataModel4, dataModel5];
  static final List<LayoutAlgorithm> layoutAlgorithms = [new SliceAndDice(), new Strip(), new Squarified()];
}
