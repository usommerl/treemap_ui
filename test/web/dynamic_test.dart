import 'dart:html';
import 'dart:math';
import 'dart:async';
import '../resources/test_resources.dart';

const prefixDataModel = "dataModel";

final NumberInputElement widthInput = new NumberInputElement();
final NumberInputElement heightInput = new NumberInputElement();
final NumberInputElement borderWidthInput = new NumberInputElement();
final NumberInputElement branchPaddingInput = new NumberInputElement();
final NumberInputElement repaintInput = new NumberInputElement();
final NumberInputElement modelInput = new NumberInputElement();
final ButtonElement resetModelButton = new ButtonElement();
final ButtonElement repaintButton = new ButtonElement();
final Element treemapContainer = new Element.html("<div id=treemapContainer style='width:${initialSize}px;height:${initialSize}px;float:left;'></div>");
final Map<String, LayoutAlgorithm> algorithmMap = initAlgorithmMap();
final Map<int, DataModel> modelMap = initModelMap();
final Map<String, Color> colorMap = initColorMap();
final CheckboxInputElement sizeUpdateCheckbox = new CheckboxInputElement();
final NumberInputElement sizeUpdateInput = new NumberInputElement();
final CheckboxInputElement propertyUpdateCheckbox = new CheckboxInputElement();
final NumberInputElement propertyUpdateInput = new NumberInputElement();
SelectElement algorithmSelect;
SelectElement borderColorSelect;
SelectElement branchColorSelect;
int initialSize;
Timer sizeUpdateTimer = new Timer(0,(_){});
Timer propertyUpdateTimer = new Timer(0,(_){});
Treemap treemap;

main() {
  document.title = "dynamic test";
  initialSize = window.innerHeight - 16;
  initUiElements();
  registerListeners();

  modelInput.valueAsNumber = 3;
  treemap = new Treemap(treemapContainer, selectedModel, algorithm : selectedAlgorithm);
  borderColorSelect.value = treemap.style.borderColor.toString();
  branchColorSelect.value = treemap.style.branchColor.toString();
  borderWidthInput.valueAsNumber = treemap.style.borderWidth;
  branchPaddingInput.valueAsNumber = treemap.style.branchPadding;
}

