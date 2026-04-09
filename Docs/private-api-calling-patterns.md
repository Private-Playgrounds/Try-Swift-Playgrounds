# Private API Calling Patterns

This page maps the calling patterns from the presentation to small samples in this repository.

## Topics

### [`setValue(_:forKey:)`](private-api-calling-patterns/set-value.md)

Use this when you know the property name as a string and want to set it through Objective-C Key-Value Coding.

- Sample: [`UIAlertControllerSampleView.swift:29`](../Playgrounds/WorkshopSample/UIAlertController/UIAlertControllerSampleView.swift#L29)

### [Dynamic dispatch](private-api-calling-patterns/dynamic-dispatch.md)

Use this when you know a selector name and want to call it dynamically from Swift.

- Sample: [`ScrollToTopIfPossibleView.swift:75`](../Playgrounds/WorkshopSample/ScrollToTopIfPossibleView/ScrollToTopIfPossibleView.swift#L75)

### [Adding a minimal Objective-C header](private-api-calling-patterns/adding-header-files.md)

Use this when you want to expose a private Objective-C type to Swift and refer to it directly by name.

- Sample: [`_UIPortalView.h:9`](../Playgrounds/WorkshopSample/UIPortalView/_UIPortalView.h#L9)

If you need to discover the key, selector, or class name first, see the [Start Exploring guide](start-exploring.md).
