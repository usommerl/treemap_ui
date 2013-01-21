library treemap_utils;

part 'percentage.dart';
part 'orientation.dart';

Collection sortedCopy(Collection original, Comparator compare) {
  final copy = new List.from(original);
  copy.sort(compare);
  return copy;
}