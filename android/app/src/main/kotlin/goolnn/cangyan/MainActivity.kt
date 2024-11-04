package goolnn.cangyan

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.provider.OpenableColumns
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.io.InputStream

class MainActivity : FlutterActivity() {
    private val channel = "goolnn.cangyan/intent"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)

        copyIntent(intent)
    }

    private fun copyIntent(intent: Intent?) {
        if (intent.action != Intent.ACTION_VIEW) {
            return
        }

        val uri: Uri? = intent.data

        uri?.let { it ->
            var fileName: String? = null

            val cursor = contentResolver.query(uri, null, null, null, null)

            cursor?.use {
                if (it.moveToFirst()) {
                    val nameIndex = it.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                    fileName = it.getString(nameIndex)
                }
            }

            if (fileName == null) {
                return
            }

            val externalFile = File(getExternalFilesDir(null), fileName!!)

            val inputStream: InputStream? = contentResolver.openInputStream(it)
            val outputStream = FileOutputStream(externalFile)

            inputStream.use { input -> outputStream.use { output -> input?.copyTo(output) } }

            val channel = MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger!!, channel)

            channel.invokeMethod("newIntent", null)
        }
    }
}
