import 'package:flutter_test/flutter_test.dart';

import 'package:myapp/main.dart';

void main() {
  testWidgets('Plant Disease App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PlantDiseaseApp());

    // Verify that our app title is displayed
    expect(find.text('تشخیص بیماری گیاهان'), findsOneWidget);
    
    // Verify camera and gallery buttons exist
    expect(find.text('دوربین'), findsOneWidget);
    expect(find.text('گالری'), findsOneWidget);
  });
}