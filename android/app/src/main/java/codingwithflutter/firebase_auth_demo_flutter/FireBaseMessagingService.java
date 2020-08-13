package io.byebye.inventory;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.graphics.RectF;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Build;
import android.util.Log;

import androidx.core.app.NotificationCompat;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

import org.json.JSONException;
import org.json.JSONObject;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Map;

public class FireBaseMessagingService extends FirebaseMessagingService {

    private static final String TAG = "MyFirebaseMsgService";
    private static int count = 0;
    String CHANNEL_ID = "Bye Bye Notification";

    // You were android developer before flutter? i learned a liitle bit in college,
    // Okay good.

    // onMessageReceived is called when we get notification in andorid. and in the
    // following code I'm creating json object and sending it to app using intent.
    // Got it ?yes

    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {

        Log.v(TAG, "onMessageReceived: " + remoteMessage.getData());
        // try now..
        // while this is launching can we test on ios?
        // yes
        // Displaying data in log
        // It is optional
        /*
         * Log.d(TAG, "Notification Message TITLE: " +
         * remoteMessage.getNotification().getTitle()); Log.d(TAG,
         * "Notification Message BODY: " + remoteMessage.getNotification().getBody());
         * Log.d(TAG, "Notification Message DATA: " +
         * remoteMessage.getData().toString()); Log.d(TAG,
         * "Tag1"+remoteMessage.getData().get("tag1").toString()); Log.d(TAG,
         * "Tag2"+remoteMessage.getData().get("tag2").toString());
         */
        // Calling method to generate notification

        // Run it you are launching it on simulator? no launching in which id ? 46?no,
        // can i use 50? yes sure just relogin and also we gonna need 1 iOS, this is iOS
        // okay i'm having 2 andorid.alright, it's going to take a while, okay
        if (MainActivity.methodChannel != null) {
            
            
            // This if is for if user is in app and then he gets the notification then we
            // are getting data from notification and make it a json string and then send
            // it, to application (Flutter)
            String typeData = "0";
            JSONObject userDetails = new JSONObject();
            
                try {
                    userDetails.put("noti", "arrived");
                    userDetails.put("payload", remoteMessage.getData().get("payload"));
                    Log.v(TAG, "onMessageReceived type: secoend ");
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            

            // MainActivity.methodChannel.invokeMethod("notification", "arrived");
            //MainActivity.methodChannel.invokeMethod("notification", userDetails.toString());
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            int importance = NotificationManager.IMPORTANCE_HIGH;

            Uri defaultSoundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
            NotificationChannel mChannel = new NotificationChannel(CHANNEL_ID, "NOTFICATION CHANNEL", importance);

            mChannel.enableLights(true);
            mChannel.enableVibration(true);
            /*
             * mChannel.setLightColor(ContextCompat.getColor(getApplicationContext(),R.color
             * .colorPrimary));
             */
            mChannel.setLockscreenVisibility(Notification.VISIBILITY_PUBLIC);

            NotificationManager notificationManager = (NotificationManager) getSystemService(
                    Context.NOTIFICATION_SERVICE);
            notificationManager.createNotificationChannel(mChannel);

            PendingIntent contentIntent;
            
                contentIntent = PendingIntent.getActivity(this, 0,
                        new Intent(this, MainActivity.class).putExtra("payload", remoteMessage.getData().get("payload")),
                        PendingIntent.FLAG_ONE_SHOT);
                NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this)
                        .setLargeIcon(getCircleBitmap(getBitmapFromURL(remoteMessage.getData().get("user_pic"))))
                        .setSmallIcon(R.mipmap.ic_notification).setContentTitle(remoteMessage.getData().get("title"))
                        .setContentText(remoteMessage.getData().get("subtitle"))
                        .setPriority(NotificationCompat.PRIORITY_HIGH)
                        .setVisibility(NotificationCompat.VISIBILITY_PUBLIC).setAutoCancel(true)
                        .setChannelId(CHANNEL_ID).setSound(defaultSoundUri).setContentIntent(contentIntent);
                notificationManager.notify(count, notificationBuilder.build());
            

            // PendingIntent contentIntent = null;

        } else {
                sendNotification(remoteMessage.getData().get("payload"),remoteMessage.getData().get("user_pic"),
                remoteMessage.getData().get("title"),remoteMessage.getData().get("subtitle"));
        }
    }

    // This method is only generating push notification
    private void sendNotification(String payload, String user_pic, String messageTitle, String messageBody) {
        NotificationManager notificationManager;
        // PendingIntent contentIntent = null;

        PendingIntent contentIntent = PendingIntent.getActivity(this, 0,
                new Intent(this, MainActivity.class).putExtra("payload", payload),
                PendingIntent.FLAG_CANCEL_CURRENT);

        // PendingIntent contentIntent = PendingIntent.getActivity(this, 0, intent,
        // PendingIntent.FLAG_ONE_SHOT);
        Uri defaultSoundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
        NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this)
                .setLargeIcon(getCircleBitmap(getBitmapFromURL(user_pic)))
                // .setLargeIcon(BitmapFactory.decodeResource(getResources(),
                // R.mipmap.ic_launcher))
                .setSmallIcon(R.mipmap.ic_notification).setContentTitle(messageTitle).setContentText(messageBody)
                .setPriority(NotificationCompat.PRIORITY_HIGH).setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
                .setAutoCancel(true).setSound(defaultSoundUri).setContentIntent(contentIntent);

        notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        notificationManager.notify(count, notificationBuilder.build());
        count++;

    }


    public Bitmap getBitmapFromURL(String strURL) {
        try {
            URL url = new URL(strURL);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setDoInput(true);
            connection.connect();
            InputStream input = connection.getInputStream();
            Bitmap myBitmap = BitmapFactory.decodeStream(input);
            return myBitmap;
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    // This is for converting image into circular image.. okay? in the notification
    // ?Yes.ok
    private Bitmap getCircleBitmap(Bitmap bitmap) {
        Bitmap output = Bitmap.createBitmap(bitmap.getWidth(),
            bitmap.getHeight(), Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(output);

        final int color = Color.RED;
        final Paint paint = new Paint();
        final Rect rect = new Rect(0, 0, bitmap.getWidth(), bitmap.getHeight());

        paint.setAntiAlias(true);
        canvas.drawARGB(0, 0, 0, 0);
        paint.setColor(color);
        canvas.drawCircle(bitmap.getWidth() / 2, bitmap.getHeight() / 2,
        bitmap.getWidth() / 2, paint);
        paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SRC_IN));
        canvas.drawBitmap(bitmap, rect, rect, paint);
        return output;

    }
}
