import 'package:flutter_test/flutter_test.dart';
import 'package:plantum/main.dart';

void main() {
  testWidgets('Plantum app loads and displays home dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const PlantumApp());
    await tester.pumpAndSettle();

    // Verify brand title is displayed
    expect(find.text('Plantum'), findsOneWidget);

    // Verify sensor titles
    expect(find.text('Temperature'), findsOneWidget);
    expect(find.text('Humidity'), findsOneWidget);
  });
}
