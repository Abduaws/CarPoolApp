import 'package:carpool_demo/Models/CustomInputFormField.dart';
import 'package:carpool_demo/Models/CustomLoggerPrinter.dart';
import 'package:carpool_demo/Models/CustomDialogs.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final logger = getCustomLogger(LoginScreen);

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final DatabaseReference firebaseDatabase = FirebaseDatabase.instance.ref();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();

  bool exceptionFired = false;

  Future<bool> handleLogin() async {
    try{
    showLoadingDialog(context, 'Logging in');
    await firebaseAuth.signInWithEmailAndPassword(
      email: "user_${emailController.text}", password: passwordController.text);
    Navigator.pop(context);
    return true;
    } on FirebaseAuthException catch (exception){
      logger.e(exception.code);
      exceptionFired = true;
      Navigator.pop(context);
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff201A30),
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("Assets/Images/BackGroundPattern.png"), repeat: ImageRepeat.repeat)),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: screenHeight * .04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: screenWidth*0.05,),
                      GestureDetector(onTap: (){Navigator.pop(context);},child: const Icon(Icons.arrow_back, color: Colors.white, size: 32,)),
                    ],
                  ),
                  SizedBox(height: screenHeight * .05),
                  Image.asset(
                    'Assets/Images/LoginCarName.png',
                  ),
                  SizedBox(height: screenHeight * .05),
                  SizedBox(
                    width: screenWidth*0.85,
                    child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 32, fontFamily: GoogleFonts.openSans().fontFamily)),
                  ),
                  SizedBox(height: screenHeight * .02),
                  SizedBox(
                    width: screenWidth*0.85,
                    child: Text("Please Sign in To Continue", style: TextStyle(color: const Color(0xff706C7A), fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily)),
                  ),
                  SizedBox(height: screenHeight * .05),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        buildCustomInputFormField(context, "Email", emailController, "email", (value){
                          if(emailController.text.isEmpty){
                            return 'Field Cannot Be Empty!';
                          }
                          else if(!RegExp(r'[1-9]\dp\d\d\d\d@eng\.asu\.edu\.eg').hasMatch(emailController.text)){
                            return 'Email has Incorrect Format!';
                          }
                          else if(exceptionFired){
                            return 'Incorrect Email or Password!';
                          }
                          return null;
                        }),
                        SizedBox(height: screenHeight * .04),
                        buildCustomInputFormField(context, "Password", passwordController, "password", (value){
                          if(passwordController.text.isEmpty){
                            return 'Field Cannot Be Empty!';
                          }
                          else if(exceptionFired){
                            return 'Incorrect Email or Password!';
                          }
                          return null;
                        }),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * .04),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0DF5E3),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                      ),
                    onPressed: () async {
                      exceptionFired = false;
                      if(formKey.currentState!.validate()){
                        if(await handleLogin()){
                          Navigator.pushNamed(context, "/MainScreen");
                        }
                        else{
                          formKey.currentState!.validate();
                        }
                      }
                    }, 
                    child: Text("Login", style: TextStyle(color: const Color(0xff1E1E32), fontFamily: GoogleFonts.openSans().fontFamily))
                  ),
                  SizedBox(height: screenHeight * .02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't Have an Account?", style: TextStyle(color: Colors.white, fontFamily: GoogleFonts.openSans().fontFamily)),
                      TextButton(
                        onPressed: (){
                          Navigator.popAndPushNamed(context, "/Register");
                        },
                        child: 
                          Text(" Sign Up", style: TextStyle(color: const Color(0xff0DF5E3), fontFamily: GoogleFonts.openSans().fontFamily)),
                      ),
                    ],
                  )
                ]
              ),
            ),
          ),
        ),
    );
  }
}