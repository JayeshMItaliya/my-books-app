package io.byebye.inventory;

import android.annotation.TargetApi;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import io.flutter.app.FlutterActivity;

import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import static android.content.ContentValues.TAG;

public class MainActivity extends FlutterActivity {
  public static MethodChannel methodChannel;
  private String CHANNEL = "io.byebye.inventory/platform_channel";
  private static final String TAG1 = "MainActivity";
  Intent intent;
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);


    GeneratedPluginRegistrant.registerWith(this);

    methodChannel = new MethodChannel(getFlutterView(),CHANNEL);
    Log.e(TAG1, "onCreate: " );
    //cancelAllNotifications();

    //Intent which we are passing in andorid will be used here to make json and then send it flutter application. Okay?yes

    intent = getIntent();
    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            (call, result) -> {
              if (call.method.equals("getIntent")) {
                if (intent != null) {
                  
                      JSONObject userDetails = new JSONObject();

                      try {
                        userDetails.put("payload", intent.getStringExtra("payload"));
                      
                      } catch (JSONException e) {
                        e.printStackTrace();
                      }
                      //intent = null;
                      result.success(userDetails.toString());
                  
                }  else {
                  //intent = null;
                  android.util.Log.e(TAG, "onCreate: No Intent" );
                  result.success("false");
                }
              } else {
                //intent = null;
                result.notImplemented();
              }
            });

  }


  @Override
  protected void onStart() {
    super.onStart();
    Log.e(TAG1, "onStart: "+getIntent().hasExtra("type") );
  }

  @Override
  protected void onResume() {
    super.onResume();
    Log.e(TAG1, "onResume: "+getIntent().hasExtra("type")  );
  }

  @Override
  public void onNewIntent(Intent intent) {
    super.onNewIntent(intent);
    Log.e(TAG1, "onNewIntent: "+intent.hasExtra("type"));

    if (intent != null) {
      
          JSONObject userDetails = new JSONObject();

          try {
            userDetails.put("payload", intent.getStringExtra("payload"));

            new Handler(Looper.getMainLooper()).post(new Runnable() {
              @Override
              public void run() {
                MainActivity.methodChannel.invokeMethod("notification", userDetails.toString());
              }
            });

          } catch (JSONException e) {
            e.printStackTrace();
          }
    }



  }


  private void cancelAllNotifications() {
    NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
    notificationManager.cancelAll();
  }

}

