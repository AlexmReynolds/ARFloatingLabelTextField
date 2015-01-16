# ARFloatingLabelTextField
My version of floating labels in textfields user CATextLayer for better animation
ARFloatingLabelTextFields work with autolayout perfectly. It will add the needed space for the label and also handle adding padding to the text.

#Use
The Placeholder color is used when there is no text in the textfield or when there is text but the textfield is not first responder. Default is light grey.

```floatingLabel.placeholderColor = [UIColor redColor];```

To set the placeholder text you can set it in IB or directly

```floatingLabel.placeholder = @"Email:";```

TintColor is used to color the label when the textfield is first responder.

```floatingLabel.tintColor = [UIColor blueColor];```

Insets are used to add insets for the placeholder and text inside the textfield essentially adding padding. Default is no insets

```floatingLabel.insets = UIEdgeInsetsMake(10, 10, 10, 10);```

LabelScale is used to set how small the placeholder becomes when it moves up. Default is 0.6.
```floatingLabel.labelScale = 0.7;```
