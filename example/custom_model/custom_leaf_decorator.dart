part of treemap_ui.example.custom_model;

class CustomLeafDecorator implements LeafDecorator<City> {
  
  const CustomLeafDecorator();
  
  Element createLabel(City city) => new Element.html("<span>${city.name}</span>");

  Element createTooltip(City city) {
    Element element = new DivElement(); 
    element.style..backgroundColor = "white"
        ..fontSize = "0.8em"
        ..padding = "1px 5px 1px 5px";
    element.appendHtml("<span>${city.name}, ${city.country}</span><br/>");
    element.appendHtml("<span>population: ${city.population} million</span>");
    return element; 
  }

  Color defineNodeColor(City city) {
    var color;
    switch(city.country) {
        case 'China':
            color = Color.GOLD;
            break;
        case 'USA':
            color = Color.STEEL_BLUE;
            break;
        case 'Germany':
            color = Color.CRIMSON;
            break;
    }
    return color;
  }
}