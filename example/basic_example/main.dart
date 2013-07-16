library treemap_ui.example.basic_example;

import 'dart:html';
import 'package:treemap_ui/treemap_ui.dart';

main() {
  final displayArea = new DivElement();
  displayArea.style..width = "900px"
                   ..height = "400px";
  document.body.children.add(displayArea);
  
  final model = new Branch([new Leaf(110), 
                            new Leaf(340), 
                            new Leaf(205), 
                            new Leaf(20),
                            new Leaf(80),
                            new Branch([new Leaf(489),
                                        new Leaf(134),
                                        new Leaf(708),
                                        new Leaf(100),
                                        new Leaf(30),
                                        new Branch([new Leaf(45),
                                                    new Leaf(90),
                                                    new Leaf(278),
                                                    new Leaf(30)]),
                                        new Branch([new Leaf(400),
                                                    new Leaf(100)])])]);
  
  final treemap = new Treemap(displayArea,model,new Squarified());
}