package io.byebye.inventory;

import android.util.Log;

import com.google.firebase.messaging.FirebaseMessagingService;

public class FireBaseInstanceIDService extends FirebaseMessagingService {
    private static final String TAG = "MyFirebaseIDService";

    @Override
    public void onNewToken(String s) {
        Log.e(TAG, "onNewToken: " + s);
        super.onNewToken(s);
    }
}