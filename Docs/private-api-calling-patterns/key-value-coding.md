# Key-Value Coding

Use this when you want to get or set an Objective-C property from Swift with Key-Value Coding.

## When to Use It

- You know the property name.
- The target object is Objective-C based and responds to key-value coding.
- You want to read or change a property by name.

## Repo Example

[`UIAlertControllerSampleView.swift`](../../Playgrounds/WorkshopSample/UIAlertController/UIAlertControllerSampleView.swift) uses this pattern:

```swift
let imageViewController = makeImageViewController(image: UIImage(resource: .sampleRiko))
alertController.setValue(imageViewController, forKey: "contentViewController")
```

This lets the alert embed a custom view controller even though `UIAlertController` does not publicly expose that slot.

When you want to read a property instead, the same pattern looks like this:

```swift
if let contentViewController = alertController.value(forKey: "contentViewController") as? UIViewController {
    print(contentViewController)
}
```

## Notes

- `value(forKey:)` reads a property by name.
- `setValue(_:forKey:)` writes a property by name.
- The key is a raw string, so typos usually fail at runtime instead of compile time.
- Start with one key at a time. It is easier to verify a small change first.

## Reference

- Apple: [Key-Value Coding Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueCoding/index.html)

If you still need to discover the key name, go back to the [Start Exploring guide](../start-exploring.md).
