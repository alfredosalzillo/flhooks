import 'package:flhooks/flhooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestHookWidget extends HookWidget {
  @override
  Widget builder(BuildContext context) {
    return Container();
  }
}

void main() {
  test('hooks function cannot be called outside HookBuilder', () async {
    expect(() {
      useEffect(() => null, []);
    }, throwsAssertionError);
  });
  testWidgets('useContext return the actual BuildContext',
          (WidgetTester tester) async {
        // You can use keys to locate the widget you need to test
        var sliderKey = UniqueKey();
        BuildContext _context = null;
        BuildContext _contextFromHook = null;
        // Tells the tester to build a UI based on the widget tree passed to it
        await tester.pumpWidget(
          HookBuilder(
            builder: (BuildContext context) {
              _context = context;
              _contextFromHook = useContext();
              return MaterialApp(
                home: Material(
                  child: Center(
                    child: Slider(
                      key: sliderKey,
                      value: 0,
                      onChanged: (newValue) => null,
                    ),
                  ),
                ),
              );
            },
          ),
        );
        expect(_context, _contextFromHook);
      });
  testWidgets(
      'useState change the state and useCallback memoize the function reference',
      (WidgetTester tester) async {
    // You can use keys to locate the widget you need to test
    var sliderKey = UniqueKey();

    // Tells the tester to build a UI based on the widget tree passed to it
    await tester.pumpWidget(
      HookBuilder(
        builder: (BuildContext context) {
          final test = useState(0.0);
          final onChanged = useCallback((double newValue) {
            test.value = newValue;
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
  testWidgets('useEffect initialize value on the first call',
      (WidgetTester tester) async {
    // You can use keys to locate the widget you need to test
    var sliderKey = UniqueKey();
    var value = 0.0;
    // Tells the tester to build a UI based on the widget tree passed to it
    await tester.pumpWidget(
      HookBuilder(
        builder: (BuildContext context) {
          useEffect(() {
            value = 1;
          }, []);
          return MaterialApp(
            home: Material(
              child: Center(
                child: Slider(
                  key: sliderKey,
                  value: value,
                  onChanged: (newValue) => null,
                ),
              ),
            ),
          );
        },
      ),
    );
    expect(value, equals(1));
  });
  testWidgets('hot reload doesn\'t break',
          (WidgetTester tester) async {
        // You can use keys to locate the widget you need to test
        var sliderKey = UniqueKey();
        var value = 0.0;
        // Tells the tester to build a UI based on the widget tree passed to it
        await tester.pumpWidget(
          HookBuilder(
            builder: (BuildContext context) {
              useEffect(() {
                value = 1;
              }, []);
              return MaterialApp(
                home: Material(
                  child: Center(
                    child: Slider(
                      key: sliderKey,
                      value: value,
                      onChanged: (newValue) => null,
                    ),
                  ),
                ),
              );
            },
          ),
        );
        await tester.pumpWidget(
          HookBuilder(
            builder: (BuildContext context) {
              final test = useState(1.0);
              useEffect(() {
                value = 1;
              }, []);
              return MaterialApp(
                home: Material(
                  child: Center(
                    child: Slider(
                      key: sliderKey,
                      value: value,
                      onChanged: (newValue) => test.value = newValue,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      });
  testWidgets('HookWidget build withour error', (tester) async {
    tester.pumpWidget(_TestHookWidget());
  });
}
