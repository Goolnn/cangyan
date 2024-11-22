package com.goolnn.cangyan

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.provider.OpenableColumns
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import java.io.InputStream

class MainActivity : FlutterActivity() {
    private val methodChannel = "com.goolnn.cangyan/files"
    private val eventChannel = "com.goolnn.cangyan/include"

    private val projectsCode = 1001
    private val imagesCode = 1002

    private var result: MethodChannel.Result? = null
    private var sink: EventChannel.EventSink? = null

    private var intents = mutableListOf<Intent?>()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            methodChannel
        ).setMethodCallHandler { call, result ->
            this.result = result

            if (call.method == "projects") {
                val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
                    addCategory(Intent.CATEGORY_OPENABLE)
                    putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true)
                    type = "*/*"
                }

                startActivityForResult(intent, projectsCode)
            } else if (call.method == "images") {
                val intent = Intent(Intent.ACTION_PICK).apply {
                    putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true)
                    type = "image/*"
                }

                startActivityForResult(intent, imagesCode)
            }
        }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, eventChannel).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    sink = events

                    intents.forEach { intent ->
                        returnIntent(intent)
                    }
                }

                override fun onCancel(arguments: Any?) {
                    sink = null
                }
            })
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        when (requestCode) {
            projectsCode -> {
                val list = mutableListOf<Map<String, Any>>()

                if (resultCode == RESULT_OK) {
                    data?.clipData?.let { clipData ->
                        for (i in 0 until clipData.itemCount) {
                            val uri = clipData.getItemAt(i).uri
                            val project = readProject(uri)

                            list.add(project)
                        }
                    } ?: run {
                        data?.data?.let { uri ->
                            val project = readProject(uri)

                            list.add(project)
                        }
                    }
                }

                result?.success(list)
            }

            imagesCode -> {
                val list = mutableListOf<ByteArray>()

                if (resultCode == RESULT_OK) {
                    data?.clipData?.let { clipData ->
                        for (i in 0 until clipData.itemCount) {
                            val uri = clipData.getItemAt(i).uri

                            val inputStream: InputStream? = contentResolver.openInputStream(uri)
                            val fileData = inputStream?.readBytes() ?: ByteArray(0)

                            list.add(fileData)
                        }
                    }
                }

                result?.success(list)
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        returnIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)

        returnIntent(intent)
    }

    private fun returnIntent(intent: Intent?) {
        if (sink != null) {
            intent?.data.let { uri ->
                uri?.let {
                    val project = readProject(it)

                    sink!!.success(project)
                }
            }
        } else {
            intents.add(intent)
        }
    }

    private fun readProject(uri: Uri): Map<String, Any> {
        var projectTitle: String? = null
        var projectData: ByteArray? = null

        val inputStream: InputStream? = contentResolver.openInputStream(uri)

        val cursor = contentResolver.query(uri, null, null, null, null)

        cursor?.use {
            if (it.moveToFirst()) {
                val nameIndex = it.getColumnIndex(OpenableColumns.DISPLAY_NAME)

                val fileName = it.getString(nameIndex) ?: ""

                projectTitle = fileName.substringBeforeLast(".")
                projectData = inputStream?.readBytes() ?: ByteArray(0)
            }
        }

        return mapOf("title" to (projectTitle ?: ""), "data" to (projectData ?: ByteArray(0)))
    }
}
