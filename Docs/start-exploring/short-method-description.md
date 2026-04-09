# `_shortMethodDescription`

Use `_shortMethodDescription` to quickly inspect the available methods.

```lldb
po [[NSClassFromString(@"UIViewController") new] _shortMethodDescription]
```

The following screenshots show the basic flow in Xcode's debugger.

![Open the project in Xcode](../images/po_shortMethodDescription_1.webp)

![Run a `po` command in the debugger console](../images/po_shortMethodDescription_2.webp)

![Inspect the output and search for interesting names](../images/po_shortMethodDescription_3.webp)
