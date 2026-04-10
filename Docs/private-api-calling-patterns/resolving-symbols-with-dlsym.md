# Resolving Symbols with dlsym

Use this when you want to resolve an exported symbol by name at runtime with `dlsym()`.

## When to Use It

- You know the exported symbol name.
- The symbol is exposed as C code or data, not an Objective-C selector or property.
- You want to look it up at runtime instead of adding a header declaration first.

## Example

```swift
let isUISolariumEnabled: Bool = {
#if canImport(UIKit)
    let RTLD_DEFAULT = UnsafeMutableRawPointer(bitPattern: -2)
    if let symbol = dlsym(RTLD_DEFAULT, "_UISolariumEnabled") {
        typealias Fn = @convention(c) () -> Bool
        return unsafeBitCast(symbol, to: Fn.self)()
    } else {
        return false
    }
#else
    return false
#endif
}()
```

This resolves the symbol address, casts it to the matching C function type, then calls it from Swift.

## Notes

- `dlsym()` returns the address of code or data for the symbol name you pass in.
- Pass the exported symbol name that matches what you want to resolve.
- `dlerror()` gives you the error string when `dlsym()` fails.
- In Swift, you may need to pass a special handle value such as `RTLD_DEFAULT` manually.
- The cast must match the real calling convention and signature exactly.
- Use this for exported C symbols. If you have an Objective-C selector, see [Calling Objective-C Methods by Selector](calling-objective-c-methods-by-selector.md). If you have a property name, see [Key-Value Coding](key-value-coding.md).

## Reference

- Apple: [dlsym(3)](https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man3/dlsym.3.html)
- Apple: [dlopen(3)](https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man3/dlopen.3.html)
