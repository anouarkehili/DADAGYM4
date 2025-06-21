import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _showRegistrationDialog(BuildContext context) {
    final nameController = TextEditingController();
    final surnameController = TextEditingController();
    final usernameController = TextEditingController();
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إنشاء حساب جديد'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'الاسم'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: surnameController,
                decoration: const InputDecoration(labelText: 'اللقب'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'اسم المستخدم'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'رقم الهاتف'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'كلمة المرور'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  // QR code registration logic
                },
                icon: const FaIcon(FontAwesomeIcons.qrcode),
                label: const Text('تسجيل باستخدام QR Code'),
              )
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final credential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                  email: "${usernameController.text}@example.com",
                  password: passwordController.text,
                );

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(credential.user!.uid)
                    .set({
                  'name': nameController.text,
                  'surname': surnameController.text,
                  'username': usernameController.text,
                  'phone': phoneController.text,
                  'createdAt': Timestamp.now(),
                });

                Navigator.of(context).pop();
              } catch (e) {
                print('Error: \$e');
              }
            },
            child: const Text('تسجيل'),
          ),
        ],
      ),
    );
  }

  void _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "${_usernameController.text}@example.com",
        password: _passwordController.text,
      );
      // Navigate to home
    } catch (e) {
      print('Login failed: \$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                '../../assets/images/logo.png',
                height: 160,
              ),
              const SizedBox(height: 32),

              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'اسم المستخدم',
                  prefixIcon: const Icon(Icons.person),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور',
                  prefixIcon: const Icon(Icons.lock),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'تسجيل الدخول',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showRegistrationDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blueAccent,
                    side: const BorderSide(color: Colors.blueAccent),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'إنشاء حساب جديد',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              Row(
                children: const [
                  Expanded(child: Divider(thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('أو تواصل معنا'),
                  ),
                  Expanded(child: Divider(thickness: 1)),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialIconButton(
                    icon: FontAwesomeIcons.whatsapp,
                    color: Colors.green,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 16),
                  SocialIconButton(
                    icon: FontAwesomeIcons.facebookF,
                    color: Colors.blue[800]!,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 16),
                  SocialIconButton(
                    icon: FontAwesomeIcons.tiktok,
                    color: Colors.black,
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const SocialIconButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: color.withOpacity(0.1),
      child: IconButton(
        icon: FaIcon(icon, color: color, size: 20),
        onPressed: onPressed,
      ),
    );
  }
}
