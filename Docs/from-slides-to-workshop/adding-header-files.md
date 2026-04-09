# Adding a Minimal Objective-C Header

Sometimes string-based lookup is enough.

Sometimes it is simpler to expose a private Objective-C type to Swift with a tiny header and keep the rest of the experiment small.

## When to Use It

- You want to instantiate a concrete Objective-C class in Swift.
- You want a named type like `_UIPortalView` instead of pure `NSClassFromString(...)`.
- You only need a very small declaration surface.

## Repo Example

`Playgrounds/WorkshopSample/UIPortalView/_UIPortalView.h` is intentionally minimal:

```objc
#import <UIKit/UIKit.h>

@interface _UIPortalView : UIView

@end
```

The project then imports that header through `Playgrounds-Bridging-Header.h`:

```objc
#import "_UIPortalView.h"
```

After that, Swift can use the type directly:

```swift
let portalView = _UIPortalView()
```

See `Playgrounds/WorkshopSample/UIPortalView/UIPortalExampleView.swift` for the full sample.

## Suggested Workshop Steps

1. Add the smallest possible `@interface`.
2. Import that header in `Playgrounds-Bridging-Header.h`.
3. Instantiate the type from Swift.
4. Configure the instance with a small number of keys or selectors first.

## Why This Sample Is Useful

- The declaration surface stays tiny.
- The Swift side becomes easier to read than a full string-only setup.
- You can still combine it with `setValue(_:forKey:)` for private properties such as `sourceView`.

## Notes

- Keep private headers minimal. Declare only what you need for the current experiment.
- This project already has the bridging header configured, so most workshop changes are just one extra `#import`.
- If you prefer not to add a header yet, `UIPortalExampleView.swift` also includes a commented `NSClassFromString("_UIPortalView")` path.

If you do not know the class or member names yet, start with the [Start Exploring guide](../start-exploring.md).
