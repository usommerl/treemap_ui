part of treemap_test_resources;

class Leaf extends AbstractLeaf {

  int _someProperty = 0;

  static final List<Color> grayscale =
                       [new Color.hex('#F0F0F0'), new Color.hex('#E8E8E8'),
                        new Color.hex('#E0E0E0'), new Color.hex('#D8D8D8'),
                        new Color.hex('#D0D0D0'), new Color.hex('#C8C8C8'),
                        new Color.hex('#C0C0C0'), new Color.hex('#B8B8B8'),
                        new Color.hex('#B0B0B0'), new Color.hex('#A8A8A8'),
                        new Color.hex('#A0A0A0'), new Color.hex('#989898'),
                        new Color.hex('#909090'), new Color.hex('#888888'),
                        new Color.hex('#808080'), new Color.hex('#787878'),
                        new Color.hex('#707070'), new Color.hex('#686868'),
                        new Color.hex('#606060'), new Color.hex('#585858'),
                        new Color.hex('#505050')];

  List<Color> _colors = [Color.CRIMSON, Color.GOLD, Color.KHAKI,
                         Color.LIGHT_STEEL_BLUE, Color.MEDIUM_VIOLET_RED,
                         Color.ROSY_BROWN, Color.YELLOW_GREEN];

  Leaf(num size) : super(size);

  Element get label => new Element.html("<span class='myLabel'>${_someProperty}</span>");

  Element get tooltip {
    Element element = new Element.html("<div></div>");
    element.style..backgroundColor = "white"
        ..fontSize = "0.8em"
        ..padding = "1px 5px 1px 5px";
    element.text = "Leaf [size: ${size}, someProperty: ${someProperty}]";
    return element;
  }

  set someProperty(int value) {
    _someProperty = value;
    repaintNode();
  }

  int get someProperty => _someProperty;

  Color get backgroundColor {
    if (someProperty < grayscale.length - 1) {
      return grayscale.elementAt(someProperty);
    } else {
      return _colors.elementAt(someProperty % _colors.length);
    }
  }

  /**
   * Creates a deep copy of this [Leaf].
   * The parent reference will **not** be copied to the clone.
   **/
  Leaf copy() {
    return new Leaf(size);
  }
}
