-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.vision.** { *; }

# ML Kit Text Recognition
-keep class com.google.mlkit.vision.text.** { *; }
-keep class com.google.android.gms.vision.text.** { *; }
-keep class com.google.mlkit.vision.text.chinese.** { *; }
-keep class com.google.mlkit.vision.text.devanagari.** { *; }
-keep class com.google.mlkit.vision.text.japanese.** { *; }
-keep class com.google.mlkit.vision.text.korean.** { *; }

# Common ML Kit rules
-keepclassmembers class * implements android.os.Parcelable {
    static ** CREATOR;
}

-keep class com.google.android.gms.vision.** { *; } 