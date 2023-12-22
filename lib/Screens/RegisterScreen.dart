import 'package:carpool_demo/Models/CustomInputFormField.dart';
import 'package:carpool_demo/Models/CustomLoggerPrinter.dart';
import 'package:carpool_demo/Models/DatabaseController.dart';
import 'package:carpool_demo/Models/CustomDialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final logger = getCustomLogger(RegisterScreen);

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final DatabaseReference firebaseDatabase = FirebaseDatabase.instance.ref();

  DatabaseController databaseController = DatabaseController();

  TextEditingController nameController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool emailException = false;
  bool passwordException = false;

  GlobalKey<FormState> formKey = GlobalKey();

  Future<bool> handleRegister() async {
    try{
      showLoadingDialog(context, 'Creating Account');
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: "user_${emailController.text}", 
        password: passwordController.text
      );
      await firebaseDatabase.child("users/${userCredential.user?.uid}").set({
        "FullName": nameController.text,
        "Phone": phoneController.text
      });
      await databaseController.insert(
        'INSERT INTO USERS ("EMAIL", "FullName", "Phone") VALUES ("user_${emailController.text}", "${nameController.text}", "${phoneController.text}")'
      );
      Navigator.pop(context);
      return true;
    } on FirebaseAuthException catch (exception){
      if (exception.code == 'weak-password') {
        passwordException = true;
      } 
      else if (exception.code == 'email-already-in-use') {
        emailException = true;
      }
      logger.e(exception.message);
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
                  SizedBox(height: screenHeight * .10),
                  SizedBox(
                    width: screenWidth*0.85,
                    child: Text("Create An Account", style: TextStyle(color: Colors.white, fontSize: 32, fontFamily: GoogleFonts.openSans().fontFamily)),
                  ),
                  SizedBox(height: screenHeight * .02),
                  SizedBox(
                    width: screenWidth*0.85,
                    child: Text("Please Fill in The Fields Below", style: TextStyle(color: const Color(0xff706C7A), fontSize: 18, fontFamily: GoogleFonts.openSans().fontFamily)),
                  ),
                  SizedBox(height: screenHeight * .05),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        buildCustomInputFormField(context, "Full Name", nameController, "", (value){
                          if(nameController.text.isEmpty){
                            return 'Field Cannot Be Empty!';
                          }
                          return null;
                        }),
                        SizedBox(height: screenHeight * .04),
                        buildCustomInputFormField(context, "Phone", phoneController, "phone", (value){
                          if(phoneController.text.isEmpty){
                            return 'Field Cannot Be Empty!';
                          }
                          else if(!RegExp(r'\+?[(]?[0-9]{3}?[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$').hasMatch(phoneController.text)){
                            return 'Phone Number has Incorrect Format!';
                          }
                          return null;
                        }),
                        SizedBox(height: screenHeight * .04),
                        buildCustomInputFormField(context, "Email", emailController, "email", (value){
                          if(emailController.text.isEmpty){
                            return 'Field Cannot Be Empty!';
                          }
                          else if(!RegExp(r'[1-9]\dp\d\d\d\d@eng\.asu\.edu\.eg').hasMatch(emailController.text)){
                            return 'Email has Incorrect Format!';
                          }
                          else if(emailException){
                            return 'Email is Already in Use!';
                          }
                          return null;
                        }),
                        SizedBox(height: screenHeight * .04),
                        buildCustomInputFormField(context, "Password", passwordController, "password", (value){
                          if(passwordController.text.isEmpty){
                            return 'Field Cannot Be Empty!';
                          }
                          else if(passwordException){
                            return 'Password is too Weak!';
                          }
                          return null;
                        }),
                      ],
                    )
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
                    onPressed: () async{
                      emailException = false;
                      passwordException = false;
                      if(formKey.currentState!.validate()){
                        if(await handleRegister()){
                          Navigator.pushNamed(context, "/MainScreen");
                        }
                        else{
                          if(formKey.currentState!.validate()){
                            Navigator.pushNamed(context, "/MainScreen");
                          }
                        }
                      }
                    }, 
                    child: Text("Sign Up", style: TextStyle(color: const Color(0xff1E1E32), fontFamily: GoogleFonts.openSans().fontFamily))
                  ),
                  SizedBox(height: screenHeight * .02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already Have an Account?", style: TextStyle(color: Colors.white, fontFamily: GoogleFonts.openSans().fontFamily)),
                      TextButton(
                        onPressed: (){
                          Navigator.popAndPushNamed(context, "/Login");
                        },
                        child: 
                          Text(" Sign In", style: TextStyle(color: const Color(0xff0DF5E3), fontFamily: GoogleFonts.openSans().fontFamily)),
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