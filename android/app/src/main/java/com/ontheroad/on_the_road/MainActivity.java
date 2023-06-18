package com.ontheroad.on_the_road;

import io.flutter.embedding.android.FlutterActivity;


import android.os.Bundle;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import android.hardware.camera2.CameraAccessException;
import android.hardware.camera2.CameraCharacteristics;
import android.hardware.camera2.CameraManager;

import androidx.annotation.NonNull;



public class MainActivity extends FlutterActivity implements MethodChannel.MethodCallHandler{
    private static final String CHANNEL = "java_channel";
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Set up the method channel.
        MethodChannel channel = new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL);
        channel.setMethodCallHandler(this);
    }
    @Override
    public void onMethodCall(MethodCall call, @NonNull MethodChannel.Result result) {
        if (call.method.equals("getFocalLength")) {
            float focalLength = getFocalLenght();
            result.success(focalLength);
        } else {
            result.notImplemented();
        }
    }
    public float getFocalLenght(){
        CameraManager cameraManager = null;
        float focalLength =0;
        cameraManager = (CameraManager) getSystemService(CAMERA_SERVICE);
        try {
            // Get the first camera ID
            String cameraId = cameraManager.getCameraIdList()[0];
            // Get the camera characteristics for the given camera ID
            CameraCharacteristics characteristics = cameraManager.getCameraCharacteristics(cameraId);
            // Retrieve the focal length
            focalLength = characteristics.get(CameraCharacteristics.LENS_INFO_AVAILABLE_FOCAL_LENGTHS)[0];
        } catch (CameraAccessException e) {
            e.printStackTrace();
        }
        return focalLength;
    }
}
