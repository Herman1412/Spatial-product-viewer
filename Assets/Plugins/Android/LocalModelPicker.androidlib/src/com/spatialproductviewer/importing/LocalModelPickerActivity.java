package com.spatialproductviewer.importing;

import android.app.Activity;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.provider.OpenableColumns;
import android.util.Log;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

/** Uses Android's document permission grant; no broad storage permission or network service. */
public final class LocalModelPickerActivity extends Activity {
    private static final int REQUEST = 8712;
    private static final int MAX_BYTES = 64 * 1024 * 1024;
    private static final ConcurrentHashMap<String, String> RESULTS = new ConcurrentHashMap<>();
    private String receiver;

    // Unity polls only after its activity resumes. Never call into a paused Unity player
    // from the file-copy thread: finishing this activity must not depend on that call.
    public static String takeResult(String receiver) {
        return receiver == null ? null : RESULTS.remove(receiver);
    }

    public static void open(Activity activity, String receiver) {
        RESULTS.remove(receiver);
        activity.runOnUiThread(() -> {
            try {
                Intent intent = new Intent(activity, LocalModelPickerActivity.class);
                intent.putExtra("receiver", receiver);
                activity.startActivity(intent);
            } catch (Exception error) {
                publish(receiver, "error:", "The system file picker could not be opened. Please try again.");
            }
        });
    }

    @Override protected void onCreate(Bundle state) {
        super.onCreate(state);
        receiver = getIntent().getStringExtra("receiver");
        if (state != null) return;
        Intent pick = new Intent(Intent.ACTION_OPEN_DOCUMENT);
        pick.addCategory(Intent.CATEGORY_OPENABLE);
        // Model MIME types vary across Downloads providers; validate the extension after selection.
        pick.setType("*/*");
        pick.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
        try { startActivityForResult(pick, REQUEST); }
        catch (Exception error) {
            publish(receiver, "error:", "No system file picker is available on this device.");
            finish();
        }
    }

    @Override protected void onActivityResult(int request, int result, Intent data) {
        super.onActivityResult(request, result, data);
        if (request != REQUEST) return;
        if (result != RESULT_OK || data == null || data.getData() == null) {
            publish(receiver, "error:", "File selection cancelled.");
            finish();
            return;
        }
        final Uri uri = data.getData();
        new Thread(() -> copySelectedFile(uri), "LocalModelCopy").start();
    }

    private void copySelectedFile(Uri uri) {
        File output = null;
        try {
            Log.i("LocalModelPicker", "Copying selected document into the model cache.");
            String name = "";
            try (Cursor cursor = getContentResolver().query(uri, new String[]{OpenableColumns.DISPLAY_NAME}, null, null, null)) {
                if (cursor != null && cursor.moveToFirst()) name = cursor.getString(0);
            }
            String lower = name == null ? "" : name.toLowerCase(java.util.Locale.ROOT);
            String extension = lower.endsWith(".glb") ? ".glb" : lower.endsWith(".ply") ? ".ply"
                : lower.endsWith(".spz") ? ".spz" : lower.endsWith(".splat") ? ".splat" : null;
            if (extension == null)
                throw new IllegalArgumentException("Choose a GLB or Gaussian PLY, SPZ or SPLAT file.");
            name = name.replaceAll("[^a-zA-Z0-9._ -]", "_");
            if (name.length() > 100) name = name.substring(0, 100 - extension.length()) + extension;
            File cache = getExternalCacheDir();
            if (cache == null) cache = getCacheDir();
            File folder = new File(new File(cache, "ModelImport"), UUID.randomUUID().toString());
            if (!folder.mkdirs()) throw new java.io.IOException("Could not prepare the model cache.");
            output = new File(folder, name);
            try (InputStream source = getContentResolver().openInputStream(uri);
                 FileOutputStream destination = new FileOutputStream(output)) {
                if (source == null) throw new java.io.IOException("Could not open the selected model.");
                byte[] buffer = new byte[65536];
                int count;
                long total = 0;
                while ((count = source.read(buffer)) != -1) {
                    total += count;
                    if (total > MAX_BYTES) throw new java.io.IOException("Choose a model smaller than 64 MB.");
                    destination.write(buffer, 0, count);
                }
            }
            publish(receiver, "file:", output.getAbsolutePath());
            Log.i("LocalModelPicker", "Document copy complete; closing picker before Unity imports it.");
        } catch (Exception error) {
            if (output != null) output.delete();
            publish(receiver, "error:", "Could not read the file: " + error.getMessage());
        } finally { runOnUiThread(this::finish); }
    }

    private static void publish(String receiver, String kind, String message) {
        if (receiver != null) RESULTS.put(receiver, kind + message);
    }
}
