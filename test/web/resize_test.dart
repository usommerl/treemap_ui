import 'dart:html';
import 'package:treemap/treemap.dart';
import 'test_ressources.dart';

const controllsContainerId = "controllsContainer";
const treemapContainerId = "treemapContainer";
const initialSize = 525;
const min = "10";
const max = "1300";
const step = "1";

RangeInputElement widthSlider;
RangeInputElement heightSlider;
Element treemapContainer;
SelectElement algorithmSelect;
Map<String, LayoutAlgorithm> algorithmMap = initAlgorithmMap();
SelectElement modelSelect;
Map<String, DataModel> modelMap = initModelMap();

final LayoutAlgorithm sliceAndDice = new SliceAndDice();
final LayoutAlgorithm strip = new Strip();
final LayoutAlgorithm squarified = new Squarified();
List<LayoutAlgorithm> algorithms = [sliceAndDice, strip, squarified];

main() {
  prepareDocument("Resize Test");
  modelSelect.value = "dataModel2";

  widthSlider.on.change.add((e) {
    var size = widthSlider.valueAsNumber;
    treemapContainer.style.width = "${size}px";
  });
  heightSlider.on.change.add((e) {
    var size = heightSlider.valueAsNumber;
    treemapContainer.style.height = "${size}px";
  });
  algorithmSelect.on.change.add((e) {
    createNewTreemap(selectedAlgorithm(), selectedModel());
  });
  modelSelect.on.change.add((e) {
    createNewTreemap(selectedAlgorithm(), selectedModel());
  });
  createNewTreemap(selectedAlgorithm(), selectedModel());

}

void prepareDocument(String documentTitle) {
  document.title = documentTitle;
  var controllsContainer = new Element.html("<div id=${controllsContainerId}></div>");
  treemapContainer = new Element.html("<div id=${treemapContainerId} style='width:${initialSize}px;height:${initialSize}px;'></div>");
  widthSlider = new RangeInputElement();
  widthSlider
     ..min = min
     ..max = max
     ..value = initialSize.toString()
     ..step = step;
  heightSlider = new RangeInputElement();
  heightSlider
     ..min = min
     ..max = max
     ..value = initialSize.toString()
     ..step = step;
  var options = algorithmMap.keys.mappedBy((k) => "<option>$k</option>").reduce("", (acc,e) => "$acc$e");
  algorithmSelect = new Element.html("<select>$options</select>");
  options = modelMap.keys.mappedBy((k) => "<option>$k</option>").reduce("", (acc,e) => "$acc$e");
  modelSelect = new Element.html("<select>$options</select>");
  controllsContainer
    ..append(widthSlider)
    ..append(heightSlider)
    ..append(algorithmSelect)
    ..append(modelSelect);
  document.body
    ..append(controllsContainer)
    ..append(treemapContainer);
}

void createNewTreemap(LayoutAlgorithm algorithm, DataModel model) {
  treemapContainer.children.clear();
  new Treemap(treemapContainer, model, layoutAlgorithm : algorithm);    
}

LayoutAlgorithm selectedAlgorithm() {
  return algorithmMap[algorithmSelect.value];
}

DataModel selectedModel() {
  return modelMap[modelSelect.value];
}

Map<String, DataModel> initModelMap() {
  var i = 0;
  var map = new Map();
  TestRessources.testDataModels.forEach((model) {
    map["dataModel${i++}"] = model;
  });
  return map;
}

Map<String, LayoutAlgorithm> initAlgorithmMap() {
  var i = 0;
  var map = new Map();
  TestRessources.layoutAlgorithms.forEach((alg) {
    map["${alg.runtimeType.toString()}"] = alg;
  });
  return map;
}