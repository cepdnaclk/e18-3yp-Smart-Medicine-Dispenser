import 'package:dispensa/screens/roots.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';



class Splash extends StatefulWidget {
  

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState(){
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[400],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.network("https://assets1.lottiefiles.com/packages/lf20_9voc0tca.json",
          controller: _controller,
          onLoaded: (compos){
            _controller
            ..duration = compos.duration
            ..forward().then((value) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Root()  ));
            },);
          }  ),
          Center(
          child: Text("Dispensa",style: TextStyle(fontSize: 40,fontStyle: FontStyle.italic,),),
          ),
        ],
      ),
      );

  }
}