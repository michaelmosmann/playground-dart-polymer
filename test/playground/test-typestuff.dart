import 'package:unittest/unittest.dart';

class Foo {
  
}

void main() {
  test('some type test', () {
    Foo instance=new Foo();
    
    expect(instance is Foo, isTrue);
    
    Type fooType = instance.runtimeType;
    
    Foo second=new Foo();
    
    expect(second.runtimeType==fooType,isTrue);
    
    
  });
}