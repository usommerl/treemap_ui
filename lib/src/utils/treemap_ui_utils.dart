library treemap_ui_utils;
import 'dart:async';

part 'percentage.dart';
part 'orientation.dart';
part 'color.dart';
part 'observable_list.dart';

Collection sortedCopy(Collection original, Comparator compare) {
  final copy = original.toList();
  copy.sort(compare);
  return copy;
}