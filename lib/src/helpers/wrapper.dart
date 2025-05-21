//helper class to allow setting null values to a nullable type in the copyWith pattern

class Wrapped<T> {
  final T value;
  const Wrapped.value(this.value);
}
