import 'package:flutter/material.dart';
import 'package:voting_app/pages/Home.dart';
import 'package:voting_app/pages/Home1.dart';
import 'database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark , primaryColor: Colors.deepPurple ,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.deepPurple))) ,
        appBarTheme: AppBarTheme(elevation:  0),
      ),
      home: UserTypeSelectionPage(),
      // theme: ThemeData(
      //   appBarTheme: AppBarTheme(
      //     backgroundColor: const Color.fromARGB(255, 226, 33, 243),
      //   ),
      // ),
    );
  }
}

class UserTypeSelectionPage extends StatefulWidget {
  @override
  _UserTypeSelectionPageState createState() => _UserTypeSelectionPageState();
}

class _UserTypeSelectionPageState extends State<UserTypeSelectionPage> {
  void _selectUserType(String userType) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage(userType: userType)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Voting App"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Select User Type:", style: TextStyle(color: Colors.white, fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectUserType("Voter"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                backgroundColor: Colors.deepPurple,
              ),
              child: Text("Voter"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectUserType("Admin"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                backgroundColor: Colors.deepPurple,
              ),
              child: Text("Admin"),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  final String userType;

  LoginPage({required this.userType});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = "";

  Future<void> _login() async {
    final db = DatabaseHelper();
    await db.initDatabase();

    final email = emailController.text;
    final password = passwordController.text;

    final isValidCredentials = await db.checkCredentials(email, password);

    if (isValidCredentials) {
      if (widget.userType == "Admin") {
        // Navigate to the AdminDashboardPage for admin users
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboardPage()),
        );
      } else {
        // Navigate to the BlankPage for voter users
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BlankPage()),
        );
      }
    } else {
      setState(() {
        errorMessage = "Invalid credentials. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.userType} Login"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/2.jpeg', width: 450, height: 150),
            SizedBox(height: 20),
            TextField(
              controller: emailController, 
              decoration: InputDecoration(labelText: "Email ID"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              child: Text("Login as ${widget.userType}"),
            ),
            Text(errorMessage, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
/*
class AdminDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to the "Create Election" page (under progress)
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                backgroundColor: Colors.deepPurple,
              ),
              child: Text("Create New Election "),
            ),
            Text("\n") ,
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to the "Edit Election Details" page (under progress)
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                backgroundColor: Colors.deepPurple,
              ),
              child: Text("Edit Election Details"),
            ),
          ],
        ),
      ),
    );
  }
}
*/

class AdminDashboardPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Home() ;
  }
}
class BlankPage extends StatelessWidget {
  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text("Voter Page"),
  //       backgroundColor: Colors.deepPurple,
        
  //     ),
      
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Home1() ;
  }
}