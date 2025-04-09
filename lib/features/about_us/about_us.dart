import 'package:flutter/material.dart';

class AboutDamanakScreen extends StatelessWidget {
  const AboutDamanakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("عن احفظ ضمانك"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SectionTitle("نبذة عامة"),
            SectionSubtitle("احفظ ضمانك – حافظ على فواتيرك بأمان!")
            ,
            SectionText("\"احفظ ضمانك\" هو تطبيق ذكي، مصمم لحفظ وإدارة فواتير مشترياتك إلكترونيًا مما يساعدك في تتبع فواتيرك وتنظيم مشترياتك بكل سهولة.")
            ,
            SectionText("توجّه إلى إيصال بياناتك من خلال أدوات رقمية تساعدك في:")
            ,
            BulletPoint("تخزين فواتيرك في مكان واحد."),
            BulletPoint("تنظيم الفواتير حسب الفئة."),
            BulletPoint("تذكيرك بإنتهاء الضمانات للمنتجات الخاصة بك."),
            BulletPoint("إنشاء التقارير المالية لمساعدتك على متابعة نفقاتك الشهرية."),
            SizedBox(height: 20),
            SectionTitle("الخصوصية والأمان"),
            SectionSubtitle("خصوصيتك أولويتنا... بياناتك في أيدٍ آمنة"),
            SectionText("نلتزم في \"احفظ ضمانك\" بحماية خصوصية بياناتك أثناء جمع معلوماتك الشخصية.")
            ,
            SectionText("نستخدم تقنيات أمان متقدمة لحماية بياناتك من الوصول غير المصرح به.")
            ,
            SectionText("لمزيد من التفاصيل، يرجى مراجعة \"الشروط والأحكام\" و\"سياسة الخصوصية\"."),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class SectionSubtitle extends StatelessWidget {
  final String text;
  const SectionSubtitle(this.text, {super.key});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class SectionText extends StatelessWidget {
  final String text;
  const SectionText(this.text, {super.key});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint(this.text, {super.key});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ", style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
