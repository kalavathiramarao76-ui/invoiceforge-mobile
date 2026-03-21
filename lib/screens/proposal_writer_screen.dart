import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/app_provider.dart';
import '../services/ai_service.dart';

class ProposalWriterScreen extends StatefulWidget {
  const ProposalWriterScreen({super.key});

  @override
  State<ProposalWriterScreen> createState() => _ProposalWriterScreenState();
}

class _ProposalWriterScreenState extends State<ProposalWriterScreen> {
  final _clientController = TextEditingController();
  final _projectController = TextEditingController();
  final _scopeController = TextEditingController();
  final _budgetController = TextEditingController();
  String _result = '';
  bool _loading = false;

  Future<void> _generate() async {
    if (_projectController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe the project')),
      );
      return;
    }
    setState(() { _loading = true; _result = ''; });
    final details = '''
Client: ${_clientController.text}
Project: ${_projectController.text}
Scope: ${_scopeController.text}
Budget Range: ${_budgetController.text.isNotEmpty ? _budgetController.text : 'Suggest appropriate pricing'}
''';
    final response = await AIService.generateProposal(details);
    setState(() { _result = response; _loading = false; });
    if (mounted) {
      context.read<AppProvider>().addDocument('proposal', 'Proposal - ${_projectController.text}', response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0f0d),
      appBar: AppBar(
        title: Text('Proposal Writer', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
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
                  Icon(Icons.description_rounded, color: const Color(0xFF22c55e)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Create a compelling business proposal that wins clients.',
                      style: GoogleFonts.inter(fontSize: 13, color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.1),
            const SizedBox(height: 24),
            _label('Client / Company'),
            const SizedBox(height: 8),
            TextField(controller: _clientController, style: GoogleFonts.inter(color: Colors.white),
              decoration: const InputDecoration(hintText: 'e.g., TechStart Inc.')),
            const SizedBox(height: 20),
            _label('Project Description *'),
            const SizedBox(height: 8),
            TextField(controller: _projectController, style: GoogleFonts.inter(color: Colors.white), maxLines: 3,
              decoration: const InputDecoration(hintText: 'Describe the project goals and deliverables')),
            const SizedBox(height: 20),
            _label('Scope of Work'),
            const SizedBox(height: 8),
            TextField(controller: _scopeController, style: GoogleFonts.inter(color: Colors.white), maxLines: 3,
              decoration: const InputDecoration(hintText: 'Key tasks, milestones, timeline')),
            const SizedBox(height: 20),
            _label('Budget Range'),
            const SizedBox(height: 8),
            TextField(controller: _budgetController, style: GoogleFonts.inter(color: Colors.white),
              decoration: const InputDecoration(hintText: 'e.g., \$10,000 - \$15,000')),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity, height: 56,
              child: ElevatedButton.icon(
                onPressed: _loading ? null : _generate,
                icon: _loading ? const SizedBox(width: 20, height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black)) : const Icon(Icons.auto_awesome),
                label: Text(_loading ? 'Generating...' : 'Generate Proposal'),
              ),
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _label('Generated Proposal'),
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
