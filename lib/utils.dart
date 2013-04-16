library treemap_ui.utils;
import 'dart:async';

part 'src/utils/percentage.dart';
part 'src/utils/orientation.dart';
part 'src/utils/color.dart';
part 'src/utils/observable_list.dart';

Iterable sortedCopy(Iterable original, Comparator compare) {
  final copy = original.toList();
  copy.sort(compare);
  return copy;
}