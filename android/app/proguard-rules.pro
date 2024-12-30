# Keep Retrofit and Gson classes
-keep class retrofit2.** { *; }
-keep class com.google.gson.** { *; }

# Prevent Firebase issues
-keep class com.google.firebase.** { *; }
-keepattributes Signature
