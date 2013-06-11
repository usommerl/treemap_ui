import 'dart:html';
import '../resources/test_resources.dart';

const treeMapClass = "treemapContainer";
const descriptionClass = "description";
const sizeTreemap = 300;
const margin = 7;

main() {
    prepareDocument("static test");
    List<LayoutAlgorithm> algorithms = TestResources.layoutAlgorithms;
    List<DataModel> models = TestResources.testDataModels;

    algorithms.forEach((algorithm) {
      final algorithmName = algorithm.runtimeType.toString();
      final description = new Element.html("<div id='${algorithmName}' class='${descriptionClass}'>${algorithmName} Algorithm</div>");
      document.body.children.add(description);
      for(var i = 0; i < models.length; i++) {
        final String testId = "${algorithmName}${i}";
        final treemapContainer = new Element.html("<div id='${testId}' class='${treeMapClass}'></div>");
        document.body.children.add(treemapContainer);
        new Treemap(treemapContainer, models[i], algorithm);
      }
    });
    // Only for screenshots
    document.body.children.add(new Element.html("<div style='width: 100%;height: 100px;clear: both'>&nbsp;</div>"));
}

void prepareDocument(String documentTitle) {
  document.title = documentTitle;
  final styleSheet = document.styleSheets.first as CssStyleSheet;
  styleSheet.addRule(".${treeMapClass}", "width: ${sizeTreemap}px; height: ${sizeTreemap}px; margin-right: ${margin}px; margin-bottom: ${margin}px; float: left;");
  styleSheet.addRule(".${descriptionClass}", "margin-bottom: ${margin}px; clear: both; display: block");
}
