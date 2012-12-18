import 'dart:html';
import 'package:treemap/treemap.dart';
import 'test_ressources.dart';

main() {
    document.title = "Visual Tests";
    final treeMapClass = "treemapArea";
    final descriptionClass = "description";
    final sizeTreemap = 300;
    final margin = 7;
    final styleSheet = document.styleSheets.first as CssStyleSheet;
    styleSheet.addRule(".${treeMapClass}", "width: ${sizeTreemap}px; height: ${sizeTreemap}px; margin-right: ${margin}px; margin-bottom: ${margin}px; float: left;");
    styleSheet.addRule(".${descriptionClass}", "margin-bottom: ${margin}px; clear: both;");
    
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
        final treemapArea = new Element.html("<div id='${testId}' class='${treeMapClass}'></div>");
        document.body.children.addLast(treemapArea);
        new TreeMap(treemapArea, models[i], algorithm);
      }
    });
}