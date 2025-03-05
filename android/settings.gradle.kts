pluginManagement {
    repositories {
        gradlePluginPortal()
        google()
        mavenCentral()
    }
    plugins {
        id("com.android.application") version "8.1.0"
        id("org.jetbrains.kotlin.android") version "1.9.0"
        id("com.google.gms.google-services") version "4.4.0"
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.PREFER_SETTINGS)
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "android"
include(":app")

// Fix for file access and properties loading
val localProperties = java.io.File(settingsDir, "local.properties")
val properties = java.util.Properties()
if (localProperties.exists()) {
    java.io.FileInputStream(localProperties).use { stream ->
        properties.load(stream)
    }
}

// Read the Flutter SDK path from local.properties
val flutterSdkPath = file("local.properties").inputStream().use { propsStream ->
    java.util.Properties().apply { load(propsStream) }
        .getProperty("flutter.sdk") ?: error("flutter.sdk not set in local.properties")
}

// Include Flutter's Gradle build
includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

plugins {
    id("com.android.application") version "7.2.0" apply false
    id("com.android.library") version "7.2.0" apply false
    id("org.jetbrains.kotlin.android") version "1.7.10" apply false
    id("com.google.gms.google-services") version "4.3.10" apply false
}

include(":app")
