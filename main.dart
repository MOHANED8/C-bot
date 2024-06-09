// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:async';
import 'package:cbot/firebase_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

import 'package:firebase_auth/firebase_auth.dart';

class RoomTask {
  final String unit;
  final int floor;
  final int room;
  final String duration;

  RoomTask(
      {required this.unit,
      required this.floor,
      required this.room,
      required this.duration});
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Use the Firebase Authentication Emulator in development mode
  if (const bool.fromEnvironment('dart.vm.product') == false) {
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Signup Demo',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isProcessing = false;

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        color: const Color(0xFF123456),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30),
              Center(
                child: Image.asset('images/c-bot.png', width: 120),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _isProcessing
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            _login(context);
                          }
                        },
                  child: _isProcessing
                      ? const CircularProgressIndicator()
                      : const Text('Login'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupPage()),
                ),
                child: const Text('Don\'t have an account? Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    setState(() => _isProcessing = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log in: ${e.message}')),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void setState(Function() param0) {}
}

class SignupPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController srinamController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _isProcessing = false;

  SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signup')),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        color: const Color(0xFF123456),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 30),
                Center(
                  child: Image.asset('images/c-bot.png', width: 120),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: srinamController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    labelText: 'Srinam',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Srinam';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    labelText: 'Password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    labelText: 'Confirm Password',
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        passwordController.text != value) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: _isProcessing
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              _signup(context);
                            }
                          },
                    child: _isProcessing
                        ? const CircularProgressIndicator()
                        : const Text('Sign Up'),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signup(BuildContext context) async {

}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Home'),
        backgroundColor: Color(0xFF123456),
      ),
      backgroundColor: const Color(0xFF123456),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Image.asset('images/c-bot.png'),
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                children: <Widget>[
                  _buildButton(
                    context,
                    icon: CupertinoIcons.house_fill,
                    label: 'My Spaces',
                    route: MySpacesRoute(),
                    backgroundColor: CupertinoColors.white,
                  ),
                  const SizedBox(width: 10),
                  _buildButton(
                    context,
                    icon: CupertinoIcons.game_controller_solid,
                    label: 'Manual Controller',
                    route: const ManualControllerRoute(),
                    backgroundColor: CupertinoColors.white,
                  ),
                  const SizedBox(width: 10),
                  _buildButton(
                    context,
                    icon: CupertinoIcons.doc_chart_fill,
                    label: 'My Reports',
                    route: const MyReportsRoute(roomTask: null),
                    backgroundColor: CupertinoColors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildButton(
  BuildContext context, {
  required IconData icon,
  required String label,
  required Widget route,
  required Color backgroundColor,
}) {
  return Expanded(
    child: CupertinoButton(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF123456)),
          Text(label, style: const TextStyle(color: Color(0xFF123456))),
        ],
      ),
      onPressed: () => Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => route),
      ),
    ),
  );
}

class MySpacesRoute extends StatelessWidget {
  MySpacesRoute({super.key});

  final TextEditingController unitController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController roomController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Room Task Details'),
        backgroundColor: CupertinoColors.systemGrey,
      ),
      backgroundColor:
          const Color(0xFF123456), // Assuming dark blue background color
      child: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            constraints:
                const BoxConstraints(maxWidth: 600), // Adjust width as needed
            child: SingleChildScrollView(
              // Use a SingleChildScrollView to avoid overflow when keyboard appears
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                        'images/c-bot.png'), // Replace with the actual path to your image
                  ),
                  const SizedBox(height: 32),
                  _buildLabeledInputField(context,
                      label: 'Unit',
                      placeholder: '',
                      icon: CupertinoIcons.building_2_fill),
                  const SizedBox(height: 16), // Space between input fields
                  Row(
                    children: [
                      Expanded(
                        child: _buildLabeledInputField(context,
                            label: 'Floor',
                            placeholder: '',
                            icon: CupertinoIcons.arrow_up_down),
                      ),
                      const SizedBox(
                          width: 16), // Space between input fields in Row
                      Expanded(
                        child: _buildLabeledInputField(context,
                            label: 'Room',
                            icon: CupertinoIcons.number,
                            placeholder: ''),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // Space between input fields
                  _buildLabeledInputField(context,
                      label: 'Recommended Duration',
                      placeholder: '5 min',
                      icon: CupertinoIcons.time_solid,
                      isStatic: true),
                  const SizedBox(height: 32), // Space before the button
                  Center(
                    child: CupertinoButton.filled(
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) =>
                                  const ManualControllerRoute()),
                        );
                      },
                      child: const Text('Start Disinfection'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledInputField(BuildContext context,
      {required String label,
      required String placeholder,
      required IconData icon,
      bool isStatic = false}) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 16.0), // Add space below each field
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
                color: CupertinoColors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          CupertinoTextField(
            placeholder: placeholder,
            prefix: Padding(
              padding: const EdgeInsets.fromLTRB(9.0, 6.0, 9.0, 6.0),
              child: Icon(icon, color: CupertinoColors.white),
            ),
            decoration: const BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            style: const TextStyle(color: CupertinoColors.black),
            enabled: !isStatic,
          ),
        ],
      ),
    );
  }
}

