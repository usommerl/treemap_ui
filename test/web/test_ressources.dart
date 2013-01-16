library treemapTestRessources;

import 'package:treemap/treemap.dart';

class TestRessources {

  static final DataModel dataModel0 = new Leaf(10, '1');
  static final DataModel dataModel1 = new Branch([DataModel.copy(dataModel0), new Leaf(20,'2'), new Leaf(100,'3')],"branch");
  static final DataModel dataModel2 = new Branch([new Leaf(70,'4'), DataModel.copy(dataModel1)],"root");
  static final DataModel dataModel3 = new Branch([new Leaf(10, '1'), new Leaf(10, '2'),
                                     new Leaf(10, '3'), new Leaf(369, '4'),
                                     new Leaf(804, '5'), new Leaf(10, '6'),
                                     new Leaf(634, '7'), new Leaf(120, '8'),
                                     new Leaf(731, '9'), new Leaf(384, '10'),
                                     new Leaf(450, '11'), new Leaf(10, '12'),
                                     new Leaf(10, '13'), new Leaf(10, '14')], 'root');
  
  static final DataModel dataModel4 = new Branch([new Leaf(1000,'1'),new Leaf(2000,'2'), new Branch([new Leaf(10,'3')],'smallBranch')],'root');

  static final List<DataModel> testDataModels = [dataModel0,dataModel1,dataModel2,dataModel3, dataModel4];
  static final List<LayoutAlgorithm> layoutAlgorithms = [new SliceAndDice(), new Strip(), new Squarified()];
}
