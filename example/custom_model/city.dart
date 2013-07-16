part of treemap_ui.example.custom_model;

class City extends Leaf {

  String _name;
  String _country;
  
  City(this._name, this._country, num population) : super(population);
  
  String get name => _name;
  
  set name(String name) {
    _name = name;
    fireVisiblePropertyChangedEvent();
  }
  
  String get country => _country;
  
  set country(String country) {
    _country = country;
    fireVisiblePropertyChangedEvent();
  }
  
  num get population => size;

  set population(num population) => this.size = population;
  
}
