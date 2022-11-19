# flutter_form_stepper_bug

### Problem
When working with a lengthy `Form` widget inside a `Stepper` widget with multiple `Step`s, only form fields visible are recognized. That leads to wrongfully ignoring methods called on those form fields.<br>
This is especially problematic if, for example, you fill out a field in step 1, go to the last step, fill something out there and call `.save()`. If many steps are present, the value filled out in the top field will not be saved.

### The Reason
The Material `Stepper` widget internally uses a `ListView` to show its `Step`s. `ListView` (in contrast to `SingleChildScrollView`) uses lazy loading for its items, which means that `Step`s currently not visible in the `Stepper` are ignored. In case of having `FormField`s inside the `Step`s, their methods (like `.save()`) are not called. 

### Minimal Reproducible Example
I created this repository to show the bug in a minimal reproducible way. <br>
In _form_stepper.dart_, a `Stepper` with 10 `Step`s and 10 `TextFormField`s per Step is created. <br>
The `_savedFieldsPerStep` map is used to showcase the problem: The `.save()` method of each `TextFormField` should increment the value for its step number as key. This means, when saving the form, each key of the map should have 10 as value. <br>
However, what you will witness is that saving at the top will leave the bottom steps at 0 saved fields and vice versa.

### Proposed Solution
A way to prevent the faulty lazy-loading mechanism of the `Stepper` would be to use `SingleChildScrollView` instead of `ListView` internally. <br>
However, this would lead to problems with performance, especially for usages of the `Stepper` where lazy loading is actually desired. <br>
Therefore, I propose to add a `bool` parameter to the `Stepper` widget, which allows to disable lazy loading and switch the internal `ListView` to a `SingleChildScrollView` with a `Column` as its child.