String? validateTitle(String? value) {
  final RegExp validCharacters = RegExp(r'^[A-Za-zก-๏\s]+$');
  if (value == null || value.isEmpty) {
    return 'กรุณากรอกหัวข้อ';
  } else if (!validCharacters.hasMatch(value)) {
    return 'หัวข้อต้องประกอบด้วยอักษรภาษาไทยหรือภาษาอังกฤษเท่านั้น';
  } else if (value.length < 2 || value.length > 50) {
    return 'หัวข้อต้องมีจำนวนอักษรระหว่าง 2 และ 50 ตัวอักษร';
  }
  return null;
}

String? validatePoint(String? value,int pointmember) {
  final RegExp validPoint = RegExp(r'^[0-9]+$');
  if (value == null || value.isEmpty) {
    return 'กรุณากรอกคะแนน';
  } else if (!validPoint.hasMatch(value)) {
    return 'คะแนนต้องเป็นตัวเลขเท่านั้น';
  } else {
    int point = int.parse(value);
    if (point < 2 || point > 1000 || value.length < 2 || value.length > 4) {
      return 'คะแนนต้องเป็นจำนวนเต็มระหว่าง 2 ถึง 1000 เท่านั้น';
    } else if (value.contains(' ')) {
      return 'คะแนนไม่ควรมีช่องว่างระหว่างตัวเลข';
    }else if(point > pointmember){
       return 'ไม่เพียงพอ';
    }
  }
  return null;
}

String? validateMin(String? value) {
  final RegExp validQty = RegExp(r'^[0-9]+$');
  if (value == null || value.isEmpty) {
    return 'กรุณากรอกจำนวนผู้ที่เข้ารวมต่ำสุด';
  } else if (!validQty.hasMatch(value)) {
    return 'จำนวนผู้ที่เข้ารวมต่ำสุดต้องเป็นตัวเลขเท่านั้น';
  } else {
    if (value.length < 2 || value.length > 4) {
      return 'จำนวนผู้ที่เข้ารวมต่ำสุดต้องเป็นจำนวนเต็ม 10 เท่านั้น';
    } else if (value.contains(' ')) {
      return 'จำนวนผู้ที่เข้ารวมต่ำสุดไม่ควรมีช่องว่างระหว่างตัวเลข';
    }
  }
  return null;
}

String? validateMax(String? value) {
  final RegExp validQty = RegExp(r'^[0-9]+$');

  if (value == null || value.isEmpty) {
    return 'กรุณากรอกจำนวนผู้ที่เข้ารวมสูงสุด';
  } else if (!validQty.hasMatch(value)) {
    return 'จำนวนผู้ที่เข้ารวมสูงสุดต้องเป็นตัวเลขเท่านั้น';
  } else {
    if (value.length < 2 || value.length > 4) {
      return 'จำนวนผู้ที่เข้ารวมสูงสุดต้องเป็นจำนวนเต็ม 10 เท่านั้น';
    } else if (value.contains(' ')) {
      return 'จำนวนผู้ที่เข้ารวมสูงสุดไม่ควรมีช่องว่างระหว่างตัวเลข';
    }
  }
  return null;
}
