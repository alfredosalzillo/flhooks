## [1.3.0] - 03/07/2019

* added `useContext`
    
    Added the `useContext` hook to use the `BuildContext` inside other hooks
    
* added `HookWidget`
    
    Added the `HookWidget` class to use class Widget with hooks.
  HookWidget is now use as the base for the HookBuilder class.
## [1.1.0] - 05/01/2019

There is a lot of change in this version.
This is not a major release because there are no change in the design
or new functionality, excluding hot reload support (but yes,
something will break updating to the new version).

This is a better implementation how make more clear the goal
to avoid the use of classes and mixin and prefer instead
hook functions and composition.

The change came also from the necessity to make a better division of
responsibility.

* removed `Hook.dispose`.
    
    Logic moved to a new `_DisposableController`,
 how is private, because we don't want developers use class extension or mixin.
 Sorry if someone was using `Hook.dispose` compose using `useEffect` instead.
 
* replaced `HookState` with `StateController`

    It's a better name, and describe better the returned value of `useState`.
    
* deprecated `HookState.set` (now `StateController.set`),
 use `StateController.value = newValue instead`
* `useState` now return `StateController` instead of 'HookState'
* `useMemo` now implements the dispose lifecycle
* `useEffect` --like all the hooks functions-- use `useMemo`
* **added hot reload support**

    When the hock type change, because an hook function is added,
    removed, or change type, 
    the hook will be disposed and reset to null.
    There will be no break hot reloading the app.
    But will be other side effects.
 
    We decide to not make hooks shift to the next position,
    because we prefer to have the same behavior in the case you add,
    remove, or change an hook function call.

* Added Hot Reload test  
* Added Hot Reload and Changelog section to [README](README.md)

We are also thinking to make `use` private.
Everything can be done using `useMemo` now.

## [1.0.1] - 26/12/2018

* flutter packages get error fix

## [1.0.0] - 26/12/2018

* HookBuilder review
* add [example](example) directory
* add example [todo_app](example/todo_app)

## [0.0.2] - 25/12/2018

* added useEffect hook function
* better dartdoc comment
* better readme
* added travis integration
* added test for useEffect
* added test for hooks function scope

## [0.0.1] - 23/12/2018

* Initial Release
