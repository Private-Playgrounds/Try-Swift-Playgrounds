# Dynamic Dispatch

The slides introduce `perform(_:with:)`.

In this repository, the `ScrollToTopIfPossibleView` sample shows the next step down: build a selector from a string, confirm the target responds to it, then call the implementation directly.

## When to Use It

- You know the selector name but do not have a Swift declaration.
- You want to try a private selector before adding a header file.
- The API is still Objective-C based under the hood.

## Repo Example

`Playgrounds/WorkshopSample/ScrollToTopIfPossibleView/ScrollToTopIfPossibleView.swift` uses this pattern:

```swift
let selector = NSSelectorFromString("_scrollToTopIfPossible:")
guard responds(to: selector) else {
    return false
}

let implementation = method(for: selector)
let function = unsafeBitCast(
    implementation,
    to: (@convention(c) (AnyObject, Selector, Bool) -> Bool).self
)
return function(self, selector, animated)
```

## Why This Differs from the Slide Snippet

- `perform(_:with:)` works well for simple object-based calls.
- This selector takes a `Bool` and returns a `Bool`, so the sample uses `method(for:)` to match the real calling convention.

That makes it a good workshop example for “the slide idea, but in a slightly more real shape.”

## Suggested Workshop Steps

1. Run `ScrollToTopIfPossibleView`.
2. Compare the `Normal` button with the `Private` button.
3. Change only one selector at a time.
4. Keep the function signature aligned with the actual method you are calling.

## Notes

- `NSSelectorFromString(_:)` turns a string into a selector.
- `responds(to:)` is the minimum check before sending the message.
- If the signature is wrong, dynamic calls can crash quickly, so treat the function type as part of the API contract.

If you only have a property name and not a selector, the [`setValue(_:forKey:)` guide](set-value.md) is usually the easier first step.
