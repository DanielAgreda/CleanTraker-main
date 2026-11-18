import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/validators.dart';
import 'tracker_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<TrackerProvider>();
    bool success;

    if (_isLogin) {
      success = await provider.login(
        _emailController.text,
        _passwordController.text,
      );
    } else {
      success = await provider.register(
        _emailController.text,
        _passwordController.text,
      );
    }

    if (!mounted) return;
    if (success) {
      if (provider.selectedAddress != null) {
        context.go('/home');
      } else {
        context.go('/search-route');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Ocurrió un error'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<TrackerProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppTheme.mintBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Logo + Título idéntico a la imagen
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        color: AppTheme.creamHighlight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.local_shipping_outlined,
                        color: AppTheme.forestDark,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      'CleanTracker',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontSize: 30,
                            letterSpacing: -0.5,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'Te avisamos cuándo sacar tu basura.',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.forestMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 36),

                // Tarjeta blanca principal
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.forestDark.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Selector tipo Pill (Iniciar sesión | Registrarse)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppTheme.creamHighlight,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _isLogin = true),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: _isLogin ? Colors.white : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: _isLogin
                                          ? [
                                              BoxShadow(
                                                color: Colors.black.withValues(alpha: 0.06),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              )
                                            ]
                                          : null,
                                    ),
                                    child: Text(
                                      'Iniciar sesión',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: _isLogin ? FontWeight.bold : FontWeight.w500,
                                        color: _isLogin ? AppTheme.forestDark : AppTheme.forestMuted,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _isLogin = false),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: !_isLogin ? Colors.white : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: !_isLogin
                                          ? [
                                              BoxShadow(
                                                color: Colors.black.withValues(alpha: 0.06),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              )
                                            ]
                                          : null,
                                    ),
                                    child: Text(
                                      'Registrarse',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: !_isLogin ? FontWeight.bold : FontWeight.w500,
                                        color: !_isLogin ? AppTheme.forestDark : AppTheme.forestMuted,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        const Text(
                          'Correo electrónico',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.forestDark,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(hintText: 'nombre@correo.com'),
                          validator: Validators.email,
                        ),
                        const SizedBox(height: 18),

                        const Text(
                          'Contraseña',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.forestDark,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(hintText: 'Mínimo 8 caracteres'),
                          validator: Validators.password,
                        ),
                        const SizedBox(height: 26),

                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.forestDark,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            onPressed: isLoading ? null : _submit,
                            child: isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    _isLogin ? 'Iniciar sesión' : 'Crear cuenta',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        if (_isLogin) ...[
                          const SizedBox(height: 18),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Se enviará un enlace de recuperación a tu correo.'),
                                  ),
                                );
                              },
                              child: const Text(
                                '¿Olvidaste tu contraseña?',
                                style: TextStyle(
                                  color: AppTheme.forestMuted,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
