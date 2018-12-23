# flhooks

React like Hooks implementation for Flutter.

This package is inspired by
[React Hooks](https://reactjs.org/docs/hooks-intro.html).

This is a work in progress, fell free to fork or open issues.

## Getting Started

You should ensure that you add the flhooks
as a dependency in your flutter project.

```yaml
dependencies:
 flhooks: "^0.0.1"
```

You should then run `flutter packages upgrade`
or update your packages in IntelliJ.

## Rules

When using Hooks,
[React Hooks rules](https://reactjs.org/docs/hooks-rules.html)
must be followed.

### Only Call Hooks at the Top Level
__Don’t call Hooks inside loops, conditions, or nested functions.__
Hooks can only be used inside a __HookBuilder__ builder params.
They can also be used to create other hooks.

## Example

### Simple Usage

Hooks can only be used inside the builder of an HookBuilder.

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

### Custom Hooks

Custom Hooks name must start with 'use'.

```dart
class MultipliedState {
  const DoublerState(this.value, this.set);

  final value;
  final set;
}


final useMultiplied = (initial, multiplier) {
  final state = useState(inital);
  final set = useCallback((value) => state.set(value * multiplier),
      [state, multiplier]);
  return MultipliedState(
    value: state.value,
    set: set,
  );
};
```

Now you can use useMultiplied like any other hooks.

## Hooks

Currently implemented Hooks.

### useMemo

`useMemo` take a function, fn, and the values, store,
used in the function as input,
return the value of the call fn(), recall fn() only if store changed.

```dart
final helloMessage = useMemo(() => 'Hello ${name}', [name]);
// the fn passed to useMemo will be recalled only if name change
```

### useCallback
`useCallback` take a function, fn, and the values, store,
used in the function as input,
return the same reference to fn until the store change.
```dart
final onClick = useCallback(() => ..., [input1, input2]);
// return always the same reference to the first fn passed to useCallback
// until input1 or input2 change
// it's like passing an high order function to useMemo
```

### useState

`useState` take the initial value as input and return an HookState
with the current value and the set function.

```dart
final name = useState('');
// ... get the value
Text(name.value);
//... update the value
onChange: (newValue) => name.set(newValue);
```