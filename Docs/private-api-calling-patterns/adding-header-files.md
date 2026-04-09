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

## Step-by-Step

In this project, `Playgrounds-Bridging-Header.h` is already configured in the build settings.

That means the workshop flow is just:

1. add a tiny Objective-C header,
2. import it into the bridging header,
3. use the type from Swift.

### 1. Add a minimal header file

Create a header such as `Playgrounds/WorkshopSample/UIPortalView/_UIPortalView.h` and declare only the type you need.

![Minimal `_UIPortalView.h` example](../images/bridging_header_description_1.webp)

### 2. Import it in `Playgrounds-Bridging-Header.h`

Once the header exists, add one `#import` line to `Playgrounds-Bridging-Header.h`.

```objc
#import "_UIPortalView.h"
```

![Import the header in `Playgrounds-Bridging-Header.h`](../images/bridging_header_description_2.webp)

### 3. Use the type directly from Swift

After the import, Swift can refer to the Objective-C type by name.

```swift
let portalView = _UIPortalView()
```

You can then continue with `setValue(_:forKey:)` or selector-based calls as needed.

![Use `_UIPortalView` directly from Swift](../images/bridging_header_description_3.webp)

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
