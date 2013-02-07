library treemap_utils;

part 'percentage.dart';
part 'orientation.dart';

Collection sortedCopy(Collection original, Comparator compare) {
  final copy = original.toList();
  copy.sort(compare);
  return copy;
}