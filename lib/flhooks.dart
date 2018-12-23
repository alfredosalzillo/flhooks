library flhooks;

import 'package:flutter/widgets.dart';

typedef HookTransformer<V, S> = Hook<V, S> Function(Hook<V, S>);


class Hook<V, S> {
  const Hook({
    @required this.value,
    this.store,
  }) : assert(value != null);

  final V value;
  final S store;
}

StateSetter currentSetState;
List<Hook> currentHooks = [];
int currentIndex = 0;

V use<V, S>(HookTransformer<V, S> transformer) {
  if (currentHooks.length <= currentIndex) {
    currentHooks.length = currentIndex + 1;
  }
  final currentHook = currentHooks[currentIndex];
  final hook = transformer(currentHook);
  assert(hook != null);
  currentHooks[currentIndex] = hook;
  currentIndex += 1;
  return hook.value;
}

V useMemo<V>(V Function() fn, List store) {
  return use<V, List>((current) {
    if (current != null) {
      final oldStore = current.store;
      if (store.every((e) => oldStore.any((o) => o == e))) {
        return current;
      }
    }
    return Hook(
      value: fn(),
      store: store,
    );
  });
}

final useCallback = (Function fn, List store) => useMemo(() => fn, store);

class HookState<V> {
  HookState({
    @required this.value,
    this.set,
  });

  V value;
  void Function(V) set;
}

HookState<V> useState<V>(V initial) {
  final setState = currentSetState;
  return useMemo(() {
    final state = HookState<V>(
        value: initial,
    );
    state.set = (value) => setState(() => state.value = value);
    return state;
  }, []);
}

typedef HookWidgetBuilder = Widget Function(BuildContext);

class HookBuilder extends StatelessWidget {
  HookBuilder({Key key, @required this.builder})
      : assert(builder != null),
        this.hooks = [],
        super(key: key);

  final HookWidgetBuilder builder;
  final List<Hook> hooks;

  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        currentSetState = setState;
        currentHooks = hooks;
        currentIndex = 0;
        return builder(context);
      },
    );
  }
}
