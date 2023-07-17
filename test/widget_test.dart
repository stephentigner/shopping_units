// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

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
