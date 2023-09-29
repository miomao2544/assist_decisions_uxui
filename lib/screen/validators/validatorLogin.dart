String? validateUsername(String? value, String? result) {
  if (value!.isEmpty) {
    return 'กรุณากรอกชื่อผู้ใช้งาน';
  } else if (!RegExp(r'^[a-zA-Z0-9]{6,12}$').hasMatch(value)) {
    return 'ชื่อผู้ใช้งานต้องเป็นตัวอักษรภาษาอังกฤษและตัวเลขเท่านั้น และความยาวต้องอยู่ระหว่าง 6-12 ตัวอักษร';
  } else if (result == "nodata") {
    return 'ชื่อผู้ใช้ไม่ถูกต้อง';
  }
  return null;
}

String? validatePassword(String? value, String? result) {
  if (value!.isEmpty) {
    return 'กรุณากรอกรหัสผ่าน';
  } else if (value.length < 8 || value.length > 16) {
    return 'รหัสผ่านต้องมีความยาวระหว่าง 8-16 ตัวอักษร';
  } else if (!RegExp(r'^[a-zA-Z0-9@_-]+$').hasMatch(value)) {
    return 'รหัสผ่านต้องเป็นตัวอักษรภาษาอังกฤษหรือตัวเลขเท่านั้น รวมอักขระพิเศษ [ @_- ] ได้';
  } else if (result == "false") {
    return 'รหัสผ่านไม่ถูกต้อง';
  }
  return null;
}
