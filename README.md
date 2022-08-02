# Clarity Hub Mobile Application

Mobile app for Clarity Hub written in Flutter (Dart).

## Getting Started

1. [Install Flutter](https://flutter.dev/docs/get-started/install). Make sure to install the Android requirements as well
2. The following two commands should get you started:

```sh
# Create a new iPhone Simulator. Skip this step if you already creatd one or are
# going to use a real device
sh ./scripts/create

# Clean your flutter workspace if you are returning the project after awhile
sh ./scripts/clean

# Run Flutter
sh ./scripts/start
```

Drag you self-signed .cert file into the iOS simulator.

## Architecture

The `/lib` folder is where the majority of the code will go. Other folders hold
shared or specific code for each device type.

## Resources

A few resources to get you started if this is your first Flutter project:

- [Generate Icons](https://appiconmaker.co/)
- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
