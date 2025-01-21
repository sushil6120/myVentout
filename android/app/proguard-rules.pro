# Retain necessary ZEGOCLOUD classes
-keep class im.zego.** { *; }
-keepclassmembers class im.zego.** { *; }
-dontwarn im.zego.**

# Retain essential Flutter classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.**

# Keep Firebase classes if used
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# General Android rules
-keepattributes Exceptions, InnerClasses, Signature, Deprecated, SourceFile, LineNumberTable
