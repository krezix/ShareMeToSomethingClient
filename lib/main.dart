import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;



void main() => runApp(MyApp());


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final appTitle = 'Share Me To Something';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: new SingleChildScrollView(child:MyCustomForm()
        ),
      ),
    );
  }
}

// Create a Form Widget
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}



// Create a corresponding State class. This class will hold the data related to
// the form.
class MyCustomFormState extends State<MyCustomForm> {
  static const platform = const MethodChannel("shareme.temkadisto.com/info");
  String _myMessage = "";
  var _ctrlIP = new TextEditingController();
  var _ctrlPORTA = new TextEditingController();








  void _recebeShare(){
    _getMessage().then((String message){
      sendData(message, _ctrlIP.text, _ctrlPORTA.text);

      setState(() {

        _myMessage = message ?? "No shares...";
      });
    });
  }



  @override
  void initState() {
    _loadValues();

    _recebeShare();

    SystemChannels.lifecycle.setMessageHandler((msg){
      if(msg==AppLifecycleState.resumed.toString()) {
        _recebeShare();
        setState(() {}
        );
      }
    });
    super.initState();

  }

  void updateIP(String value) {
    this._ctrlIP.text= value;
  }

  void updatePORTA(String value) {
    this._ctrlPORTA.text= value;

  }
  void _loadValues() {
    getPref("theIP").then(
      updateIP
    );
    getPref("thePORTA").then(
        updatePORTA
    );
  }



  @override
  Widget build(BuildContext context) {
    _saveButton()  {

      if (_ctrlIP.text.isNotEmpty) {
        savePref("theIP", _ctrlIP.text);

      }
      if (_ctrlIP.text.isNotEmpty) {
        savePref("thePORTA", _ctrlPORTA.text);
      }
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('A guardar...'),
              duration: Duration(seconds: 1))
      );
    }

    // Build a Form widget using the _formKey we created above
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Text(
                'Hello, $_myMessage! How are you?',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: new TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _ctrlIP,
                decoration: InputDecoration(
                    labelText: 'URL'
                ),

              ),
              TextFormField(
                controller: _ctrlPORTA,
                decoration: InputDecoration(
                    labelText: 'Porta'
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: (){
                    _getMessage().then((String message){
                      sendData(message, _ctrlIP.text, _ctrlPORTA.text);

                      setState(() {

                        _myMessage = message ?? " ";
                      });
                    });
                  },
                  child: Text('recebeshare'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: _saveButton,
                  child: Text('Save'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: _loadValues,
                  child: Text('Reload'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  sendData(String url, String IP, String Porta) async {
    //String dataURL = "https://jsonplaceholder.typicode.com/posts";
    print ("url = $url");
    if(url != null && url.isNotEmpty) {
      try {
        String u = url ?? " ";
        //print("url = $u");
        String p = Porta ?? "7531";
        String furl = ":$p/shared?url=$u";
        //print(furl);

        String ip = IP ?? "127.0.0.1";
        String finalUrl = "http://$ip$furl";
        //print("final : $finalurl");

        http.Response response = await http.get(finalUrl);
        print("resposta = $response");
      } catch (e) {
        print(e);
      }
      //print(response);
    }
  }

  Future<String> _getMessage() async{
    String value;
    try {
      value = await platform.invokeMethod("getMessage");
      print ("valor : $value");
    }catch (e){
      print (e);
    }

    return value;
  }
//todas as prefs guardadas serão Strings
  Future<bool> savePref(String Name, String Value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(Name,Value);
  }

  Future<String> getPref(String myPref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String str = prefs.getString(myPref) ;
    return str ??= "nulo";

  }

}
