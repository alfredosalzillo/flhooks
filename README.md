[![Build Status](https://travis-ci.org/alfredosalzillo/flhooks.svg?branch=master)](https://travis-ci.org/alfredosalzillo/flhooks)
[![Code Coverage](https://codecov.io/gh/alfredosalzillo/flhooks/branch/master/graph/badge.svg)](https://codecov.io/gh/alfredosalzillo/flhooks/)

# flhooks
Write stateful functional Component in Flutter.
React like Hooks implementation for Flutter.

This package is inspired by
[React Hooks](https://reactjs.org/docs/hooks-intro.html).

## Why Hooks

Like for [React](https://reactjs.org/docs/hooks-intro.html#motivation),
Hooks try to be a simple method
to share stateful logic between `Component`.

The goal of thi library is to devoid class extensions and mixin.
Of course flutter is not designed for functional Component and Hooks.

## Getting Started

You should ensure that you add the flhooks
as a dependency in your flutter project.

```yaml
dependencies:
 flhooks: "^1.1.0"
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

`useState` return a `StateController`,
`HookState.value` is the `initial` value passed to `useState`,
or the last set using `state.value = newValue`.

`state.value = newValue` will trigger
the rebuild of the `StatefulBuilder`.

```dart
final name = useState('');
// ... get the value
  Text(name.value);
//... update the value and rebuild the component
  onChange: (newValue) => name.value = newValue;
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
        state.value = result;
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

## Hot Reload

Hot reload is basically supported.

When the hock type change, because an hook function is added,
removed, or change type, 
the hook will be disposed and reset to null.

However after an add or a remove, all hooks after the one how change,
can be disposed or had a reset.

__Pay attention, will be no break hot reloading the app,
but will be other side effects.__

We decide to not make hooks shift to the next position,
because we prefer to have the same behavior in the case you add,
remove, or change an hook function call.

Feel free to open a issue or fork the repository
to suggest a new implementation.

## Example

More example in the [example](example) directory.

## Changelog
Current version is __1.1.0__,
read the [changelog](CHANGELOG.md) for more info.

## Next on flhooks

New hooks will be added in future like `useFuture` (or `useAsync`) and `useStream`,
there will be no need to use `FutureBuilder` and `StreamBuilder` anymore.

We are actually testing some `useIf` conditional implementation of hooks.
