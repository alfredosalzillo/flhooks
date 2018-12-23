import 'package:flhooks/flhooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('update Slider value on tap', (WidgetTester tester) async {
    // You can use keys to locate the widget you need to test
    var sliderKey = UniqueKey();

    // Tells the tester to build a UI based on the widget tree passed to it
    await tester.pumpWidget(
      HookBuilder(
        builder: (BuildContext context) {
          final test = useState(0.0);
          final onChanged = useCallback((double newValue) {
            test.set(newValue);
          }, [test]);
          return MaterialApp(
            home: Material(
              child: Center(
                child: Slider(
                  key: sliderKey,
                  value: test.value,
                  onChanged: onChanged,
                ),
              ),
            ),
          );
        },
      ),
    );
    var slider = tester.widget(find.byKey(sliderKey)) as Slider;
    final onChanged = slider.onChanged;
    expect(slider.value, equals(0.0));
    expect(onChanged, isNotNull);

    // Taps on the widget found by key
    await tester.tap(find.byKey(sliderKey));
    await tester.pump();
    slider = tester.widget(find.byKey(sliderKey)) as Slider;

    // Verifies that the widget updated the value correctly
    expect(slider.value, equals(0.5));
    // Verifies that callback is not updated
    expect(slider.onChanged, equals(onChanged));
  });
}