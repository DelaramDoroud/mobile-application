import 'package:flutter/material.dart';
// اگر پکیج google_fonts داری، این دو خط را از کامنت خارج کن و در متن‌ها استفاده کن.
// import 'package:google_fonts/google_fonts.dart';
// TextStyle get _titleStyle => GoogleFonts.dmSans(fontWeight: FontWeight.w700, fontSize: 20);

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('About Us'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero / Header
              Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      cs.primary.withOpacity(.90),
                      cs.secondary.withOpacity(.85),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.travel_explore, size: 56, color: cs.onPrimary),
                      const SizedBox(height: 8),
                      Text(
                        'Smart Travel',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: cs.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Making every trip simple, personal, and joyful',
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          color: cs.onPrimary.withOpacity(.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Mission & Vision
              _SectionCard(
                title: 'Our Mission',
                icon: Icons.flag_rounded,
                child: Text(
                  'We help travelers plan memorable journeys with smart recommendations, fair prices, and a delightful experience—anytime, anywhere.',
                  style: textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 12),
              _SectionCard(
                title: 'Our Vision',
                icon: Icons.auto_awesome_rounded,
                child: Text(
                  'To be your trusted companion for every step of the trip—from idea to happy memories.',
                  style: textTheme.bodyMedium,
                ),
              ),

              const SizedBox(height: 16),

              // Values
              Text(
                'Our Values',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  _ValueChip('Simplicity'),
                  _ValueChip('Trust'),
                  _ValueChip('Transparency'),
                  _ValueChip('Personalization'),
                  _ValueChip('Sustainability'),
                ],
              ),

              const SizedBox(height: 16),

              // Quick Stats
              Row(
                children: const [
                  Expanded(child: _StatTile(label: 'Users', value: '120k+')),
                  SizedBox(width: 10),
                  Expanded(
                    child: _StatTile(label: 'Destinations', value: '1,800+'),
                  ),
                  SizedBox(width: 10),
                  Expanded(child: _StatTile(label: 'Partners', value: '250+')),
                ],
              ),

              const SizedBox(height: 16),

              // Team preview
              _SectionCard(
                title: 'Meet the Team',
                icon: Icons.groups_rounded,
                child: SizedBox(
                  height: 130,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      _TeamItem(name: 'Sara', role: 'Product', emoji: '🧭'),
                      _TeamItem(name: 'Delaram', role: 'Mobile', emoji: '📱'),
                      _TeamItem(name: 'Sama', role: 'Design', emoji: '🎨'),
                      _TeamItem(name: 'Reza', role: 'Data', emoji: '📊'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Contact
              _SectionCard(
                title: 'Get in Touch',
                icon: Icons.contact_support_rounded,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.mail_outline_rounded),
                            const SizedBox(width: 8),
                            Text('support@smarttravel.app'),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.contact_phone_rounded),
                            const SizedBox(width: 8),
                            Text('+39 123 456 7890'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),

              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),

              // Footer
              Column(
                children: [
                  Text('Smart Travel • v1.0.0', style: textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text(
                    '© ${DateTime.now().year} Smart Travel Team. All rights reserved.',
                    style: textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

// ----- Helper widgets -----

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outline.withOpacity(.2)),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: cs.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _ValueChip extends StatelessWidget {
  final String label;
  const _ValueChip(this.label);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withOpacity(.35),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.primary.withOpacity(.35)),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  const _StatTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: 84,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outline.withOpacity(.2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: textTheme.labelLarge?.copyWith(
              color: Theme.of(context).hintColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamItem extends StatelessWidget {
  final String name;
  final String role;
  final String emoji;
  const _TeamItem({
    required this.name,
    required this.role,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outline.withOpacity(.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: cs.primaryContainer,
            child: Text(emoji, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(role, style: TextStyle(color: Theme.of(context).hintColor)),
        ],
      ),
    );
  }
}