class ManualControllerRoute extends StatefulWidget {
  const ManualControllerRoute({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ManualControllerRouteState createState() => _ManualControllerRouteState();
}

class _ManualControllerRouteState extends State<ManualControllerRoute> {
  int countdownDuration = 300; // Initialize with the maximum value (5m)

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Manual Control'),
        backgroundColor: Color(0xFF123456),
      ),
      backgroundColor: const Color(0xFF123456),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Expanded(
              flex: 2, // Adjust flex factor to size the logo as needed
              child: Center(
                child: Image.asset(
                    'images/c-bot.png'), // Updated with the correct path
              ),
            ),
            const Positioned(
              left: 20,
              bottom: 20,
              child: Joystick(),
            ),
            const Positioned(
              right: 20,
              bottom: 20,
              child: ActionButtons(),
            ),
            Positioned(
              top: 20,
              child: CountdownTimer(duration: countdownDuration),
            ),
          ],
        ),
      ),
    );
  }
}

class CongratsRoute extends StatelessWidget {
  const CongratsRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFF00A36C),
      child: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset('images/c-bot.png'), // Your logo image
              const Text(
                'Congrats',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Disinfection finished successfully, you can open the door now. After being sure that UV lamps are off.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const Icon(
                CupertinoIcons.check_mark_circled_solid,
                color: Colors.white,
                size: 48,
              ),
              CupertinoButton(
                color: CupertinoColors.white,
                child: const Text('Back to Home',
                    style: TextStyle(color: Color(0xFF00A36C))),
                onPressed: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CountdownTimer extends StatefulWidget {
  final int duration;
  const CountdownTimer({super.key, required this.duration});

  @override
  // ignore: library_private_types_in_public_api
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late int remainingTime;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    remainingTime = widget.duration;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        timer.cancel();

        if (mounted) {
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => const CongratsRoute()));
        }
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int minutes = remainingTime ~/ 60;
    int seconds = remainingTime % 60;
    return Text(
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
        style: const TextStyle(fontSize: 24, color: Colors.white));
  }
}

class Joystick extends StatefulWidget {
  const Joystick({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _JoystickState createState() => _JoystickState();
}

class _JoystickState extends State<Joystick> {
  Offset position = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          position = details.localPosition;
          // Limit the control knob to the boundaries of the Joystick area
          position = Offset(
            position.dx.clamp(-50.0, 50.0),
            position.dy.clamp(-50.0, 50.0),
          );
        });
      },
      onPanEnd: (details) {
        setState(() {
          position = Offset.zero;
        });
      },
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Transform.translate(
            offset: position,
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LightBulbButton(),
      ],
    );
  }
}

class LightBulbButton extends StatefulWidget {
  const LightBulbButton({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LightBulbButtonState createState() => _LightBulbButtonState();
}

class _LightBulbButtonState extends State<LightBulbButton> {
  bool _isLightOn = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        setState(() {
          _isLightOn = !_isLightOn; // Toggle the light state
        });
      },
      padding: EdgeInsets.zero,
      child: Icon(
        _isLightOn
            ? CupertinoIcons.lightbulb_fill
            : CupertinoIcons.lightbulb_slash,
        size: 30,
        color: _isLightOn ? Colors.yellow : Colors.grey,
      ),
    );
  }
}

class MyReportsRoute extends StatelessWidget {
  final RoomTask? roomTask;

  const MyReportsRoute({super.key, this.roomTask}); // roomTask is now nullable

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('My Reports'),
      ),
      backgroundColor: const Color(0xFF123456),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: CupertinoColors.systemGrey,
              child: Row(
                children: [
                  buildHeader('Unit'),
                  buildHeader('Floor'),
                  buildHeader('Room'),
                  buildHeader('Duration'),
                ],
              ),
            ),
            // Check if roomTask is not null before displaying data
            if (roomTask != null)
              Row(
                children: [
                  buildCell(roomTask!.unit),
                  buildCell(roomTask!.floor as String),
                  buildCell(roomTask!.room as String),
                  buildCell(roomTask!.duration),
                ],
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoButton.filled(
                onPressed: () async {
                  if (roomTask != null) {
                    String filePath = await generatePdfReport(roomTask!);
                    sendEmailWithAttachment(filePath);
                  } else {
                    // Handle the case when roomTask is null
                  }
                },
                child: const Text('Send Report'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(String title) {
    return Expanded(
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: CupertinoColors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildCell(String content) {
    return Expanded(
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          border: Border.all(color: CupertinoColors.systemGrey),
        ),
        child: Text(
          content,
          style: const TextStyle(color: CupertinoColors.black),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

Future<String> generatePdfReport(RoomTask roomTask) async {
  final pdf = pw.Document();
  pdf.addPage(pw.Page(build: (pw.Context context) {
    return pw.Column(children: [
      pw.Text('Unit: ${roomTask.unit}'),
      pw.Text('Floor: ${roomTask.floor}'),
      pw.Text('Room: ${roomTask.room}'),
      pw.Text('Duration: ${roomTask.duration}'),
    ]);
  }));

  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/report.pdf');
  await file.writeAsBytes(await pdf.save());
  return file.path;
}

void sendEmailWithAttachment(String filePath) async {
  final Email email = Email(
    body: 'Attached is the generated report.',
    subject: 'Report PDF',
    recipients: ['example@gmail.com'], // The recipient's email address
    attachmentPaths: [filePath],
    isHTML: false,
  );

  await FlutterEmailSender.send(email);
}
