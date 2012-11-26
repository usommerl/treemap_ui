import 'dart:html';
import 'package:treemap/treemap.dart';

main() {
    var sliceAndDice = new SliceAndDice();
    var strip = new Strip();
    DataModel dataModel = new Branch([new Leaf(10,'1'), new Leaf(20,'2'), new Leaf(100,'3')],"branch");
    DataModel dataModel2 = new Branch([new Leaf(70,'4'), dataModel],"root");

    TreeMap treemap = new TreeMap(document.query('#test1'),dataModel, sliceAndDice);
    treemap = new TreeMap(document.query('#test2'), dataModel2, sliceAndDice);
    treemap = new TreeMap(document.query('#test3'), dataModel, strip);
    treemap = new TreeMap(document.query('#test4'), dataModel2, strip);
}