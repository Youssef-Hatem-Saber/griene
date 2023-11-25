// ignore_for_file: empty_statements

class Plant {
  Map<String, String> plantStatusMap = {
    'Rice': 'cannot',
    'Wheat': 'cannot',
    'Corn': 'cannot',
    'SugarCane': 'cannot',
    'Bean': 'cannot',
    'Tomato': 'cannot',
    'Cucumber': 'cannot',
    'Potato': 'cannot',
    'Mulukhiyah': 'cannot',
    'Clover': 'cannot',
    'Lemon': 'cannot',
    'Mint': 'cannot',
  };
  bool pRice(String month, double temp) {
    if (month == "april" || month == "may") {
      return true;
    }
    if( temp >= 21 && temp < 35){
      plantStatusMap["Rice"] = "can";
    };
    return false;
  }

  bool pWheat(String month, double temp) {
    if (month == "november" || month == "december") {
      return true;
    }
    if(temp >= 4 && temp < 25) {
      plantStatusMap["Wheat"] = "can";
    }
    return false;
    }


  bool pCorn(String month, double temp) {
    if (month == "april" || month == "may") {
      return true;
    }
    if (temp >= 20 && temp < 22){
      plantStatusMap["Corn"] = "can";
    };
    return false;
  }

  bool pSugarCane(String month, double temp) {
    if (month == "february" || month == "march"){
      return true;
    }if (temp >= 32 && temp < 38){
      plantStatusMap["SugarCane"] = "can";
    };
    return false;
  }

  bool pBean(String month, double temp) {
    if (month == "october" || month == "november"){
      return true;
    }
    if(temp >= 18 && temp < 22){
      plantStatusMap["Bean"] = "can";
    };
    return false;
  }

  bool pTomato(String month, double temp) {
    if (month == "september" || month == "october"){
      return true;
    } if(temp >= 15 && temp < 25){
      plantStatusMap["Tomato"] = "can";
    };
    return false;
  }

  bool pCucumber(String month, double temp) {
    if (month == "february" || month == "march" || month == "august" || month == "september"){
      return true;
    }
    if(temp >= 15 && temp < 35){
      plantStatusMap["Cucumber"] = "can";
    };
    return false;
  }

  bool pPotato(String month, double temp) {
    if (month == "august" || month == "september" || month == "october" || month == "november" || month == "january" || month == "february"){
      return true;
    } if(temp >= 15 && temp < 55){
      plantStatusMap["Potato"] = "can";

    };
    return false;
  }

  bool pMulukhiyah(String month, double temp) {
    if (month == "march" || month == "september" || month == "january" || month == "november"){
      return true;
    } if(temp >= 20 && temp < 50){
      plantStatusMap["Mulukhiyah"] = "can";
    };
    return false;
  }

  bool pClover(String month, double temp) {
    if (month == "september" || month == "october"){
      return true;
    } if(temp >= 18 && temp < 25){
      plantStatusMap["clover"] = "can";
    };
    return false;
  }

  bool pLemon(String month, double temp) {
    if (month == "april" || month == "august"){
      return true;
    } if(temp >= 4 && temp < 50){
      plantStatusMap["Lemon"] = "can";
    };
    return false;
  }

  bool pMint(String month, double temp) {
    if (month == "february" || month == "march"){
      return true;
    }
    if(temp >= 25 && temp < 40){
      plantStatusMap["Mint"] = "can";
    };
    return false;
  }

  final currentMonth = DateTime.now().month;

  String getMonthName(int month) {
    switch (month) {
      case DateTime.january:
        return 'January';
      case DateTime.february:
        return 'February';
      case DateTime.march:
        return 'March';
      case DateTime.april:
        return 'April';
      case DateTime.may:
        return 'May';
      case DateTime.june:
        return 'June';
      case DateTime.july:
        return 'July';
      case DateTime.august:
        return 'August';
      case DateTime.september:
        return 'September';
      case DateTime.october:
        return 'October';
      case DateTime.november:
        return 'November';
      case DateTime.december:
        return 'December';
      default:
        return 'Unknown';
    }
  }
}
