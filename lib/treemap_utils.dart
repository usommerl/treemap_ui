library treemap_utils;

part 'src/utils/percentage.dart';
part 'src/utils/orientation.dart';

Collection sortedCopy(Collection original, Comparator compare) {
  final copy = new List.from(original);
  copy.sort(compare);
  return copy;
}