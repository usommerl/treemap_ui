part of treemap_ui.utils;

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

  static const Color ALICE_BLUE = const NamedColor("aliceblue");
  static const Color ANTIQUE_WHITE = const NamedColor("AntiqueWhite");
  static const Color AQUA = const NamedColor("Aqua");
  static const Color AQUAMARINE = const NamedColor("Aquamarine");
  static const Color AZURE = const NamedColor("Azure");
  static const Color BEIGE = const NamedColor("Beige");
  static const Color BISQUE = const NamedColor("Bisque");
  static const Color BLACK = const NamedColor("Black");
  static const Color BLANCHED_ALMOND = const NamedColor("BlanchedAlmond");
  static const Color BLUE = const NamedColor("Blue");
  static const Color BLUE_VIOLET = const NamedColor("BlueViolet");
  static const Color BROWN = const NamedColor("Brown");
  static const Color BURLYWOOD = const NamedColor("BurlyWood");
  static const Color CADET_BLUE = const NamedColor("CadetBlue");
  static const Color CHARTREUSE = const NamedColor("Chartreuse");
  static const Color CHOCOLATE = const NamedColor("Chocolate");
  static const Color CORAL = const NamedColor("Coral");
  static const Color CORNFLOWER_BLUE = const NamedColor("CornflowerBlue");
  static const Color CORNSILK = const NamedColor("Cornsilk");
  static const Color CRIMSON = const NamedColor("Crimson");
  static const Color CYAN = const NamedColor("Cyan");
  static const Color DARK_BLUE = const NamedColor("DarkBlue");
  static const Color DARK_CYAN = const NamedColor("DarkCyan");
  static const Color DARK_GOLDEN_ROD = const NamedColor("DarkGoldenRod");
  static const Color DARK_GRAY = const NamedColor("DarkGray");
  static const Color DARK_GREY = const NamedColor("DarkGrey");
  static const Color DARK_GREEN = const NamedColor("DarkGreen");
  static const Color DARK_KHAKI = const NamedColor("DarkKhaki");
  static const Color DARK_MAGENTA = const NamedColor("DarkMagenta");
  static const Color DARK_OLIVE_GREEN = const NamedColor("DarkOliveGreen");
  static const Color DARK_ORANGE = const NamedColor("Darkorange");
  static const Color DARK_ORCHID = const NamedColor("DarkOrchid");
  static const Color DARK_RED = const NamedColor("DarkRed");
  static const Color DARK_SALMON = const NamedColor("DarkSalmon");
  static const Color DARK_SEA_GREEN = const NamedColor("DarkSeaGreen");
  static const Color DARK_SLATE_BLUE = const NamedColor("DarkSlateBlue");
  static const Color DARK_SLATE_GRAY = const NamedColor("DarkSlateGray");
  static const Color DARK_SLATE_GREY = const NamedColor("DarkSlateGrey");
  static const Color DARK_TURQUOISE = const NamedColor("DarkTurquoise");
  static const Color DARK_VIOLET = const NamedColor("DarkViolet");
  static const Color DEEP_PINK = const NamedColor("DeepPink");
  static const Color DEEP_SKY_BLUE = const NamedColor("DeepSkyBlue");
  static const Color DIM_GRAY = const NamedColor("DimGray");
  static const Color DIM_GREY = const NamedColor("DimGrey");
  static const Color DODGER_BLUE = const NamedColor("DodgerBlue");
  static const Color FIRE_BRICK = const NamedColor("FireBrick");
  static const Color FLORAL_WHITE = const NamedColor("FloralWhite");
  static const Color FOREST_GREEN = const NamedColor("ForestGreen");
  static const Color FUCHSIA = const NamedColor("Fuchsia");
  static const Color GAINSBORO = const NamedColor("Gainsboro");
  static const Color GHOST_WHITE = const NamedColor("GhostWhite");
  static const Color GOLD = const NamedColor("Gold");
  static const Color GOLDEN_ROD = const NamedColor("GoldenRod");
  static const Color GRAY = const NamedColor("Gray");
  static const Color GREY = const NamedColor("Grey");
  static const Color GREEN = const NamedColor("Green");
  static const Color GREEN_YELLOW = const NamedColor("GreenYellow");
  static const Color HONEY_DEW = const NamedColor("HoneyDew");
  static const Color HOT_PINK = const NamedColor("HotPink");
  static const Color INDIAN_RED = const NamedColor("IndianRed");
  static const Color INDIGO = const NamedColor("Indigo");
  static const Color IVORY = const NamedColor("Ivory");
  static const Color KHAKI = const NamedColor("Khaki");
  static const Color LAVENDER = const NamedColor("Lavender");
  static const Color LAVENDER_BLUSH = const NamedColor("LavenderBlush");
  static const Color LAWN_GREEN = const NamedColor("LawnGreen");
  static const Color LEMON_CHIFFON = const NamedColor("LemonChiffon");
  static const Color LIGHT_BLUE = const NamedColor("LightBlue");
  static const Color LIGHT_CORAL = const NamedColor("LightCoral");
  static const Color LIGHT_CYAN = const NamedColor("LightCyan");
  static const Color LIGHT_GOLDEN_ROD_YELLOW = const NamedColor("LightGoldenRodYellow");
  static const Color LIGHT_GRAY = const NamedColor("LightGray");
  static const Color LIGHT_GREY = const NamedColor("LightGrey");
  static const Color LIGHT_GREEN = const NamedColor("LightGreen");
  static const Color LIGHT_PINK = const NamedColor("LightPink");
  static const Color LIGHT_SALMON = const NamedColor("LightSalmon");
  static const Color LIGHT_SEA_GREEN = const NamedColor("LightSeaGreen");
  static const Color LIGHT_SKY_BLUE = const NamedColor("LightSkyBlue");
  static const Color LIGHT_SLATE_GRAY = const NamedColor("LightSlateGray");
  static const Color LIGHT_SLATE_GREY = const NamedColor("LightSlateGrey");
  static const Color LIGHT_STEEL_BLUE = const NamedColor("LightSteelBlue");
  static const Color LIGHT_YELLOW = const NamedColor("LightYellow");
  static const Color LIME = const NamedColor("Lime");
  static const Color LIME_GREEN = const NamedColor("LimeGreen");
  static const Color LINEN = const NamedColor("Linen");
  static const Color MAGENTA = const NamedColor("Magenta");
  static const Color MAROON = const NamedColor("Maroon");
  static const Color MEDIUM_AQUA_MARINE = const NamedColor("MediumAquaMarine");
  static const Color MEDIUM_BLUE = const NamedColor("MediumBlue");
  static const Color MEDIUM_ORCHID = const NamedColor("MediumOrchid");
  static const Color MEDIUM_PURPLE = const NamedColor("MediumPurple");
  static const Color MEDIUM_SEA_GREEN = const NamedColor("MediumSeaGreen");
  static const Color MEDIUM_SLATE_BLUE = const NamedColor("MediumSlateBlue");
  static const Color MEDIUM_SPRING_GREEN = const NamedColor("MediumSpringGreen");
  static const Color MEDIUM_TURQUOISE = const NamedColor("MediumTurquoise");
  static const Color MEDIUM_VIOLET_RED = const NamedColor("MediumVioletRed");
  static const Color MIDNIGHT_BLUE = const NamedColor("MidnightBlue");
  static const Color MINT_CREAM = const NamedColor("MintCream");
  static const Color MISTY_ROSE = const NamedColor("MistyRose");
  static const Color MOCCASIN = const NamedColor("Moccasin");
  static const Color NAVAJO_WHITE = const NamedColor("NavajoWhite");
  static const Color NAVY = const NamedColor("Navy");
  static const Color OLD_LACE = const NamedColor("OldLace");
  static const Color OLIVE = const NamedColor("Olive");
  static const Color OLIVE_DRAB = const NamedColor("OliveDrab");
  static const Color ORANGE = const NamedColor("Orange");
  static const Color ORANGE_RED = const NamedColor("OrangeRed");
  static const Color ORCHID = const NamedColor("Orchid");
  static const Color PALE_GOLDEN_ROD = const NamedColor("PaleGoldenRod");
  static const Color PALE_GREEN = const NamedColor("PaleGreen");
  static const Color PALE_TURQUOISE = const NamedColor("PaleTurquoise");
  static const Color PALE_VIOLET_RED = const NamedColor("PaleVioletRed");
  static const Color PAPAYA_WHIP = const NamedColor("PapayaWhip");
  static const Color PEACH_PUFF = const NamedColor("PeachPuff");
  static const Color PERU = const NamedColor("Peru");
  static const Color PINK = const NamedColor("Pink");
  static const Color PLUM = const NamedColor("Plum");
  static const Color POWDER_BLUE = const NamedColor("PowderBlue");
  static const Color PURPLE = const NamedColor("Purple");
  static const Color RED = const NamedColor("Red");
  static const Color ROSY_BROWN = const NamedColor("RosyBrown");
  static const Color ROYAL_BLUE = const NamedColor("RoyalBlue");
  static const Color SADDLE_BROWN = const NamedColor("SaddleBrown");
  static const Color SALMON = const NamedColor("Salmon");
  static const Color SANDY_BROWN = const NamedColor("SandyBrown");
  static const Color SEA_GREEN = const NamedColor("SeaGreen");
  static const Color SEA_SHELL = const NamedColor("SeaShell");
  static const Color SIENNA = const NamedColor("Sienna");
  static const Color SILVER = const NamedColor("Silver");
  static const Color SKY_BLUE = const NamedColor("SkyBlue");
  static const Color SLATE_BLUE = const NamedColor("SlateBlue");
  static const Color SLATE_GRAY = const NamedColor("SlateGray");
  static const Color SLATE_GREY = const NamedColor("SlateGrey");
  static const Color SNOW = const NamedColor("Snow");
  static const Color SPRING_GREEN = const NamedColor("SpringGreen");
  static const Color STEEL_BLUE = const NamedColor("SteelBlue");
  static const Color TAN = const NamedColor("Tan");
  static const Color TEAL = const NamedColor("Teal");
  static const Color THISTLE = const NamedColor("Thistle");
  static const Color TOMATO = const NamedColor("Tomato");
  static const Color TURQUOISE = const NamedColor("Turquoise");
  static const Color VIOLET = const NamedColor("Violet");
  static const Color WHEAT = const NamedColor("Wheat");
  static const Color WHITE = const NamedColor("White");
  static const Color WHITE_SMOKE = const NamedColor("WhiteSmoke");
  static const Color YELLOW = const NamedColor("Yellow");
  static const Color YELLOW_GREEN = const NamedColor("YellowGreen");
}

class NamedColor implements Color {

  final String _value;

  const NamedColor(String this._value);

  String toString() => _value;

}

