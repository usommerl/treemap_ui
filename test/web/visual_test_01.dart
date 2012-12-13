import 'dart:html';
import 'package:treemap/treemap.dart';

main() {

  TreeMap treemap;
    var orientation = Orientation.VERTICAL;
    var sliceAndDice = new SliceAndDice();
    var strip = new Strip();
    var squarified = new Squarified();

    DataModel dataModel1 = new Leaf(10, '1');
    DataModel dataModel2 = new Branch([DataModel.copy(dataModel1), new Leaf(20,'2'), new Leaf(100,'3')],"branch");
    DataModel dataModel3 = new Branch([new Leaf(70,'4'), DataModel.copy(dataModel2)],"root");
    DataModel dataModel4 = new Branch([new Leaf(10, '1'), new Leaf(10, '2'),
                                       new Leaf(10, '3'), new Leaf(369, '4'),
                                       new Leaf(804, '5'), new Leaf(10, '6'),
                                       new Leaf(634, '7'), new Leaf(120, '8'),
                                       new Leaf(731, '9'), new Leaf(384, '10'),
                                       new Leaf(450, '11'), new Leaf(10, '12'),
                                       new Leaf(10, '13'), new Leaf(10, '14')], 'root');


    treemap = new TreeMap(document.query('#sliceAndDice01'), dataModel1, sliceAndDice);
    treemap = new TreeMap(document.query('#sliceAndDice02'), dataModel2, sliceAndDice);
    treemap = new TreeMap(document.query('#sliceAndDice03'), dataModel3, sliceAndDice);
    treemap = new TreeMap(document.query('#sliceAndDice04'), dataModel4, sliceAndDice);

    treemap = new TreeMap(document.query('#strip01'), dataModel1, strip);
    treemap = new TreeMap(document.query('#strip02'), dataModel2, strip);
    treemap = new TreeMap(document.query('#strip03'), dataModel3, strip);
    treemap = new TreeMap(document.query('#strip04'), dataModel4, strip);
    
    treemap = new TreeMap(document.query('#squarified01'), dataModel1, squarified);
    treemap = new TreeMap(document.query('#squarified02'), dataModel2, squarified);
    treemap = new TreeMap(document.query('#squarified03'), dataModel3, squarified);
    treemap = new TreeMap(document.query('#squarified04'), dataModel4, squarified);
}