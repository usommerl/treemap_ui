part of treemap_utils;

class Color {
  
  String _value;
  
  Color.rgb(List<int> values) {
    if (values == null || values.length != 3 || values.any((v) => v < 0 || v > 255)) {
      throw new ArgumentError("Not a valid RGB color definition");
    }
    _value = "rgb(${values.join(",")})";
  }
  
  Color.hex(String hex) {
    if (hex == null) {
      throw new ArgumentError("Not a valid HEX color definition");
    }
    if (!hex.startsWith("#")) {
      hex = "#".concat(hex);
    }
    RegExp exp = new RegExp(r"^#([0-9a-f]{3}|[0-9a-f]{6})$", caseSensitive: false);
    if (exp.allMatches(hex).isEmpty) {
      throw new ArgumentError("Not a valid HEX color definition");
    }
    _value = hex;
  }

  String toString() => _value;
  
  static const Color aliceBlue = const NamedColor("AliceBlue");
  static const Color antiqueWhite = const NamedColor("AntiqueWhite");
  static const Color aqua = const NamedColor("Aqua");
  static const Color aquamarine = const NamedColor("Aquamarine");
  static const Color azure = const NamedColor("Azure");
  static const Color beige = const NamedColor("Beige");
  static const Color bisque = const NamedColor("Bisque");
  static const Color black = const NamedColor("Black");
  static const Color blanchedAlmond = const NamedColor("BlanchedAlmond");
  static const Color blue = const NamedColor("Blue");
  static const Color blueViolet = const NamedColor("BlueViolet");
  static const Color brown = const NamedColor("Brown");
  static const Color burlyWood = const NamedColor("BurlyWood");
  static const Color cadetBlue = const NamedColor("CadetBlue");
  static const Color chartreuse = const NamedColor("Chartreuse");
  static const Color chocolate = const NamedColor("Chocolate");
  static const Color coral = const NamedColor("Coral");
  static const Color cornflowerBlue = const NamedColor("CornflowerBlue");
  static const Color cornsilk = const NamedColor("Cornsilk");
  static const Color crimson = const NamedColor("Crimson");
  static const Color cyan = const NamedColor("Cyan");
  static const Color darkBlue = const NamedColor("DarkBlue");
  static const Color darkCyan = const NamedColor("DarkCyan");
  static const Color darkGoldenRod = const NamedColor("DarkGoldenRod");
  static const Color darkGray = const NamedColor("DarkGray");
  static const Color darkGrey = const NamedColor("DarkGrey");
  static const Color darkGreen = const NamedColor("DarkGreen");
  static const Color darkKhaki = const NamedColor("DarkKhaki");
  static const Color darkMagenta = const NamedColor("DarkMagenta");
  static const Color darkOliveGreen = const NamedColor("DarkOliveGreen");
  static const Color darkorange = const NamedColor("Darkorange");
  static const Color darkOrchid = const NamedColor("DarkOrchid");
  static const Color darkRed = const NamedColor("DarkRed");
  static const Color darkSalmon = const NamedColor("DarkSalmon");
  static const Color darkSeaGreen = const NamedColor("DarkSeaGreen");
  static const Color darkSlateBlue = const NamedColor("DarkSlateBlue");
  static const Color darkSlateGray = const NamedColor("DarkSlateGray");
  static const Color darkSlateGrey = const NamedColor("DarkSlateGrey");
  static const Color darkTurquoise = const NamedColor("DarkTurquoise");
  static const Color darkViolet = const NamedColor("DarkViolet");
  static const Color deepPink = const NamedColor("DeepPink");
  static const Color deepSkyBlue = const NamedColor("DeepSkyBlue");
  static const Color dimGray = const NamedColor("DimGray");
  static const Color dimGrey = const NamedColor("DimGrey");
  static const Color dodgerBlue = const NamedColor("DodgerBlue");
  static const Color fireBrick = const NamedColor("FireBrick");
  static const Color floralWhite = const NamedColor("FloralWhite");
  static const Color forestGreen = const NamedColor("ForestGreen");
  static const Color fuchsia = const NamedColor("Fuchsia");
  static const Color gainsboro = const NamedColor("Gainsboro");
  static const Color ghostWhite = const NamedColor("GhostWhite");
  static const Color gold = const NamedColor("Gold");
  static const Color goldenRod = const NamedColor("GoldenRod");
  static const Color gray = const NamedColor("Gray");
  static const Color grey = const NamedColor("Grey");
  static const Color green = const NamedColor("Green");
  static const Color greenYellow = const NamedColor("GreenYellow");
  static const Color honeyDew = const NamedColor("HoneyDew");
  static const Color hotPink = const NamedColor("HotPink");
  static const Color indianRed = const NamedColor("IndianRed");
  static const Color indigo = const NamedColor("Indigo");
  static const Color ivory = const NamedColor("Ivory");
  static const Color khaki = const NamedColor("Khaki");
  static const Color lavender = const NamedColor("Lavender");
  static const Color lavenderBlush = const NamedColor("LavenderBlush");
  static const Color lawnGreen = const NamedColor("LawnGreen");
  static const Color lemonChiffon = const NamedColor("LemonChiffon");
  static const Color lightBlue = const NamedColor("LightBlue");
  static const Color lightCoral = const NamedColor("LightCoral");
  static const Color lightCyan = const NamedColor("LightCyan");
  static const Color lightGoldenRodYellow = const NamedColor("LightGoldenRodYellow");
  static const Color lightGray = const NamedColor("LightGray");
  static const Color lightGrey = const NamedColor("LightGrey");
  static const Color lightGreen = const NamedColor("LightGreen");
  static const Color lightPink = const NamedColor("LightPink");
  static const Color lightSalmon = const NamedColor("LightSalmon");
  static const Color lightSeaGreen = const NamedColor("LightSeaGreen");
  static const Color lightSkyBlue = const NamedColor("LightSkyBlue");
  static const Color lightSlateGray = const NamedColor("LightSlateGray");
  static const Color lightSlateGrey = const NamedColor("LightSlateGrey");
  static const Color lightSteelBlue = const NamedColor("LightSteelBlue");
  static const Color lightYellow = const NamedColor("LightYellow");
  static const Color lime = const NamedColor("Lime");
  static const Color limeGreen = const NamedColor("LimeGreen");
  static const Color linen = const NamedColor("Linen");
  static const Color magenta = const NamedColor("Magenta");
  static const Color maroon = const NamedColor("Maroon");
  static const Color mediumAquaMarine = const NamedColor("MediumAquaMarine");
  static const Color mediumBlue = const NamedColor("MediumBlue");
  static const Color mediumOrchid = const NamedColor("MediumOrchid");
  static const Color mediumPurple = const NamedColor("MediumPurple");
  static const Color mediumSeaGreen = const NamedColor("MediumSeaGreen");
  static const Color mediumSlateBlue = const NamedColor("MediumSlateBlue");
  static const Color mediumSpringGreen = const NamedColor("MediumSpringGreen");
  static const Color mediumTurquoise = const NamedColor("MediumTurquoise");
  static const Color mediumVioletRed = const NamedColor("MediumVioletRed");
  static const Color midnightBlue = const NamedColor("MidnightBlue");
  static const Color mintCream = const NamedColor("MintCream");
  static const Color mistyRose = const NamedColor("MistyRose");
  static const Color moccasin = const NamedColor("Moccasin");
  static const Color navajoWhite = const NamedColor("NavajoWhite");
  static const Color navy = const NamedColor("Navy");
  static const Color oldLace = const NamedColor("OldLace");
  static const Color olive = const NamedColor("Olive");
  static const Color oliveDrab = const NamedColor("OliveDrab");
  static const Color orange = const NamedColor("Orange");
  static const Color orangeRed = const NamedColor("OrangeRed");
  static const Color orchid = const NamedColor("Orchid");
  static const Color paleGoldenRod = const NamedColor("PaleGoldenRod");
  static const Color paleGreen = const NamedColor("PaleGreen");
  static const Color paleTurquoise = const NamedColor("PaleTurquoise");
  static const Color paleVioletRed = const NamedColor("PaleVioletRed");
  static const Color papayaWhip = const NamedColor("PapayaWhip");
  static const Color peachPuff = const NamedColor("PeachPuff");
  static const Color peru = const NamedColor("Peru");
  static const Color pink = const NamedColor("Pink");
  static const Color plum = const NamedColor("Plum");
  static const Color powderBlue = const NamedColor("PowderBlue");
  static const Color purple = const NamedColor("Purple");
  static const Color red = const NamedColor("Red");
  static const Color rosyBrown = const NamedColor("RosyBrown");
  static const Color royalBlue = const NamedColor("RoyalBlue");
  static const Color saddleBrown = const NamedColor("SaddleBrown");
  static const Color salmon = const NamedColor("Salmon");
  static const Color sandyBrown = const NamedColor("SandyBrown");
  static const Color seaGreen = const NamedColor("SeaGreen");
  static const Color seaShell = const NamedColor("SeaShell");
  static const Color sienna = const NamedColor("Sienna");
  static const Color silver = const NamedColor("Silver");
  static const Color skyBlue = const NamedColor("SkyBlue");
  static const Color slateBlue = const NamedColor("SlateBlue");
  static const Color slateGray = const NamedColor("SlateGray");
  static const Color slateGrey = const NamedColor("SlateGrey");
  static const Color snow = const NamedColor("Snow");
  static const Color springGreen = const NamedColor("SpringGreen");
  static const Color steelBlue = const NamedColor("SteelBlue");
  static const Color tan = const NamedColor("Tan");
  static const Color teal = const NamedColor("Teal");
  static const Color thistle = const NamedColor("Thistle");
  static const Color tomato = const NamedColor("Tomato");
  static const Color turquoise = const NamedColor("Turquoise");
  static const Color violet = const NamedColor("Violet");
  static const Color wheat = const NamedColor("Wheat");
  static const Color white = const NamedColor("White");
  static const Color whiteSmoke = const NamedColor("WhiteSmoke");
  static const Color yellow = const NamedColor("Yellow");
  static const Color yellowGreen = const NamedColor("YellowGreen");
}

class NamedColor implements Color {
  
  final String _value;
  
  const NamedColor(String this._value);
  
  String toString() => _value;
  
}

