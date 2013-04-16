part of treemap_ui.utils;

class ObservableList<E> implements List<E> {

  Stream<E> _onAdd;
  Stream<E> _onRemove;
  Stream<E> _onUpdate;
  final StreamController<E> _onAddController = new StreamController<E>();
  final StreamController<E> _onRemoveController = new StreamController<E>();
  final StreamController<ListUpdateEvent<E>> _onUpdateController = new StreamController<ListUpdateEvent<E>>();
  final List<E> _list;

  ObservableList._internal(List<E> this._list) {
    _onAdd = _onAddController.stream.asBroadcastStream();
    _onRemove = _onRemoveController.stream.asBroadcastStream();
    _onUpdate = _onUpdateController.stream.asBroadcastStream();
  }

  factory ObservableList.from(Iterable other) =>
    new ObservableList._internal(new List<E>.from(other));

  Stream<E> get onAdd => _onAdd;

  Stream<E> get onRemove => _onRemove;
  
  Stream<ListUpdateEvent<E>> get onUpdate => _onUpdate;

  void add(E value) {
    _list.add(value);
    _onAddController.add(value);
  }
  
  void addAll(Iterable<E> iterable) => iterable.forEach((value) => add(value));

  void sort([int compare(E a, E b)]) => _list.sort(compare);

  int indexOf(E element, [int start = 0]) => _list.indexOf(element, start);

  int lastIndexOf(E element, [int start]) => _list.lastIndexOf(element, start);

  E removeAt(int index) {
    final value = _list.removeAt(index);
    _onRemoveController.add(value);
    return value;
  }

  E removeLast() {
    final value = _list.removeLast();
    _onRemoveController.add(value);
    return value;
  }

  List<E> sublist(int start, [int length]) => new ObservableList<E>.from(_list.sublist(start, length));
  
  Iterable<E> getRange(int start, int end) => _list.getRange(start,end);  
  
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    final oldValues = getRange(start, end).toList(growable: false);
    final newValues = iterable.skip(skipCount).toList(growable: false);
    _list.setRange(start, end, iterable, skipCount);
    for (var i = 0; i < oldValues.length; i++) {
      _onUpdateController.add(new ListUpdateEvent(oldValues[i], newValues[i]));
    }
  }
  
  void removeRange(int start, int length) {
    final elements = sublist(start,length);
    _list.removeRange(start, length);
    elements.forEach((e) => _onRemoveController.add(e));
  }
  
  void insert(int index, E element) {
    _list.insert(index, element);
    _onAddController.add(element);
  }
  
  void insertRange(int start, int length, [E fill]) => throw new UnsupportedError("");

  E operator [](int index) => _list[index];
  
  void operator []=(int index, E value) {
    final oldValue = this[index];
    _list[index] = value;
    _onUpdateController.add(new ListUpdateEvent(oldValue, value));
  }

  bool remove(Object value) {
    bool result = _list.remove(value);
    if (result) {
      _onRemoveController.add(value);
    }
    return result;
  }
  
  void removeAll(Iterable elements) => elements.forEach((e) => remove(e));
  
    
  void retainAll(Iterable elements) {
    final others = _list.where((e) => !elements.contains(e)).toList();
    removeAll(others);
  }

  void removeWhere(bool test(E element)) {
    _list.forEach((e) {
      if (test(e)) {
        remove(e);
      }    
    });
  }

  void retainWhere(bool test(E element)) {
    _list.forEach((e) {
      if (!test(e)) {
        remove(e);
      }    
    });
  }
  
  void clear() {
    while (!_list.isEmpty) {
      removeAt(0);
    }
  }
  
  Map<int, E> asMap() => _list.asMap();

  Iterator<E> get iterator => _list.iterator;

  bool get isEmpty => _list.isEmpty;

  int get length => _list.length;
  
  void set length(int newLength) => throw new UnsupportedError("");

  E get first => _list.first;

  E get last => _list.last;

  E get single => _list.single;

  Iterable<E> get reversed => new ObservableList<E>.from(_list.reversed);
  
  Iterable<dynamic> map(f(E element)) => new ObservableList.from(_list.map(f));

  Iterable<E> where(bool f(E element)) => new ObservableList<E>.from(_list.where(f));

  bool contains(E element) => _list.contains(element);

  E reduce(E combine(E value, E element)) => _list.reduce(combine);
  
  dynamic fold(var initialValue, dynamic combine(var previousValue, E element)) 
    => _list.fold(initialValue, combine);

  bool every(bool f(E element)) => _list.every(f);

  String join([String separator = ""]) => _list.join(separator);

  bool any(bool f(E element)) => _list.any(f);

  List<E> toList({ bool growable: true }) => _list.toList(growable: growable);

  Set<E> toSet() => _list.toSet();

  Iterable<E> take(int n) => new ObservableList<E>.from(_list.take(n));

  Iterable<E> takeWhile(bool test(E value)) => new ObservableList<E>.from(_list.takeWhile(test));

  Iterable<E> skip(int n) => new ObservableList<E>.from(_list.skip(n));

  Iterable<E> skipWhile(bool test(E value)) => new ObservableList<E>.from(_list.skipWhile(test));

  Iterable expand(Iterable f(E element)) => new ObservableList.from(_list.expand(f));

  void forEach(void f(E element)) => _list.forEach(f);

  E firstWhere(bool test(E value), { E orElse() }) => _list.firstWhere(test, orElse : orElse);

  E lastWhere(bool test(E value), { E orElse() }) => _list.lastWhere(test, orElse : orElse);

  E singleWhere(bool test(E value)) => _list.singleWhere(test);

  E elementAt(int index) => _list.elementAt(index);  

}

class ListUpdateEvent<E> {
  
  final E oldValue;
  final E newValue;
  
  ListUpdateEvent(E this.oldValue, E this.newValue);
}

