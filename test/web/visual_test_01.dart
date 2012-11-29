import 'dart:html';
import 'package:treemap/treemap.dart';

main() {
    TreeMap treemap;
    var sliceAndDice = new SliceAndDice();
    var strip = new Strip();
    
    DataModel dataModel1 = new Leaf(10, '1');
    treemap = new TreeMap(document.query('#test1'), dataModel1, sliceAndDice);
    treemap = new TreeMap(document.query('#test4'), dataModel1, strip);
    
    DataModel dataModel2 = new Branch([dataModel1, new Leaf(20,'2'), new Leaf(100,'3')],"root");
    treemap = new TreeMap(document.query('#test2'), dataModel2, sliceAndDice);
    treemap = new TreeMap(document.query('#test5'), dataModel2, strip);

    DataModel dataModel3 = new Branch([new Leaf(70,'4'), dataModel2],"root");
    treemap = new TreeMap(document.query('#test3'), dataModel3, sliceAndDice);
    treemap = new TreeMap(document.query('#test6'), dataModel3, strip);
    
//    Test with collapsed rootArea
//    treemap = new TreeMap(document.query('#test5'), dataModel2, sliceAndDice);
    
}