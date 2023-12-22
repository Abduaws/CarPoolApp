import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestAssistant{
  static Future<dynamic> getRequest(String requestURL) async {
    try{
      http.Response response = await http.get(Uri.parse(requestURL));
      if(response.statusCode == 200){
        String responseData = response.body;
        return jsonDecode(responseData);
      }
      return "No Response";
    }
    catch(e){
      return "Error";
    }
  }
}