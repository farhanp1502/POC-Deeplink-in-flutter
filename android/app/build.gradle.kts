plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

import java.util.Properties
import java.io.FileInputStream

// Load environment variables from .env file
val envFile = File("${project.rootDir}/../.env")
val envProperties = Properties()
if (envFile.exists()) {
    envFile.readLines().forEach { line ->
        val parts = line.split("=", limit = 2)
        if (parts.size == 2) {
            val key = parts[0].trim()
            val value = parts[1].trim().replace("\"", "")
            envProperties.setProperty(key, value)
        }
    }
}

// Get values from .env with defaults
val appName = envProperties.getProperty("APP_NAME")
val appScheme = envProperties.getProperty("APP_SCHEME")
val appHost = envProperties.getProperty("APP_HOST")

android {
    namespace = "com.example.poc_deeplink"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.poc_deeplink"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Add manifest placeholders with values from .env
        manifestPlaceholders["appName"] = appName
        manifestPlaceholders["appScheme"] = appScheme
        manifestPlaceholders["appHost"] = appHost
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