void initUiElements() {
  widthInput..min = "25"..max = "950"..step = "25"..valueAsNumber = initialSize;
  heightInput..min = "25"..max = "650"..step = "25"..valueAsNumber = initialSize;
  resetModelButton.text = "reset";
  resetModelButton.title = "Resets the selected model";
  final widthControls = new DivElement();
  final widthLabel = new Element.html("<span class='controlsLabel'>treemap width:</span>");
  widthControls..append(widthLabel)..append(widthInput)..append(new Element.html("<span>px</span>"));
  final heightControls = new DivElement();
  final heightLabel = new Element.html("<span class='controlsLabel'>treemap height:</span>");
  heightControls..append(heightLabel)..append(heightInput)..append(new Element.html("<span>px</span>"));
  final borderWidthControls = new DivElement();
  borderWidthInput..min = "0"..max = "100"..step = "1";
  final borderWidthLabel = new Element.html("<span class='controlsLabel'>border width:</span>");
  borderWidthControls..append(borderWidthLabel)..append(borderWidthInput)..append(new Element.html("<span>px</span>"));
  final branchPaddingControls = new DivElement();
  branchPaddingInput..min = "0"..max = "100"..step = "1";
  final branchPaddingLabel = new Element.html("<span class='controlsLabel'>branch padding:</span>");
  branchPaddingControls..append(branchPaddingLabel)..append(branchPaddingInput)..append(new Element.html("<span>px</span>"));
  final dynamicSizeLabel = new Element.html("<span class='randomLabel'>random leaf size updates every</span>");
  sizeUpdateCheckbox.style.verticalAlign = "middle";
  sizeUpdateCheckbox.checked = false;
  final sizeUpdateLabel = new Element.html("<span>ms</span>");
  sizeUpdateInput..min = "100"..max = "10000"..step = "100"..valueAsNumber = 100;
  final sizeUpdateControls = new DivElement();
  sizeUpdateControls..append(sizeUpdateCheckbox)..append(dynamicSizeLabel)..append(sizeUpdateInput)..append(sizeUpdateLabel);
  final propertyUpdateLabel = new Element.html("<span class='randomLabel'>random property updates every</span>");
  propertyUpdateCheckbox.style.verticalAlign = "middle";
  propertyUpdateCheckbox.checked = false;
  propertyUpdateInput..min = "0"..max = "10000"..step = "10"..valueAsNumber = 50;
  final propertyUpdateControls = new DivElement();
  propertyUpdateControls..append(propertyUpdateCheckbox)..append(propertyUpdateLabel)..append(propertyUpdateInput)..append(new Element.html("<span>ms</span>"));
  final algorithmControls = new DivElement();
  final algorithmLabel = new Element.html("<span class='controlsLabel'>layout algorithm:</span>");
  var options = algorithmMap.keys.map((k) => "<option>$k</option>").reduce("", (acc,e) => "$acc$e");
  algorithmSelect = new Element.html("<select>$options</select>");
  algorithmControls..append(algorithmLabel)..append(algorithmSelect);
  final modelControls = new DivElement();
  final modelLabel = new Element.html("<span class='controlsLabel'>data model:</span>");
  modelInput..min = "0"..max ="${TestResources.testDataModels.length-1}"..step = "1";
  modelInput.style..width = "48px"..marginLeft = "2px";
  modelControls..append(modelLabel)..append(modelInput)..append(resetModelButton);
  final borderColorLabel = new Element.html("<span class='controlsLabel'>border color:</span>");
  options = colorMap.keys.map((k) => "<option style='background-color:${k};'>$k</option>").reduce("", (acc,e) => "$acc$e");
  borderColorSelect = new Element.html("<select>$options</select>");
  final borderColorControls = new DivElement();
  borderColorControls..append(borderColorLabel)..append(borderColorSelect);
  final branchColorLabel = new Element.html("<span class='controlsLabel'>branch color:</span>");
  branchColorSelect = new Element.html("<select>$options</select>");
  final branchColorControls = new DivElement();
  branchColorControls..append(branchColorLabel)..append(branchColorSelect);
  final repaintControls = new DivElement();
  repaintInput..min = "1"..max = "10000"..step = "1"..valueAsNumber = 20;
  repaintButton.text = "repaint";
  repaintButton.style.width = "90px";
  final repaintLabel = new Element.html("<span class='controlsLabel'>&nbsp;</span>");
  repaintControls..append(repaintLabel)..append(repaintInput)..append(new Element.html("<span> x </span>"))..append(repaintButton);
  final controlsContainer = new Element.html("<div id=controlsContainer></div>");
  controlsContainer
    ..append(algorithmControls)
    ..append(modelControls)
    ..append(widthControls)
    ..append(heightControls)
    ..append(borderWidthControls)
    ..append(branchPaddingControls)
    ..append(borderColorControls)
    ..append(branchColorControls)
    ..append(new Element.html("<div class='divider'></div>"))
    ..append(sizeUpdateControls)
    ..append(propertyUpdateControls)
    ..append(new Element.html("<div class='divider'></div>"))
    ..append(repaintControls);
  document.body
    ..append(controlsContainer)
    ..append(treemapContainer);
}

