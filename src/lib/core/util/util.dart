//Utility class that contains helper methods used across the app

class AppUtils{

  //Validate if string is a properly formatted URL
  static bool isValidUrl(String url){
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }




}
