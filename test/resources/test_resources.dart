library treemap_test_resources;
import 'package:treemap_ui/treemap_ui.dart';
export 'package:treemap_ui/treemap_ui.dart';
import 'dart:html';

part 'custom_leaf.dart';
part 'custom_branch.dart';
part 'custom_model.dart';
part 'custom_leaf_decorator.dart';


class TestResources {

  static final CustomLeaf dataModel0 = new CustomLeaf(10);
  static final CustomBranch dataModel1 = new CustomBranch();
  static final CustomBranch dataModel2 = new CustomBranch([new CustomLeaf(10), new CustomLeaf(50), new CustomLeaf(0)]);
  static final CustomBranch dataModel3 = new CustomBranch([dataModel0.copy(), new CustomLeaf(20), new CustomLeaf(100)]);
  static final CustomBranch dataModel4 = new CustomBranch([dataModel3.copy(), new CustomLeaf(70)]);
  static final CustomBranch dataModel5 = new CustomBranch([new CustomLeaf(10), new CustomLeaf(10),
                                     new CustomLeaf(10), new CustomLeaf(369),
                                     new CustomLeaf(804), new CustomLeaf(10),
                                     new CustomLeaf(634), new CustomLeaf(120),
                                     new CustomLeaf(731), new CustomLeaf(384),
                                     new CustomLeaf(450), new CustomLeaf(10),
                                     new CustomLeaf(10), new CustomLeaf(10)]);

  static final CustomBranch dataModel6 = new CustomBranch([new CustomLeaf(1000),new CustomLeaf(2000), new CustomBranch([new CustomLeaf(2), new CustomLeaf(5), new CustomBranch([new CustomLeaf(3)])])]);
  static final CustomBranch dataModel7 = new CustomBranch([dataModel0.copy(), dataModel4.copy()]);

  static final List<DataModel> testDataModels = [dataModel0,dataModel1,dataModel2,dataModel3, dataModel4, dataModel5, dataModel6, dataModel7];

  static final List<LayoutAlgorithm> layoutAlgorithms = [new SliceAndDice(), new Strip(), new Squarified(), new Split(), new Pivot()];

  static final List<Color> namedColors = [Color.ALICE_BLUE, Color.ANTIQUE_WHITE, Color.AQUA, Color.AQUAMARINE, Color.AZURE,
                                          Color.BEIGE, Color.BISQUE, Color.BLACK, Color.BLANCHED_ALMOND, Color.BLUE,
                                          Color.BLUE_VIOLET, Color.BROWN, Color.BURLY_WOOD, Color.CADET_BLUE, Color.CHARTREUSE,
                                          Color.CHOCOLATE, Color.CORAL, Color.CORNFLOWER_BLUE, Color.CORNSILK, Color.CRIMSON,
                                          Color.CYAN, Color.DARK_BLUE, Color.DARK_CYAN, Color.DARK_GOLDEN_ROD, Color.DARK_GRAY,
                                          Color.DARK_GREY, Color.DARK_GREEN, Color.DARK_KHAKI, Color.DARK_MAGENTA, Color.DARK_OLIVE_GREEN,
                                          Color.DARK_ORANGE, Color.DARK_ORCHID, Color.DARK_RED, Color.DARK_SALMON, Color.DARK_SEA_GREEN,
                                          Color.DARK_SLATE_BLUE, Color.DARK_SLATE_GRAY, Color.DARK_SLATE_GREY, Color.DARK_TURQUOISE, Color.DARK_VIOLET,
                                          Color.DEEP_PINK, Color.DEEP_SKY_BLUE, Color.DIM_GRAY, Color.DIM_GREY, Color.DODGER_BLUE,
                                          Color.FIRE_BRICK, Color.FLORAL_WHITE, Color.FOREST_GREEN, Color.FUCHSIA, Color.GAINSBORO,
                                          Color.GHOST_WHITE, Color.GOLD, Color.GOLDEN_ROD, Color.GRAY, Color.GREY,
                                          Color.GREEN, Color.GREEN_YELLOW, Color.HONEY_DEW, Color.HOT_PINK, Color.INDIAN_RED,
                                          Color.INDIGO, Color.IVORY, Color.KHAKI, Color.LAVENDER, Color.LAVENDER_BLUSH,
                                          Color.LAWN_GREEN, Color.LEMON_CHIFFON, Color.LIGHT_BLUE, Color.LIGHT_CORAL, Color.LIGHT_CYAN,
                                          Color.LIGHT_GOLDEN_ROD_YELLOW, Color.LIGHT_GRAY, Color.LIGHT_GREY, Color.LIGHT_GREEN, Color.LIGHT_PINK,
                                          Color.LIGHT_SALMON, Color.LIGHT_SEA_GREEN, Color.LIGHT_SKY_BLUE, Color.LIGHT_SLATE_GRAY, Color.LIGHT_SLATE_GREY,
                                          Color.LIGHT_STEEL_BLUE, Color.LIGHT_YELLOW, Color.LIME, Color.LIME_GREEN, Color.LINEN,
                                          Color.MAGENTA, Color.MAROON, Color.MEDIUM_AQUA_MARINE, Color.MEDIUM_BLUE, Color.MEDIUM_ORCHID,
                                          Color.MEDIUM_PURPLE, Color.MEDIUM_SEA_GREEN, Color.MEDIUM_SLATE_BLUE, Color.MEDIUM_SPRING_GREEN, Color.MEDIUM_TURQUOISE,
                                          Color.MEDIUM_VIOLET_RED, Color.MIDNIGHT_BLUE, Color.MINT_CREAM, Color.MISTY_ROSE, Color.MOCCASIN,
                                          Color.NAVAJO_WHITE, Color.NAVY, Color.OLD_LACE, Color.OLIVE, Color.OLIVE_DRAB,
                                          Color.ORANGE, Color.ORANGE_RED, Color.ORCHID, Color.PALE_GOLDEN_ROD, Color.PALE_GREEN,
                                          Color.PALE_TURQUOISE, Color.PALE_VIOLET_RED, Color.PAPAYA_WHIP, Color.PEACH_PUFF, Color.PERU,
                                          Color.PINK, Color.PLUM, Color.POWDER_BLUE, Color.PURPLE, Color.RED,
                                          Color.ROSY_BROWN, Color.ROYAL_BLUE, Color.SADDLE_BROWN, Color.SALMON, Color.SANDY_BROWN,
                                          Color.SEA_GREEN, Color.SEA_SHELL, Color.SIENNA, Color.SILVER, Color.SKY_BLUE,
                                          Color.SLATE_BLUE, Color.SLATE_GRAY, Color.SLATE_GREY, Color.SNOW, Color.SPRING_GREEN,
                                          Color.STEEL_BLUE, Color.TAN, Color.TEAL, Color.THISTLE, Color.TOMATO,
                                          Color.TURQUOISE, Color.VIOLET, Color.WHEAT, Color.WHITE, Color.WHITE_SMOKE,
                                          Color.YELLOW, Color.YELLOW_GREEN];

  static final validBorderStyles = ["none","hidden","dotted","dashed","solid","double",
                                    "groove", "ridge", "inset", "outset", "inherit"];
}
