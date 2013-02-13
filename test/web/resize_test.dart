import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'package:treemap/treemap.dart';
import '../resources/test_resources.dart';

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
CheckboxInputElement randomSizeCheckbox = new CheckboxInputElement();
Map<String, DataModel> modelMap = initModelMap();
Timer sizeUpdateTimer;
NumberInputElement sizeUpdateInput = new NumberInputElement();
Treemap treemap;

List<LayoutAlgorithm> algorithms = TestResources.layoutAlgorithms;

main() {
  prepareDocument("Resize Test");
  modelSelect.value = "dataModel2";

  widthSlider.onChange.listen((e) {
    var size = widthSlider.valueAsNumber;
    treemapContainer.style.width = "${size}px";
  });
  heightSlider.onChange.listen((e) {
    var size = heightSlider.valueAsNumber;
    treemapContainer.style.height = "${size}px";
  });
  algorithmSelect.onChange.listen((e) {
    treemap.layoutAlgorithm = selectedAlgorithm();
  });
  modelSelect.onChange.listen((e) {
    treemap.model = selectedModel();
  });
  randomSizeCheckbox.onChange.listen((e) {
    sizeUpdateTimer = new Timer.repeating(sizeUpdateInput.valueAsNumber.toInt(),randomSizeFunction);
  });
  sizeUpdateInput.onChange.listen((e) {
    sizeUpdateTimer.cancel();
    sizeUpdateTimer = new Timer.repeating(sizeUpdateInput.valueAsNumber.toInt(),randomSizeFunction);
  });
  createNewTreemap(selectedAlgorithm(), selectedModel());
}

void prepareDocument(String documentTitle) {
  document.title = documentTitle;
  final controllsContainer = new Element.html("<div id=${controllsContainerId}></div>");
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
  final sizeControls = new DivElement();
  sizeControls..append(widthSlider)..append(heightSlider);
  final dynamicSizeLabel = new Element.html("<span> random size updates every </span>");
  randomSizeCheckbox.style.verticalAlign = "middle";
  randomSizeCheckbox.checked = false;
  final sizeUpdateLabel = new Element.html("<span> ms</span>");
  sizeUpdateInput..min = "100"..max = "10000"..step = "100"..valueAsNumber = 200;
  final dynamicSizeControls = new DivElement();
  dynamicSizeControls..append(randomSizeCheckbox)..append(dynamicSizeLabel)..append(sizeUpdateInput)..append(sizeUpdateLabel);
  var options = algorithmMap.keys.map((k) => "<option>$k</option>").reduce("", (acc,e) => "$acc$e");
  algorithmSelect = new Element.html("<select>$options</select>");
  options = modelMap.keys.map((k) => "<option>$k</option>").reduce("", (acc,e) => "$acc$e");
  modelSelect = new Element.html("<select>$options</select>");
  controllsContainer
    ..append(algorithmSelect)
    ..append(modelSelect)
    ..append(dynamicSizeControls)
    ..append(sizeControls);
  document.body
    ..append(controllsContainer)
    ..append(treemapContainer);
}

void createNewTreemap(LayoutAlgorithm algorithm, DataModel model) {
  treemapContainer.children.clear();
  treemap = new Treemap(treemapContainer, model, algorithm : algorithm);    
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
  TestResources.testDataModels.forEach((model) {
    map["dataModel${i++}"] = model;
  });
  return map;
}

Map<String, LayoutAlgorithm> initAlgorithmMap() {
  var map = new Map();
  TestResources.layoutAlgorithms.forEach((alg) {
    map["${alg.runtimeType.toString().toLowerCase()}"] = alg;
  });
  return map;
}

final randomSizeFunction = (Timer timer) {
  final Random r = new Random();
  if (randomSizeCheckbox.checked) {
    final leafes = leafesOnly(selectedModel());
    final leaf = leafes.elementAt(r.nextInt(leafes.length));
    leaf.size = r.nextInt(1000);      
  } else {
    timer.cancel();
  }
};

List<AbstractLeaf> leafesOnly(DataModel model) {
  final List<AbstractLeaf> result = [];
  if (model.isLeaf) {
    result.add(model);
  } else {
    final branch = model as AbstractBranch;
    branch.children.map((child) => leafesOnly(child)).forEach((x) => result.addAll(x));
  }
  return result;
}