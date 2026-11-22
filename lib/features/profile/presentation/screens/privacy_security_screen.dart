import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'profile_page_scaffold.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) => ProfilePageScaffold(
    title: 'Privacy & Security',
    backgroundImage: 'assets/images/خلفية سفر عصرية بخريطة وطائرة.webp',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _intro(context),
        const SizedBox(height: 18),
        _section(context, 'Information We Collect', [
          'نقوم بجمع المعلومات التي تقدمها عند إنشاء الحساب أو إجراء حجز، مثل الاسم ورقم الهاتف والبريد الإلكتروني.',
          'قد نجمع بيانات استخدام التطبيق ومعلومات الجهاز لتحسين الأداء وحماية حسابك.',
        ]),
        _section(context, 'How We Use Your Information', [
          'نستخدم بياناتك لتأكيد الحجوزات، والتواصل معك، وتقديم تجربة سفر مناسبة لاحتياجاتك.',
          'لا نستخدم معلوماتك إلا للأغراض الموضحة في سياسة الخصوصية أو بموافقتك.',
        ]),
        _section(context, 'Data Protection', [
          'نطبّق إجراءات أمنية مناسبة لحماية معلوماتك من الوصول أو الاستخدام غير المصرح به.',
          'ننصحك بالحفاظ على سرية كلمة المرور وتسجيل الخروج من الأجهزة المشتركة.',
        ]),
        _section(context, 'Your Rights', [
          'يمكنك مراجعة بياناتك أو تحديثها أو طلب حذف حسابك في أي وقت من خلال التواصل مع الدعم.',
          'يمكنك إيقاف الإشعارات أو خدمات الموقع من إعدادات جهازك.',
        ]),
        const SizedBox(height: 8),
        Text(
          'آخر تحديث: يناير 2026',
          style: TextStyle(fontSize: 11, color: Colors.blueGrey.shade600),
        ),
      ],
    ),
  );

  Widget _intro(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.teal.withValues(alpha: .08),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.teal.withValues(alpha: .2)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.verified_user_outlined, color: AppColors.teal),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'خصوصيتك وأمان بياناتك مهمان بالنسبة لنا. توضح هذه الصفحة كيف نتعامل مع معلوماتك ونحافظ عليها.',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              height: 1.6,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _section(BuildContext context, String title, List<String> points) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            for (final point in points)
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 7),
                      child: Icon(Icons.circle, size: 5, color: AppColors.teal),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        point,
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 12, height: 1.55),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
}
