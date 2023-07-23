/*
Copyright (C) 2023 Stephen Tigner

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_units/enums/unit_type.dart';

import 'package:shopping_units/main.dart';
import 'package:shopping_units/utils/application_strings.dart';

void main() {
  testWidgets('Unit price displays properly once valid values are entered',
      (widgetTester) async {
    //Build the app and trigger a frame to make sure the app is ready for input
    await widgetTester.pumpWidget(const ShoppingUnits());

    //Verify that our computed unit price does not display with no values entered
    expect(find.textContaining("/${UnitType.defaultSolidUnit.abbreviation}"),
        findsNothing);

    //Enter values for the first item, then trigger a frame
    const testPrice = 5;
    const testUnitsAmount = 2;
    await widgetTester.enterText(
        find
            .bySemanticsLabel(RegExp(ApplicationStrings.packagePriceLabel))
            .first,
        "$testPrice");
    await widgetTester.enterText(
        find
            .bySemanticsLabel(
                RegExp(ApplicationStrings.packageUnitsAmountLabel))
            .first,
        "$testUnitsAmount");
    await widgetTester.pump();

    //Verify that our computed price displays now
    expect(find.textContaining("/${UnitType.defaultSolidUnit.abbreviation}"),
        findsOneWidget);
  });
}
