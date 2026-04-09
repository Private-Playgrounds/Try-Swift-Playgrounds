# Set Values by Key

This is the quickest bridge from the slide deck into working code in this repository.

## When to Use It

- You already know the property name as a string.
- The target object is Objective-C based and responds well to key-value coding.
- You want the smallest possible experiment first.

## Repo Example

`Playgrounds/WorkshopSample/UIAlertController/UIAlertControllerSampleView.swift` uses the same pattern shown in the slides:

```swift
let imageViewController = makeImageViewController(image: UIImage(resource: .sampleRiko))
alertController.setValue(imageViewController, forKey: "contentViewController")
```

This lets the alert embed a custom view controller even though `UIAlertController` does not publicly expose that slot.

## Why This Sample Is Good for the Workshop

- It matches the slide topic almost exactly.
- The result is visible immediately.
- You can swap the embedded content without changing the rest of the presentation flow.

## Suggested Workshop Steps

1. Run the `Custom UIAlertController` sample from the list.
2. Change the embedded view controller or its preferred size.
3. Once that works, inspect `UIPortalExampleView.swift` to see the same pattern used multiple times.

## Notes

- `setValue(_:forKey:)` accesses a property indirectly by name.
- The key is a raw string, so typos usually fail at runtime instead of compile time.
- Keep the first experiment small. It is easier to verify one key than a whole chain of private behavior.

If you still need to discover the key name, go back to the [Start Exploring guide](../start-exploring.md).
