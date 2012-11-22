import 'dart:html';
import 'package:treemap/treemap.dart';

main() {
    DataModel dataModel = new Branch([new Leaf(10,'1'), new Leaf(20,'2'), new Leaf(100,'3')],"branch");
    TreeMap treemap = new TreeMap(document.query('#test1'),dataModel);
    DataModel dataModel2 = new Branch([new Leaf(70,'4'), dataModel],"root");
    treemap = new TreeMap(document.query('#test2'), dataModel2);
}