void registerListeners() {
  widthInput.onChange.listen((e) {
    if(widthInput.validity.valid) {
      treemapContainer.style.width = "${widthInput.value}px";
    }
  });
  heightInput.onChange.listen((e) {
    if (heightInput.validity.valid) {
      treemapContainer.style.height = "${heightInput.value}px";
    }
  });
  borderWidthInput.onChange.listen((e) {
    if (borderWidthInput.validity.valid) {
      treemap.style.borderWidth = borderWidthInput.valueAsNumber.toInt();
    }
  });
  branchPaddingInput.onChange.listen((e) {
    if (branchPaddingInput.validity.valid) {
      treemap.style.branchPadding = branchPaddingInput.valueAsNumber.toInt();
    }
  });
  algorithmSelect.onChange.listen((e) {
    treemap.layoutAlgorithm = selectedAlgorithm;
  });
  modelInput.onChange.listen((e) {
    if(modelInput.validity.valid) {
      treemap.model = selectedModel;
    }
  });
  borderColorSelect.onChange.listen((e) {
    treemap.style.borderColor = selectedColor(borderColorSelect);
  });
  branchColorSelect.onChange.listen((e) {
    treemap.style.branchColor = selectedColor(branchColorSelect);
  });
  sizeUpdateCheckbox.onChange.listen((e) {
    sizeUpdateTimer = new Timer.repeating(new Duration(milliseconds: sizeUpdateInput.valueAsNumber.toInt()),randomSizeCallback);
  });
  propertyUpdateCheckbox.onChange.listen((e) {
    propertyUpdateTimer = new Timer.repeating(new Duration(milliseconds: propertyUpdateInput.valueAsNumber.toInt()),randomPropertyCallback);
  });
  sizeUpdateInput.onChange.listen((e) {
    if (sizeUpdateInput.validity.valid) {
      sizeUpdateTimer.cancel();
      sizeUpdateTimer = new Timer.repeating(new Duration(milliseconds: sizeUpdateInput.valueAsNumber.toInt()),randomSizeCallback);
    }
  });
  propertyUpdateInput.onChange.listen((e) {
    if (propertyUpdateInput.validity.valid) {
      propertyUpdateTimer.cancel();
      propertyUpdateTimer = new Timer.repeating(new Duration(milliseconds: propertyUpdateInput.valueAsNumber.toInt()),randomPropertyCallback);
    }
  });
  resetModelButton.onClick.listen((e) {
    if(modelInput.validity.valid) {
      final index = modelInput.valueAsNumber.toInt();
      final tmp = TestResources.testDataModels.elementAt(index);
      final model = tmp.isBranch ? tmp as Branch : tmp as Leaf;
      final copy = model.copy();
      modelMap[index] = copy;
      treemap.model = selectedModel;
    }
  });
  repaintButton.onClick.listen((e) {
    if (repaintInput.validity.valid) {
      final abort = repaintInput.valueAsNumber.toInt();
      for(var i = 0; i < abort; i++) {
        // Delay of execution is crucial! Otherwise the recording 
        // of timeline data with chrome-dev-tools will fail.  
        new Timer(const Duration(milliseconds: 100), (){
          treemap.repaint();          
        });
      }
    }
  });
  repaintButton.onMouseOver.listen((e) {
    if (repaintInput.validity.valid) {
      final value = repaintInput.valueAsNumber.toInt();
      if (value > 1) {
        repaintButton.title = "Repaints the treemap ${repaintInput.valueAsNumber.toInt()} times";
      } else {
        repaintButton.title = "Repaints the treemap ${repaintInput.valueAsNumber.toInt()} time";
      }
    } else {
      repaintButton.title = "Value in number input element not valid!";
    }
  });
}

LayoutAlgorithm get selectedAlgorithm => algorithmMap[algorithmSelect.value];

DataModel get selectedModel => modelMap[modelInput.valueAsNumber.toInt()];

Color selectedColor(SelectElement select) => colorMap[select.value];

Map<int, DataModel> initModelMap() {
  var i = 0;
  final map = new Map<int, DataModel>();
  TestResources.testDataModels.forEach((model) {
    map[i++] = model.copy();
  });
  return map;
}

Map<String, Color> initColorMap() {
  final map = new Map<String, Color>();
  TestResources.namedColors.forEach((color) {
    map[color.toString()] = color;
  });
  return map;
}

Map<String, LayoutAlgorithm> initAlgorithmMap() {
  final map = new Map<String, LayoutAlgorithm>();
  TestResources.layoutAlgorithms.forEach((alg) {
    map["${alg.runtimeType.toString().toLowerCase()}"] = alg;
  });
  return map;
}

final randomSizeCallback = (Timer timer) =>
  timerCallback(timer, sizeUpdateCheckbox, (l,r) => l.size = r.nextInt(1000));

final randomPropertyCallback = (Timer timer) =>
  timerCallback(timer, propertyUpdateCheckbox, (l,r) => l.someProperty = r.nextInt(1000));

final timerCallback = (Timer timer, CheckboxInputElement checkbox, void f(Leaf l, Random r)) {
  final Random r = new Random();
  if (checkbox.checked) {
    final leafes = leafesOnly(selectedModel);
    final leaf = leafes.elementAt(r.nextInt(leafes.length));
    f(leaf, r);
  } else {
    timer.cancel();
  }
};

List<Leaf> leafesOnly(DataModel model) {
  final List<AbstractLeaf> result = [];
  if (model.isLeaf) {
    result.add(model);
  } else {
    final branch = model as AbstractBranch;
    branch.children.map((child) => leafesOnly(child)).forEach((x) => result.addAll(x));
  }
  return result;
}