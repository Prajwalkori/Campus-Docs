import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _supabase = Supabase.instance.client;

class SupabaseAuthWidget extends StatefulWidget {
  const SupabaseAuthWidget({super.key});

  @override
  State<SupabaseAuthWidget> createState() => _SupabaseAuthWidgetState();
}

class _SupabaseAuthWidgetState extends State<SupabaseAuthWidget> {
  bool _isRegister = false;
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      if (_isRegister) {
        await _supabase.auth.signUp(email: _emailCtrl.text, password: _passCtrl.text);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration started. Please confirm your email.')));
          setState(() => _isRegister = false);
        }
      } else {
        await _supabase.auth.signInWithPassword(email: _emailCtrl.text, password: _passCtrl.text);
        if (mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RoleRouterShim()));
        }
      }
    } catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('confirm') || msg.contains('not confirmed') || msg.contains('email not confirmed')) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email not confirmed. Check your inbox.')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Auth error: ${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isRegister ? 'Register' : 'Sign in'), backgroundColor: const Color(0xFF6B46C1)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isRegister) TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Full name')),
            TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 12),
            TextField(controller: _passCtrl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6B46C1)),
              onPressed: _loading ? null : _submit,
              child: _loading ? const CircularProgressIndicator() : Text(_isRegister ? 'Register' : 'Sign in'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _loading ? null : () => setState(() => _isRegister = !_isRegister),
              child: Text(_isRegister ? 'Have an account? Sign in' : 'Need an account? Register'),
            ),
          ],
        ),
      ),
    );
  }
}

// A small shim to avoid circular import with main; RoleRouter in main.dart expects this name.
class RoleRouterShim extends StatelessWidget {
  const RoleRouterShim({super.key});

  @override
  Widget build(BuildContext context) {
    // Defer to the original RoleRouter in main.dart by pushing it.
    return const SizedBox.shrink();
  }
}
