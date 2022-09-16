# docker-android-fastlane
Docker image for Android + Fastlane

- Java 11
- Android 12 (Android Build Tools Version: "32.0.0")
- Fastlane

To use this image, make sure that you have in you `app/build.gradle`:

```gradle

android {


    defaultConfig {
        buildToolsVersion "32.0.0"
        ...
    }
}
