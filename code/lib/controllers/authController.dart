import 'package:dispensa/config.dart';
import 'package:dispensa/screens/home/home.dart';
import 'package:dispensa/screens/sign_in/localWidget/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import '../screens/roots.dart';

class AuthController extends GetxController{
  var displayName = '';

  FirebaseAuth auth = FirebaseAuth.instance;
  var isSignedIn = false.obs;
  User? get userProfile => auth.currentUser;
  
  @override
  void onInit(){
    displayName = userProfile!= null ? userProfile!.displayName! : '';
    super.onInit();
  }

  void signUp(String name,String email,String password) async{
    try{
      await auth.createUserWithEmailAndPassword(
        email: email, password: password).then((value){
          displayName = name;
          auth.currentUser!.updateDisplayName(name);
        });
        update();
        Get.offAll(() => SignIn());
    }on FirebaseAuthException catch(e){
      String title = e.code.replaceAll(RegExp('-'),' ').capitalize!;
      String message = '';

      if(e.code == 'weak-password'){
        message = 'The password provided is too weak';
      } else if(e.code == 'email-already-in-use'){
        message = 'The account already exists for that email.';
      }else{
        message = e.message.toString(); 
      }

      Get.snackbar(title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: kPrimaryColor,
        colorText: kBackgroundColor);
    }
    catch (e){
      Get.snackbar('Error occured!',e.toString(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: kPrimaryColor,colorText: kBackgroundColor);
    }
  }

  void signIn(String email,String password) async{
    try{
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => displayName = userProfile!.displayName!);

      update();  
      Get.offAll(() => Root());
    }on FirebaseAuthException catch(e){
      String title = e.code.replaceAll(RegExp('-'),' ').capitalize!;
      String message = '';

      if(e.code == 'wrong-password'){
        message = 'Invalid password. Please try again!';
      } else if(e.code == 'user-not-found'){
        message = 'The account does not exists for $email. Create your account by signing up.';
      }else{
        message = e.message.toString(); 
      }

      Get.snackbar(title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: kPrimaryColor,
        colorText: kBackgroundColor);
    }
    catch (e){
      Get.snackbar('Error occured!',e.toString(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: kPrimaryColor,colorText: kBackgroundColor);
    }
  }

  void signOut() async{
    try{
      await auth.signOut();
      displayName = '';
      isSignedIn.value = false;
      update();
      Get.offAll(() => Root());
    }catch (e){
      Get.snackbar('Error occured!', e.toString(),
       snackPosition: SnackPosition.BOTTOM,
      backgroundColor: kPrimaryColor,
      colorText: kBackgroundColor);
    }
  }
}
extension StringExtension on String {
  String capitalizeString() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}