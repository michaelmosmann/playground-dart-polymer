import 'package:unittest/unittest.dart';
import '../../web/editor/optionals.dart';

void main() {
  group("optionals", () {
    test("optional of null should fail if get is called", () {
      expect(new Optional().get, throwsA(new isInstanceOf<ArgumentError>()));
    });
    test("optional of some should get some ", () {
      expect(new Optional("some").get(), "some");
    });
    test("optional of some is of Type Some", () {
      expect(new Optional("some"), new isInstanceOf<Some>());
    });
    test("optional of non is of Type None", () {
      expect(new Optional(), new isInstanceOf<None>());
      expect(new Optional(null), new isInstanceOf<None>());
    });
  });
}
