# Flutter related
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Firebase
-keep class com.google.firebase.** { *; }

# Easebuzz
-keep class com.easebuzz.** { *; }
-keep class com.easebuzz.payment.kit.** { *; }
-keep class * extends com.easebuzz.payment.kit.PWECouponsActivity

# For Gson (required by your code)
-keep class com.google.gson.** { *; }
-keepattributes Signature
-keepattributes *Annotation*
-keep class * {
    @com.google.gson.annotations.SerializedName <fields>;
}
-keepclassmembers class * {
    public <init>(...);
}

# Avoid removing needed methods
-keepclassmembers class * {
    void *(...);
}
-keepclassmembers class * {
    public *;
}
-ignorewarnings
