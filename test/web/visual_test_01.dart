import 'dart:html';
import 'package:treemap/treemap.dart';
import 'test_ressources.dart';

const treeMapClass = "treemapContainer";
const descriptionClass = "description";
const sizeTreemap = 300;
const margin = 7;

main() {
    prepareDocument("Visual Tests");
    final sliceAndDice = new SliceAndDice();
    final strip = new Strip();
    final squarified = new Squarified();
    List<LayoutAlgorithm> algorithms = [squarified, strip, sliceAndDice];
    List<DataModel> models = TestRessources.testDataModels;
    
    algorithms.forEach((algorithm) {
      final algorithmName = algorithm.runtimeType.toString();
      final description = new Element.html("<div class='${descriptionClass}'>${algorithmName} Algorithm</div>");
      document.body.children.addLast(description);
      for(var i = 0; i < models.length; i++) {
        final String testId = "${algorithmName}${i}";
        final treemapContainer = new Element.html("<div id='${testId}' class='${treeMapClass}'></div>");
        document.body.children.addLast(treemapContainer);
        new TreeMap(treemapContainer, models[i], algorithm);
      }
    });
}

void prepareDocument(String documentTitle) {
  document.title = documentTitle;
  final styleSheet = document.styleSheets.first as CssStyleSheet;
  styleSheet.addRule(".${treeMapClass}", "width: ${sizeTreemap}px; height: ${sizeTreemap}px; margin-right: ${margin}px; margin-bottom: ${margin}px; float: left;");
  styleSheet.addRule(".${descriptionClass}", "margin-bottom: ${margin}px; clear: both;");
}