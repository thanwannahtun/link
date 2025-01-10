import 'package:flutter_test/flutter_test.dart';
import 'package:link/models/city.dart';

void main() {
  group(City, () {
    final city = City(id: "id", name: "Mandalay");

    test("support city value comparisons", () {
      expect(city, city);
    });

    final copyWithCity = city.copyWith(id: "2", name: "Yangon");

    test(
      "support copyWith comparisons",
      () {
        expect(copyWithCity, copyWithCity);
        expect(copyWithCity, isNot(city));
      },
    );
  });
}
