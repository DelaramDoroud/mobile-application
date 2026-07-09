import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

class OnlineSupportPage extends StatefulWidget {
  const OnlineSupportPage({super.key});

  @override
  State<OnlineSupportPage> createState() => _OnlineSupportPageState();
}

class _OnlineSupportPageState extends State<OnlineSupportPage> {
  static const Color _errorSnackBarColor = Colors.red;

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  bool _submitting = false;
  String _topic = _topics.first;

  static const List<String> _topics = [
    'Travel planning',
    'Reservation help',
    'Transportation',
    'Accommodation',
    'Tour package',
    'Account or payment',
  ];

  static const List<_FaqItem> _faqs = [
    _FaqItem(
      question: 'Can support help me plan a complete trip?',
      answer:
          'Yes. Share your destination, dates, budget, and travel style. A supporter can help you compare transport, stays, attractions, and tours.',
    ),
    _FaqItem(
      question: 'What should I include in my support request?',
      answer:
          'Include your travel dates, number of travelers, preferred city or destination, budget range, and any booking reference if you already reserved something.',
    ),
    _FaqItem(
      question: 'Can I ask about existing reservations?',
      answer:
          'Yes. Choose Reservation help and describe the reservation you need assistance with so the support team can review it.',
    ),
    _FaqItem(
      question: 'How quickly will support respond?',
      answer:
          'Most requests are reviewed as soon as possible. Clear details help the supporter answer faster and with better recommendations.',
    ),
    _FaqItem(
      question: 'Can support recommend attractions or tours?',
      answer:
          'Yes. Tell us what kind of experiences you prefer, such as culture, nature, history, adventure, or family-friendly activities.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _nameCtrl.text = user?.displayName ?? '';
    _emailCtrl.text = user?.email ?? '';
    _phoneCtrl.text = user?.phoneNumber ?? '';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showErrorSnackBar('Please log in to send a support request.');
      return;
    }

    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);

    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final docId = '${user.uid}_$now';

      await FirebaseFirestore.instance
          .collection('support_requests')
          .doc(docId)
          .set({
            'userId': user.uid,
            'name': _nameCtrl.text.trim(),
            'email': _emailCtrl.text.trim(),
            'phone': _phoneCtrl.text.trim(),
            'topic': _topic,
            'message': _messageCtrl.text.trim(),
            'status': 'new',
            'createdAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true))
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw Exception(
                'Firestore did not respond. Check internet or Firestore rules.',
              );
            },
          );

      if (!mounted) return;
      _messageCtrl.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your request was sent to the support team.'),
        ),
      );
    } on FirebaseException catch (e) {
      if (!mounted) return;
      _showErrorSnackBar('Could not send your request: ${e.message ?? e.code}');
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar('Could not send your request: $e');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: _errorSnackBarColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEFF8F4), AppColors.surface],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHero(context)),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                sliver: SliverToBoxAdapter(child: _buildFaqSection(context)),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                sliver: SliverToBoxAdapter(child: _buildSupportForm(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('images/pic12.jpg', fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.14),
                  AppColors.primary.withOpacity(0.84),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Travel help, when you need it',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 30,
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Find quick answers or send your trip details to a supporter and get answer less than 24 hours.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.white.withOpacity(0.92),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqSection(BuildContext context) {
    return _SupportPanel(
      title: 'FAQ',
      icon: Icons.quiz_outlined,
      child: Column(
        children:
            _faqs
                .map(
                  (faq) => ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: const EdgeInsets.only(bottom: 12),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.muted,
                    title: Text(
                      faq.question,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          faq.answer,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.muted, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildSupportForm(BuildContext context) {
    return _SupportPanel(
      title: 'Contact a Supporter',
      icon: Icons.support_agent_rounded,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameCtrl,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Full name',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.trim().length < 2) {
                  return 'Enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (value) {
                final email = value?.trim() ?? '';
                if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Phone number',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              validator: (value) {
                final phone = value?.trim() ?? '';
                if (phone.isNotEmpty &&
                    !RegExp(r'^\+?[\d\s\-]{7,15}$').hasMatch(phone)) {
                  return 'Enter a valid phone number (optional)';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _topic,
              decoration: const InputDecoration(
                labelText: 'Topic',
                prefixIcon: Icon(Icons.topic_outlined),
              ),
              items:
                  _topics
                      .map(
                        (topic) => DropdownMenuItem<String>(
                          value: topic,
                          child: Text(topic),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _topic = value);
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _messageCtrl,
              minLines: 5,
              maxLines: 8,
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(
                labelText: 'How can we help?',
                alignLabelWithHint: true,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 86),
                  child: Icon(Icons.chat_bubble_outline),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().length < 12) {
                  return 'Tell us a little more about your request';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: _submitting ? null : _submitRequest,
              icon:
                  _submitting
                      ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Icon(Icons.send_rounded),
              label: Text(_submitting ? 'Sending...' : 'Send request'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportPanel extends StatelessWidget {
  const _SupportPanel({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _FaqItem {
  const _FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}
