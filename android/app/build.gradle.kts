import java.util.Properties

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

repositories {
    google()
    mavenCentral()
    // Repository for Flutter artifacts
    maven { url = uri("https://storage.googleapis.com/download.flutter.io") }
    // Add Flutter engine artifacts from the local Flutter SDK if available
    val localPropertiesFile = rootProject.file("local.properties")
    if (localPropertiesFile.exists()) {
        val properties = Properties()
        localPropertiesFile.inputStream().use { properties.load(it) }
        val flutterSdk = properties.getProperty("flutter.sdk")
        if (flutterSdk != null) {
            maven {
                url = uri("$flutterSdk/bin/cache/artifacts/engine/android")
            }
        }
    }
}

android {
    namespace = "com.example.diabetes_detection"
    compileSdk = 34
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.diabetes_detection"
        minSdk = 23
        targetSdk = 33
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}