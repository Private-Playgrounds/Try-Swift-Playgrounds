# Private API Calling Patterns

This page maps the calling patterns from the presentation to small samples in this repository.

## Topics

### [`setValue(_:forKey:)`](private-api-calling-patterns/set-value.md)

Use this when you know the property name as a string and want to set it through Objective-C Key-Value Coding.

- Sample: [`Playgrounds/WorkshopSample/UIAlertController/UIAlertControllerSampleView.swift`](../Playgrounds/WorkshopSample/UIAlertController/UIAlertControllerSampleView.swift)

### [Dynamic dispatch](private-api-calling-patterns/dynamic-dispatch.md)

Use this when you know a selector name and want to call it dynamically from Swift.

- Sample: [`Playgrounds/WorkshopSample/ScrollToTopIfPossibleView/ScrollToTopIfPossibleView.swift`](../Playgrounds/WorkshopSample/ScrollToTopIfPossibleView/ScrollToTopIfPossibleView.swift)

### [Adding a minimal Objective-C header](private-api-calling-patterns/adding-header-files.md)

Use this when you want to expose a private Objective-C type to Swift and refer to it directly by name.

- Sample: [`Playgrounds/WorkshopSample/UIPortalView/_UIPortalView.h`](../Playgrounds/WorkshopSample/UIPortalView/_UIPortalView.h)

If you need to discover the key, selector, or class name first, see the [Start Exploring guide](start-exploring.md).
