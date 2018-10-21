package com.temkadisto.shareme;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "shareme.temkadisto.com/info";
    private String sharedText;

    void handleSendText(Intent intent) {
      sharedText = intent.getStringExtra(Intent.EXTRA_TEXT);
    }



  @Override
  protected void onNewIntent(Intent intent) {

    check_action(intent);
    super.onNewIntent(intent);

  }



  void check_action(Intent intent){
    if (Intent.ACTION_SEND.equals(intent.getAction()) && intent.getType() != null) {
      if ("text/plain".equals(intent.getType())) {
        handleSendText(intent); // Handle text being sent
      }
    }
  }

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    GeneratedPluginRegistrant.registerWith(this);
    Intent intent = getIntent();


    check_action(intent);


    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
      @Override
      public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {

        if (methodCall.method.equals("getMessage")){

          result.success(sharedText);

          sharedText=null;
        }
      }
    });


  }


}
