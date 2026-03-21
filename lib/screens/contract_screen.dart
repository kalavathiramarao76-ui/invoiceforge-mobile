import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/app_provider.dart';
import '../services/ai_service.dart';

class ContractScreen extends StatefulWidget {
  const ContractScreen({super.key});

  @override
  State<ContractScreen> createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen> {
  final _partiesController = TextEditingController();
  final _scopeController = TextEditingController();
  final _termsController = TextEditingController();
  final _durationController = TextEditingController();
  String _result = '';
  bool _loading = false;

  Future<void> _generate() async {
    if (_partiesController.text.isEmpty || _scopeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in parties and scope')),
      );
      return;
    }
    setState(() { _loading = true; _result = ''; });
    final details = '''
Parties: ${_partiesController.text}
Scope/Purpose: ${_scopeController.text}
Key Terms: ${_termsController.text}
Duration: ${_durationController.text}
''';
    final response = await AIService.generateContract(details);
    setState(() { _result = response; _loading = false; });
    if (mounted) {
      context.read<AppProvider>().addDocument('contract', 'Contract - ${_partiesController.text}', response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0f0d),
      appBar: AppBar(
        title: Text('Contract Drafter', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF22c55e).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF22c55e).withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.gavel_rounded, color: const Color(0xFF22c55e)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Draft comprehensive contracts with proper legal formatting.',
                      style: GoogleFonts.inter(fontSize: 13, color: Colors.white70)),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.1),
            const SizedBox(height: 24),
            _label('Parties Involved *'),
            const SizedBox(height: 8),
            TextField(controller: _partiesController, style: GoogleFonts.inter(color: Colors.white), maxLines: 2,
              decoration: const InputDecoration(hintText: 'e.g., Company A and Freelancer B')),
            const SizedBox(height: 20),
            _label('Scope / Purpose *'),
            const SizedBox(height: 8),
            TextField(controller: _scopeController, style: GoogleFonts.inter(color: Colors.white), maxLines: 3,
              decoration: const InputDecoration(hintText: 'Describe the agreement scope')),
            const SizedBox(height: 20),
            _label('Key Terms & Conditions'),
            const SizedBox(height: 8),
            TextField(controller: _termsController, style: GoogleFonts.inter(color: Colors.white), maxLines: 3,
              decoration: const InputDecoration(hintText: 'Payment terms, deliverables, etc.')),
            const SizedBox(height: 20),
            _label('Duration'),
            const SizedBox(height: 8),
            TextField(controller: _durationController, style: GoogleFonts.inter(color: Colors.white),
              decoration: const InputDecoration(hintText: 'e.g., 6 months, 1 year')),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity, height: 56,
              child: ElevatedButton.icon(
                onPressed: _loading ? null : _generate,
                icon: _loading ? const SizedBox(width: 20, height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black)) : const Icon(Icons.auto_awesome),
                label: Text(_loading ? 'Generating...' : 'Generate Contract'),
              ),
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _label('Generated Contract'),
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
              ).animate().fadeIn().slideY(begin: 0.05),
            ],
          ],
        ),
      ),
    );
  }

  Widget _label(String t) => Text(t, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white70));
}
