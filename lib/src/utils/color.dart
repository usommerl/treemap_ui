part of treemap_ui.utils;

/// A very simple color implementation in order to specify typed color values.
class Color {

  String _value;

  Color.rgb(int r, int g, int b) {
    if (r == null || g == null || b == null || [r,g,b].any((v) => v < 0 || v > 255)) {
      throw new ArgumentError("Not a valid RGB color definition");
    }
    _value = "rgb(${r},${g},${b})";
  }

  Color.hex(String hex) {
    if (hex == null) {
      throw new ArgumentError("Not a valid HEX color definition");
    }
    if (!hex.startsWith("#")) {
      hex = "#" + hex;
    }
    RegExp exp = new RegExp(r"^#([0-9a-f]{3}|[0-9a-f]{6})$", caseSensitive: false);
    if (exp.allMatches(hex).isEmpty) {
      throw new ArgumentError("Not a valid HEX color definition");
    }
    _value = hex;
  }

  String toString() => _value;

  static const Color ALICE_BLUE = const _NamedColor("AliceBlue");
  static const Color ANTIQUE_WHITE = const _NamedColor("AntiqueWhite");
  static const Color AQUA = const _NamedColor("Aqua");
  static const Color AQUAMARINE = const _NamedColor("Aquamarine");
  static const Color AZURE = const _NamedColor("Azure");
  static const Color BEIGE = const _NamedColor("Beige");
  static const Color BISQUE = const _NamedColor("Bisque");
  static const Color BLACK = const _NamedColor("Black");
  static const Color BLANCHED_ALMOND = const _NamedColor("BlanchedAlmond");
  static const Color BLUE = const _NamedColor("Blue");
  static const Color BLUE_VIOLET = const _NamedColor("BlueViolet");
  static const Color BROWN = const _NamedColor("Brown");
  static const Color BURLY_WOOD = const _NamedColor("BurlyWood");
  static const Color CADET_BLUE = const _NamedColor("CadetBlue");
  static const Color CHARTREUSE = const _NamedColor("Chartreuse");
  static const Color CHOCOLATE = const _NamedColor("Chocolate");
  static const Color CORAL = const _NamedColor("Coral");
  static const Color CORNFLOWER_BLUE = const _NamedColor("CornflowerBlue");
  static const Color CORNSILK = const _NamedColor("Cornsilk");
  static const Color CRIMSON = const _NamedColor("Crimson");
  static const Color CYAN = const _NamedColor("Cyan");
  static const Color DARK_BLUE = const _NamedColor("DarkBlue");
  static const Color DARK_CYAN = const _NamedColor("DarkCyan");
  static const Color DARK_GOLDEN_ROD = const _NamedColor("DarkGoldenRod");
  static const Color DARK_GRAY = const _NamedColor("DarkGray");
  static const Color DARK_GREY = const _NamedColor("DarkGrey");
  static const Color DARK_GREEN = const _NamedColor("DarkGreen");
  static const Color DARK_KHAKI = const _NamedColor("DarkKhaki");
  static const Color DARK_MAGENTA = const _NamedColor("DarkMagenta");
  static const Color DARK_OLIVE_GREEN = const _NamedColor("DarkOliveGreen");
  static const Color DARK_ORANGE = const _NamedColor("Darkorange");
  static const Color DARK_ORCHID = const _NamedColor("DarkOrchid");
  static const Color DARK_RED = const _NamedColor("DarkRed");
  static const Color DARK_SALMON = const _NamedColor("DarkSalmon");
  static const Color DARK_SEA_GREEN = const _NamedColor("DarkSeaGreen");
  static const Color DARK_SLATE_BLUE = const _NamedColor("DarkSlateBlue");
  static const Color DARK_SLATE_GRAY = const _NamedColor("DarkSlateGray");
  static const Color DARK_SLATE_GREY = const _NamedColor("DarkSlateGrey");
  static const Color DARK_TURQUOISE = const _NamedColor("DarkTurquoise");
  static const Color DARK_VIOLET = const _NamedColor("DarkViolet");
  static const Color DEEP_PINK = const _NamedColor("DeepPink");
  static const Color DEEP_SKY_BLUE = const _NamedColor("DeepSkyBlue");
  static const Color DIM_GRAY = const _NamedColor("DimGray");
  static const Color DIM_GREY = const _NamedColor("DimGrey");
  static const Color DODGER_BLUE = const _NamedColor("DodgerBlue");
  static const Color FIRE_BRICK = const _NamedColor("FireBrick");
  static const Color FLORAL_WHITE = const _NamedColor("FloralWhite");
  static const Color FOREST_GREEN = const _NamedColor("ForestGreen");
  static const Color FUCHSIA = const _NamedColor("Fuchsia");
  static const Color GAINSBORO = const _NamedColor("Gainsboro");
  static const Color GHOST_WHITE = const _NamedColor("GhostWhite");
  static const Color GOLD = const _NamedColor("Gold");
  static const Color GOLDEN_ROD = const _NamedColor("GoldenRod");
  static const Color GRAY = const _NamedColor("Gray");
  static const Color GREY = const _NamedColor("Grey");
  static const Color GREEN = const _NamedColor("Green");
  static const Color GREEN_YELLOW = const _NamedColor("GreenYellow");
  static const Color HONEY_DEW = const _NamedColor("HoneyDew");
  static const Color HOT_PINK = const _NamedColor("HotPink");
  static const Color INDIAN_RED = const _NamedColor("IndianRed");
  static const Color INDIGO = const _NamedColor("Indigo");
  static const Color IVORY = const _NamedColor("Ivory");
  static const Color KHAKI = const _NamedColor("Khaki");
  static const Color LAVENDER = const _NamedColor("Lavender");
  static const Color LAVENDER_BLUSH = const _NamedColor("LavenderBlush");
  static const Color LAWN_GREEN = const _NamedColor("LawnGreen");
  static const Color LEMON_CHIFFON = const _NamedColor("LemonChiffon");
  static const Color LIGHT_BLUE = const _NamedColor("LightBlue");
  static const Color LIGHT_CORAL = const _NamedColor("LightCoral");
  static const Color LIGHT_CYAN = const _NamedColor("LightCyan");
  static const Color LIGHT_GOLDEN_ROD_YELLOW = const _NamedColor("LightGoldenRodYellow");
  static const Color LIGHT_GRAY = const _NamedColor("LightGray");
  static const Color LIGHT_GREY = const _NamedColor("LightGrey");
  static const Color LIGHT_GREEN = const _NamedColor("LightGreen");
  static const Color LIGHT_PINK = const _NamedColor("LightPink");
  static const Color LIGHT_SALMON = const _NamedColor("LightSalmon");
  static const Color LIGHT_SEA_GREEN = const _NamedColor("LightSeaGreen");
  static const Color LIGHT_SKY_BLUE = const _NamedColor("LightSkyBlue");
  static const Color LIGHT_SLATE_GRAY = const _NamedColor("LightSlateGray");
  static const Color LIGHT_SLATE_GREY = const _NamedColor("LightSlateGrey");
  static const Color LIGHT_STEEL_BLUE = const _NamedColor("LightSteelBlue");
  static const Color LIGHT_YELLOW = const _NamedColor("LightYellow");
  static const Color LIME = const _NamedColor("Lime");
  static const Color LIME_GREEN = const _NamedColor("LimeGreen");
  static const Color LINEN = const _NamedColor("Linen");
  static const Color MAGENTA = const _NamedColor("Magenta");
  static const Color MAROON = const _NamedColor("Maroon");
  static const Color MEDIUM_AQUA_MARINE = const _NamedColor("MediumAquaMarine");
  static const Color MEDIUM_BLUE = const _NamedColor("MediumBlue");
  static const Color MEDIUM_ORCHID = const _NamedColor("MediumOrchid");
  static const Color MEDIUM_PURPLE = const _NamedColor("MediumPurple");
  static const Color MEDIUM_SEA_GREEN = const _NamedColor("MediumSeaGreen");
  static const Color MEDIUM_SLATE_BLUE = const _NamedColor("MediumSlateBlue");
  static const Color MEDIUM_SPRING_GREEN = const _NamedColor("MediumSpringGreen");
  static const Color MEDIUM_TURQUOISE = const _NamedColor("MediumTurquoise");
  static const Color MEDIUM_VIOLET_RED = const _NamedColor("MediumVioletRed");
  static const Color MIDNIGHT_BLUE = const _NamedColor("MidnightBlue");
  static const Color MINT_CREAM = const _NamedColor("MintCream");
  static const Color MISTY_ROSE = const _NamedColor("MistyRose");
  static const Color MOCCASIN = const _NamedColor("Moccasin");
  static const Color NAVAJO_WHITE = const _NamedColor("NavajoWhite");
  static const Color NAVY = const _NamedColor("Navy");
  static const Color OLD_LACE = const _NamedColor("OldLace");
  static const Color OLIVE = const _NamedColor("Olive");
  static const Color OLIVE_DRAB = const _NamedColor("OliveDrab");
  static const Color ORANGE = const _NamedColor("Orange");
  static const Color ORANGE_RED = const _NamedColor("OrangeRed");
  static const Color ORCHID = const _NamedColor("Orchid");
  static const Color PALE_GOLDEN_ROD = const _NamedColor("PaleGoldenRod");
  static const Color PALE_GREEN = const _NamedColor("PaleGreen");
  static const Color PALE_TURQUOISE = const _NamedColor("PaleTurquoise");
  static const Color PALE_VIOLET_RED = const _NamedColor("PaleVioletRed");
  static const Color PAPAYA_WHIP = const _NamedColor("PapayaWhip");
  static const Color PEACH_PUFF = const _NamedColor("PeachPuff");
  static const Color PERU = const _NamedColor("Peru");
  static const Color PINK = const _NamedColor("Pink");
  static const Color PLUM = const _NamedColor("Plum");
  static const Color POWDER_BLUE = const _NamedColor("PowderBlue");
  static const Color PURPLE = const _NamedColor("Purple");
  static const Color RED = const _NamedColor("Red");
  static const Color ROSY_BROWN = const _NamedColor("RosyBrown");
  static const Color ROYAL_BLUE = const _NamedColor("RoyalBlue");
  static const Color SADDLE_BROWN = const _NamedColor("SaddleBrown");
  static const Color SALMON = const _NamedColor("Salmon");
  static const Color SANDY_BROWN = const _NamedColor("SandyBrown");
  static const Color SEA_GREEN = const _NamedColor("SeaGreen");
  static const Color SEA_SHELL = const _NamedColor("SeaShell");
  static const Color SIENNA = const _NamedColor("Sienna");
  static const Color SILVER = const _NamedColor("Silver");
  static const Color SKY_BLUE = const _NamedColor("SkyBlue");
  static const Color SLATE_BLUE = const _NamedColor("SlateBlue");
  static const Color SLATE_GRAY = const _NamedColor("SlateGray");
  static const Color SLATE_GREY = const _NamedColor("SlateGrey");
  static const Color SNOW = const _NamedColor("Snow");
  static const Color SPRING_GREEN = const _NamedColor("SpringGreen");
  static const Color STEEL_BLUE = const _NamedColor("SteelBlue");
  static const Color TAN = const _NamedColor("Tan");
  static const Color TEAL = const _NamedColor("Teal");
  static const Color THISTLE = const _NamedColor("Thistle");
  static const Color TOMATO = const _NamedColor("Tomato");
  static const Color TURQUOISE = const _NamedColor("Turquoise");
  static const Color VIOLET = const _NamedColor("Violet");
  static const Color WHEAT = const _NamedColor("Wheat");
  static const Color WHITE = const _NamedColor("White");
  static const Color WHITE_SMOKE = const _NamedColor("WhiteSmoke");
  static const Color YELLOW = const _NamedColor("Yellow");
  static const Color YELLOW_GREEN = const _NamedColor("YellowGreen");
}

class _NamedColor implements Color {

  final String _value;

  const _NamedColor(String this._value);

  String toString() => _value;

}

