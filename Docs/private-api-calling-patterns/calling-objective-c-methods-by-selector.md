# Calling Objective-C Methods by Selector

Use this when you want to create a selector from a string and call an Objective-C method from Swift.

## When to Use It

- You know the selector name.
- You want to try a private selector before adding a header file.
- The target API is still Objective-C based under the hood.

## Repo Example

[`ScrollToTopIfPossibleView.swift`](../../Playgrounds/WorkshopSample/ScrollToTopIfPossibleView/ScrollToTopIfPossibleView.swift) uses this pattern:

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

This sample builds a selector from a string, checks that the target responds to it, then calls the implementation with the matching function signature.

## Notes

- `NSSelectorFromString(_:)` turns a string into a selector.
- `responds(to:)` is the minimum check before sending the message.
- This sample uses `method(for:)` because `_scrollToTopIfPossible:` takes a `Bool` and returns a `Bool`, so the function signature needs to match the real method.
- If the signature is wrong, dynamic calls can crash quickly, so treat the function type as part of the API contract.

If you only have a property name and not a selector, the [Key-Value Coding guide](key-value-coding.md) is usually the easier first step. If you need to resolve an exported C symbol instead, see [Resolving Symbols with dlsym](resolving-symbols-with-dlsym.md).
