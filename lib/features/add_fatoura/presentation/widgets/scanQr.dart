import 'dart:convert';
import 'dart:typed_data';

class ZatcaQrDecoder {
  static Map<String, dynamic> decode(String base64QrCode) {
    Uint8List bytes = base64.decode(base64QrCode);
    Map<String, dynamic> result = {};

    int index = 0;
    int tagNumber = 1;
    while (index < bytes.length) {
      int tag = bytes[index];
      int length = bytes[index + 1];
      Uint8List valueBytes = bytes.sublist(index + 2, index + 2 + length);
      String value = utf8.decode(valueBytes);

      switch (tag) {
        case 1:
          result['sellerName'] = value;
          break;
        case 2:
          result['vatNumber'] = value;
          break;
        case 3:
          result['invoiceDate'] = value;
          break;
        case 4:
          result['invoiceTotal'] = value;
          break;
        case 5:
          result['vatTotal'] = value;
          break;
        default:
          result['tag_$tagNumber'] = value;
      }

      index += 2 + length;
      tagNumber++;
    }

    return result;
  }
}
