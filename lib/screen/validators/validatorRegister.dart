import 'package:assist_decisions_app/controller/memberController.dart';

bool isThaiOrEnglish(String input) {
  final thaiPattern = RegExp(r'^[ก-๏\s]+$');
  final englishPattern = RegExp(r'^[a-zA-Z\s]+$');

  return thaiPattern.hasMatch(input) || englishPattern.hasMatch(input);
}

String? validateFirstname(String? value) {
  if (value == null || value.isEmpty) {
    return 'กรุณากรอกชื่อ';
  } else if (!isThaiOrEnglish(value)) {
    return 'กรุณาเขียนเป็นภาษาไทย หรือ อังกฤษเท่านั้น';
  } else if (value.length < 2 || value.length > 100) {
    return 'อักษรของคุณควรอยู่ระหว่าง 2 และ 100 ตัวอักษร';
  }
  return null;
}

String? validateLastname(String? value) {
  if (value == null || value.isEmpty) {
    return 'กรุณากรอกนามสกุล';
  } else if (!isThaiOrEnglish(value)) {
    return 'กรุณาเขียนเป็นภาษาไทย หรือ อังกฤษเท่านั้น';
  } else if (value.length < 2 || value.length > 100) {
    return 'อักษรของคุณควรอยู่ระหว่าง 2 และ 100 ตัวอักษร';
  }
  return null;
}

bool isValidEmail(String email) {
  final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  return emailRegex.hasMatch(email);
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'กรุณากรอกอีเมล์';
  } else if (!isValidEmail(value)) {
    return 'รูปแบบของคุณอีเมล์ไม่ถูกต้อง';
  } else if (value.length < 5 || value.length > 60) {
    return 'อักษรของคุณควรอยู่ระหว่าง 5 และ 60 ตัวอักษร';
  } else if (value.contains(' ')) {
    return 'ไม่อนุญาตให้มีช่องว่างในข้อมูล';
  }
  return null;
}

bool isValidTel(String tel) {
  final validDigits = RegExp(r'^[0-9]{10}$');
  return validDigits.hasMatch(tel);
}

String? validateTel(String? value) {
  if (value == null || value.isEmpty) {
    return 'กรุณากรอกหมายเลขโทรศัพท์';
  } else if (!value.startsWith('06') &&
      !value.startsWith('08') &&
      !value.startsWith('09')) {
    return 'หมายเลขโทรศัพท์ต้องขึ้นต้นด้วย 06, 08, หรือ 09';
  }
  if (!isValidTel(value)) {
    return 'หมายเลขโทรศัพท์ต้องประกอบด้วยตัวเลข 0-9';
  } else if (value.length != 10) {
    return 'หมายเลขโทรศัพท์ต้องมี 10 ตัวเท่านั้น';
  }
  return null;
}

String? validateNickname(String? value) {
  if (value == null || value.isEmpty) {
    return 'กรุณากรอกชื่อ';
  } else if (!isThaiOrEnglish(value)) {
    return 'กรุณาเขียนเป็นภาษาไทย หรือ อังกฤษเท่านั้น';
  } else if (value.length < 2 || value.length > 100) {
    return 'อักษรของคุณควรอยู่ระหว่าง 2 และ 100 ตัวอักษร';
  }
  return null;
}

bool isUsernameTaken = true;
MemberController memberController = MemberController();
Future checkUsernameExists(String username) async {
  isUsernameTaken = await memberController.checkUsernameExists(username);
}

String? validateUsername(String? value) {
  if (value == null || value.isEmpty) {
    return 'กรุณากรอกชื่อผู้ใช้งาน';
  } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
    return 'กรุณากรอกตัวอักษรภาษาอังกฤษหรือตัวเลขเท่านั้น';
  } else if (value.length < 6 || value.length > 12) {
    return 'อักษรของคุณควรอยู่ระหว่าง 6 และ 12 ตัวอักษร';
  } else if (isUsernameTaken) {
    return 'ชื่อผู้ใช้งานนี้มีอยู่ในระบบแล้ว';
  }
  return null;
}

bool isValidPassword(String password) {
  final validDigits = RegExp(r'^[a-zA-Z0-9@_\-\.]+$');
  return validDigits.hasMatch(password);
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'กรุณากรอกรหัสผ่าน';
  } else if (value.length < 8 || value.length > 16) {
    return 'รหัสผ่านควรมีความยาวระหว่าง 8 และ 16 ตัวอักษร';
  } else if (!isValidPassword(value)) {
    return 'รหัสผ่านควรประกอบด้วยตัวอักษรภาษาอังกฤษ, ตัวเลข, @, _, -, หรือ . เท่านั้น';
  }
  return null;
}
String? validateConfirmPassword(String? value, String? password) {
  if (value == null || value.isEmpty) {
    return 'กรุณารหัสผ่านอีกครั้งเพื่อยืนยัน';
  } else if (value != password) {
    return 'รหัสผ่านของคุณไม่เหมือนเดิม กรุณากรอกใหม่อีกครั้ง';
  }
  return null;
}
