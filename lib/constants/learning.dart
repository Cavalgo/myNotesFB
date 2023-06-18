class Tuple<T> {
  final T? _a;
  final T? _b;
  final T? _c;
  get first => _a;
  get second => _b;
  get third => _c;

  Tuple(this._a, this._b, this._c);

  Tuple.fromList(List<T> list)
      : _a = list.asMap().containsKey(0) ? list[0] : null,
        _b = list.asMap().containsKey(1) ? list[1] : null,
        _c = list.asMap().containsKey(2) ? list[2] : null;

  Tuple<num> operator +(Tuple t) {
    if (this is Tuple<num> && t is Tuple<num>) {
      Tuple<num> thisAsTupleNum = this as Tuple<num>;
      return Tuple<num>(
        thisAsTupleNum._a! + t._a!,
        thisAsTupleNum._b! + t._b!,
        thisAsTupleNum._c! + t._c!,
      );
    } else {
      throw Exception(
          'The operation + is only difined between num type tuples');
    }
  }

  Tuple<num> operator -(Tuple t) {
    if (this is Tuple<num> && t is Tuple<num>) {
      Tuple<num> thisTuple = this as Tuple<num>;
      Tuple<num> myNewTuple = Tuple<num>(
        thisTuple._a! - t._a!,
        thisTuple._b! - t._b!,
        thisTuple._c! - t._c!,
      );
      return myNewTuple;
    } else {
      throw Exception(
          'The operation - is only difined between num type tuples');
    }
  }

  @override
  bool operator ==(covariant Tuple t) {
    if (this._a == t._a && this._b == t._b && this._c == t._c) {
      return true;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    const prime = 31;
    var result = 1;
    result = prime * result + _a.hashCode;
    result = prime * result + _b.hashCode;
    result = prime * result + _c.hashCode;
    return result;
  }

  @override
  String toString() {
    return '{${this._a}, ${this._b}, ${this._c}}';
  }
}

void main() {
  int a = 10;
  double b = 20.2;
  var c = a + b;
  myFunc myElemFunct = sum;
  print(myElemFunct(true));
}

typedef myFunc = T Function<T>(T elem);

T sum<T>(T elem) {
  return elem;
}
