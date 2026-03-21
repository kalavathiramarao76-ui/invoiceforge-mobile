import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../services/ai_service.dart';

class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({super.key});

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  String _result = '';
  bool _loading = false;
  int _selectedTemplate = -1;

  final List<Map<String, dynamic>> _templates = [
    {
      'icon': Icons.receipt_long_rounded,
      'title': 'Freelancer Invoice',
      'desc': 'Hourly rate invoice for freelance work',
      'prompt': 'Generate a freelancer invoice template with hourly rate, project hours, subtotal, tax, and total. Include payment terms NET 30.',
    },
    {
      'icon': Icons.storefront_rounded,
      'title': 'Service Invoice',
      'desc': 'Standard business service invoice',
      'prompt': 'Generate a service business invoice template with multiple line items, quantity, unit price, discounts, tax calculation, and bank details.',
    },
    {
      'icon': Icons.handshake_rounded,
      'title': 'Consulting Proposal',
      'desc': 'Professional consulting engagement',
      'prompt': 'Generate a consulting proposal template with executive summary, methodology, deliverables, timeline, team, and investment sections.',
    },
    {
      'icon': Icons.code_rounded,
      'title': 'Software Dev Proposal',
      'desc': 'Tech project scope and pricing',
      'prompt': 'Generate a software development proposal template including tech stack, sprints, milestones, UAT, deployment plan, and pricing.',
    },
    {
      'icon': Icons.work_outline_rounded,
      'title': 'NDA Contract',
      'desc': 'Non-disclosure agreement template',
      'prompt': 'Generate a non-disclosure agreement (NDA) template with definitions, obligations, exclusions, term, remedies, and signature blocks.',
    },
    {
      'icon': Icons.design_services_rounded,
      'title': 'Freelance Contract',
      'desc': 'Independent contractor agreement',
      'prompt': 'Generate a freelance/independent contractor agreement template with scope, payment, IP rights, termination, and liability clauses.',
    },
  ];

  Future<void> _useTemplate(int index) async {
    setState(() { _loading = true; _selectedTemplate = index; _result = ''; });
    final response = await AIService.generate(
      'You are an expert document template generator. Create professional, ready-to-use templates with placeholder fields marked in [BRACKETS].',
      _templates[index]['prompt'],
    );
    setState(() { _result = response; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0f0d),
      appBar: AppBar(
        title: Text('Templates', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose a template to generate', style: GoogleFonts.inter(fontSize: 15, color: Colors.white54)),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.1,
              ),
              itemCount: _templates.length,
              itemBuilder: (context, index) {
                final t = _templates[index];
                final selected = _selectedTemplate == index;
                return InkWell(
                  onTap: _loading ? null : () => _useTemplate(index),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF22c55e).withOpacity(0.15) : const Color(0xFF141f1a),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selected ? const Color(0xFF22c55e) : const Color(0xFF22c55e).withOpacity(0.1),
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(t['icon'], color: const Color(0xFF22c55e), size: 28),
                        const SizedBox(height: 12),
                        Text(t['title'], style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(t['desc'], style: GoogleFonts.inter(fontSize: 11, color: Colors.white54), maxLines: 2),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: (100 * index).ms).scale(begin: const Offset(0.95, 0.95));
              },
            ),
            if (_loading) ...[
              const SizedBox(height: 32),
              Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(color: const Color(0xFF22c55e)),
                    const SizedBox(height: 16),
                    Text('Generating template...', style: GoogleFonts.inter(color: Colors.white54)),
                  ],
                ),
              ),
            ],
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Generated Template', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white70)),
                  IconButton(onPressed: () => Share.share(_result),
                    icon: const Icon(Icons.share_rounded, color: Color(0xFF22c55e), size: 20)),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity, padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF141f1a), borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF22c55e).withOpacity(0.2)),
                ),
                child: SelectableText(_result,
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.white.withOpacity(0.9), height: 1.6)),
              ).animate().fadeIn(),
            ],
          ],
        ),
      ),
    );
  }
}
