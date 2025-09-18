# Keep Flutter
-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.**

# Keep networking libs (dio, retrofit, okhttp, http)
-keep class okhttp3.** { *; }
-keep class okio.** { *; }
-keep class retrofit2.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn retrofit2.**

# Keep JSON serialization/deserialization
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**

# Ignore Play Core SplitCompat (not used in Flutter projects by default)
-dontwarn com.google.android.play.core.splitcompat.**
-dontnote com.google.android.play.core.splitcompat.**
-keep class com.google.android.play.core.splitcompat.** { *; }
