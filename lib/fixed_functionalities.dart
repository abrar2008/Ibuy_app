import 'dart:ui';
//COLORS
const leadLight = Color(0xFF8eacbb);
const leadBase = Color(0xFF607d8b);
const leadDark = Color(0xFF34515e);

const starLight = Color(0xFFfff350);
const starBase = Color(0xFFffc107);
const starDark = Color(0xFFc79100);

const secondLight = Color(0xFF98ee99);
const secondBase = Color(0xFF66bb6a);
const secondDark = Color(0xFF338a3e);

const backLight = Color(0xFFf5f5f5);
const backDark = Color(0xFFe0e0e0);
const textLight = Color(0xFF616161);

const splashBase = Color(0xFF004ecb);

const errorBase = Color(0xFFf44336);
//FONTS

  String budgetValidator(String value) {
    if (value == null) {
      return "Budget can't be empty";
    }
    if (double.tryParse(value) == null) {
      return "Please enter numbers only";
    }
    if (double.tryParse(value) < 150) {
      return "Choose a number greater than 150";
    }
    return null;
  }

  String postalCodeValidator(String value) {

    if(value.trim().isEmpty) {
      return 'Please enter a Postal Code';
    }
    if(RegExp(r'^[ABCEGHJ-NPRSTVXYabceghj-nprstvxy]\d[ABCEGHJ-NPRSTV-Zabceghj-nprstv-z][ -]?\d[ABCEGHJ-NPRSTV-Zabceghj-nprstv-z]\d$').hasMatch(value.trim()) == false) {
      return 'Please enter a valid Postal Code';
    }
    return null;
  }