library treemap_ui.example.custom_model;

import 'dart:html';
import 'dart:async';
import 'package:treemap_ui/treemap_ui.dart';

part 'city.dart';
part 'custom_leaf_decorator.dart';

main() {
  final displayArea = new DivElement();
  displayArea.style..width = "900px"
                   ..height = "400px";
  document.body.children.add(displayArea);
  
  final model = new Branch([new City("New York City", "USA", 1), 
                            new City("Hamburg", "Germany", 1.774), 
                            new City("Beijing", "China", 12.46), 
                            new City("Chicago", "USA", 2.696), 
                            new City("Berlin", "USA", 3.443),   
                            new City("Shanghai", "China", 14.01), 
                            new City("Zhoukou", "China", 12.07), 
                            new City("Los Angeles", "USA", 3.793),
                            new City("Munich", "Germany", 1.353)]);
  
  final treemap = new Treemap(displayArea,model,new Pivot(byMiddle),
                              leafDecorator: const CustomLeafDecorator());
  
  new Timer(const Duration(seconds: 1),(){
    final newYork = model.children.firstWhere((city) => city.name == 'New York City');
    newYork.population = 8.175;
  });
  
  new Timer(const Duration(seconds: 2),(){
    final berlin = model.children.firstWhere((city) => city.name == 'Berlin');
    berlin.country = 'Germany';
  });
}

