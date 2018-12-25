[![Build Status](https://travis-ci.org/alfredosalzillo/flhooks.svg?branch=master)](https://travis-ci.org/alfredosalzillo/flhooks)

# flhooks
Write stateful functional Component in Flutter.
React like Hooks implementation for Flutter.

This package is inspired by
[React Hooks](https://reactjs.org/docs/hooks-intro.html).

## Why Hooks

Like for [React](https://reactjs.org/docs/hooks-intro.html#motivation),
Hooks try to be a simple method
to share stateful logic between `Component`.

## Getting Started

You should ensure that you add the flhooks
as a dependency in your flutter project.

```yaml
dependencies:
 flhooks: "^0.1.0"
```

You should then run `flutter packages upgrade`
or update your packages in IntelliJ.

## Rules

When using Hooks,
[React Hooks rules](https://reactjs.org/docs/hooks-rules.html)
must be followed.

### Only Call Hooks at the Top Level
**Don’t call Hooks inside loops, conditions, or nested functions.**
Hooks can only be used inside a `HookBuilder` builder param.
They can also be used to create other hooks.

## Simple Usage

Hooks can only be used inside the builder of an `HookBuilder`.

`HookBuilder` is like a `StatefulBuilder` how build the `builder` function.
Hooks function can be used only in the `builder` function.

```dart
// Define a Slider Page
final SliderPage = () =>
    HookBuilder(
      builder: (BuildContext context) {
        // define a state of type double
        final example = useState(0.0);
        final onChanged = useCallback((double newValue) {
          // call example.set for update the value in state
          example.set(newValue);
        }, [example]);
        return Material(
          child: Center(
            child: Slider(
              key: sliderKey,
              value: example.value,
              onChanged: onChanged,
            ),
          ),
        );
      },
    );
// Start the app
void main() =>
    runApp(MaterialApp(
      home: SliderPage(),
    ));
```

## Hooks

Currently implemented Hooks.

### useMemo
`useMemo` return the memoized result of the call to `fn`.

`fn` will be recalled only if `store` change.

```dart
 final helloMessage = useMemo(() => 'Hello ${name}', [name]);
```

### useCallback
`useCallback` return the first reference to `fn`.

`fn` reference will change only if `store` change.
```dart
final onClick = useCallback(() => showAwesomeMessage(input1, input2),
  [input1, input2]);
```
It's the same as passing `() => fn` to `useMemo`.

### useState

`useState` return an `HookState`,
`HookState.value` is `initial` value passed to `useState`,
or the last passed to `HookState.set`.

Will trigger the rebuild of the `StatefulBuilder`.

```dart
final name = useState('');
// ... get the value
  Text(name.value);
//... update the value
  onChange: (newValue) => name.set(newValue);
```

### useEffect

`useEffect` exec `fn` at first call or if `store` change.
If `fn` return a function, this will be called if `store` change
or when the widget dispose.

```dart
useEffect(() {
  final pub = stream.listen(callback);
  return () => pub.cancel();
  }, [stream]);
```
 
`useEffect` is useful for handle async or stream subscription.

### Custom Hooks

Custom Hooks function can be created composing other hooks function.

Custom Hooks name must start with 'use'.

```dart
V useAsync<V>(Future<V> Function() asyncFn, V initial, List store) {
  final state = useState(initial);
  useEffect(() {
    var active = true;
    asyncFn().then((result) {
      if (active) {
        state.set(result);
      }
    });
    return () {
      active = false;
    };
  }, store);
  return state.value;
}
```

Now you can use `useAsync` like any other hooks function.

## Example

More example in the [example](example) directory.