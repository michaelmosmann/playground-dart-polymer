library optionals;


abstract class Optional<T> {
  
  factory Optional([T value]) {
    if (value != null) {
      return new Some<T>(value);
    }
    return new None<T>();
  }
  
  bool get isPresent;
  
  T get();
}

class Some<T> implements Optional<T> {
  T value;
  
  Some(this.value);

  @override
  bool get isPresent {
    return true;
  }

  @override
  T get() {
    return value;
  }
  
  String toString() {
    return "Some("+value.toString()+")";
  }
}

class None<T> implements Optional<T>{
  
  @override
  bool get isPresent {
    return false;
  }
  
  @override
  T get() {
    throw new ArgumentError("value must not be null");
  }
}

