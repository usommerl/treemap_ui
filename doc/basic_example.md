Basic example
=============

To create a `Treemap` instance you need to provide a `<div>` element, a data model and a layout algorithm. The `<div>` element specifies the location of the treemap on your HTML page. In this example we use the `Leaf` and `Branch` classes included in the [TreemapUI][] library to create a nested data model. You can [extend these classes](custom_model_example.md) to customize the treemap component to your needs. Study the interface of the `TreemapStyle` class in order to alter common visual attributes such as border width and border style. 

The user can navigate within a treemap by mouse clicks. Clicking on a branch label or branch border maximizes the branch in the display area. To navigate one level upward in the hierarchy you have to click again on the already maximized branch. Please note that the branch label and border of the root branch is never visible.

**main.dart:**
```Dart
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
```

The picture below displays the result of the code in this example.

![Result of the code in this example][./example01.png]

[TreemapUI]: https://github.com/usommerl/treemap_ui/
[squarified layout algorithm]: http://www.win.tue.nl/~vanwijk/stm.pdf
