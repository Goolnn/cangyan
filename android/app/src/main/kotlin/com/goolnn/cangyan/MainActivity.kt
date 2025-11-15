package com.goolnn.cangyan

import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    init {
        System.loadLibrary("hub")
    }
}
