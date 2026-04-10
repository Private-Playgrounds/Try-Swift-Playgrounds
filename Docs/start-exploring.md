# Start Exploring

When you start looking for private APIs, begin with runtime inspection so you can see what is actually present on the object in front of you. After that, use declarations and headers to broaden the search.

## Explore with po

- po allows you to check raw data from runtime objects.
- Start here when you already know the target view or object and want to inspect what is visible at runtime.

### Commands

#### [`_ivarDescription`](start-exploring/ivar-description.md)

Check the list of instance variables for a specific object.

```lldb
po [(id)0x105a3a2b0 _ivarDescription]
```

#### [`_shortMethodDescription`](start-exploring/short-method-description.md)

Quickly inspect the available methods on a class or object.

```lldb
po [[NSClassFromString(@"UIViewController") new] _shortMethodDescription]
```

#### [`_methodDescription`](start-exploring/method-description.md)

Inspect method information in more detail.

```lldb
po [[NSClassFromString(@"UIViewController") new] _methodDescription]
```

## Explore with headers.82flex.com

- [headers.82flex.com](https://headers.82flex.com) is a convenient site for browsing iOS framework headers.
- Use it when you want to search by name quickly or get a rough sense of where a type is declared.
