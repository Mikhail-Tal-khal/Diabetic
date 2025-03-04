import java.util.Properties

plugins {
    id("com.android.application") version "8.7.0"
    id("org.jetbrains.kotlin.android") version "1.8.22"
    id("com.google.gms.google-services") version "4.3.15"
    id("dev.flutter.flutter-gradle-plugin")
}

repositories {
    google()
    mavenCentral()
    // Repository for Flutter artifacts
    maven { url = uri("https://storage.googleapis.com/download.flutter.io") }
    // Add Flutter engine artifacts from the local Flutter SDK if available.
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
    compileSdk = 33
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
