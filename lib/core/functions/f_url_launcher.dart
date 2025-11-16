import 'package:daily_info/core/functions/f_printer.dart';
import 'package:daily_info/core/functions/f_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

/// 🌐 OpenURLs.open()
/// 🚀 Launches:
/// - ☎️ Phone call (OpenType.tel)
/// - 📧 Email with subject/body (OpenType.email)
/// - 🔗 Website or WebApp (OpenType.url)
/// - 💬 WhatsApp (OpenType.whatsapp)
/// ❌ Handles failures gracefully with logs

enum OpenType { tel, url, email, whatsapp }

class OpenURLs {
  /// Opens dialer, browser, email, or WhatsApp based on the [type].
  static Future<void> open({
    required OpenType type,
    required String value,
    String subject = '',
    String body = '',
  }) async {
    Uri uri;

    switch (type) {
      case OpenType.tel:
        uri = Uri(scheme: 'tel', path: value);
        break;

      case OpenType.url:
        uri = Uri.parse(value);
        break;

      case OpenType.email:
        final query = <String, String>{
          if (subject.isNotEmpty) 'subject': subject,
          if (body.isNotEmpty) 'body': body,
        };

        uri = Uri(
          scheme: 'mailto',
          path: value,
          queryParameters: query.isEmpty ? null : query,
        );
        break;

      case OpenType.whatsapp:
        final encodedMessage = Uri.encodeComponent(body);
        uri = Uri.parse('https://wa.me/+88$value?text=$encodedMessage');
        break;
    }

    try {
      if (type == OpenType.email) {
        launchUrl(uri);
      } else {
        try {
          if (await canLaunchUrl(uri)) {
            await launchUrl(
              uri,
              mode: (type == OpenType.url) ? LaunchMode.externalApplication : LaunchMode.platformDefault,
            );
          } else {
            errorPrint('🐞 Could not launch $type for $value 🐛');
            showSnackBar('🐞 Could not launch $type for $value 🐛', snackBarType: SnackBarType.warning);
          }
        } catch (e) {
          errorPrint('🐞 Could not launch $type for $value 🐛');
          showSnackBar('🐞 Could not launch $type for $value 🐛', snackBarType: SnackBarType.warning);
        }
      }
    } catch (e) {
      errorPrint('🐞 Could not launch $type for $value 🐛');
      showSnackBar('🐞 Could not launch $type for $value 🐛', snackBarType: SnackBarType.warning);
    }
  }
}
