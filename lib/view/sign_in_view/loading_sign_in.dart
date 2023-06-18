import 'package:on_the_road/Services/map_services.dart';
import 'package:on_the_road/view_model/sign_in_view_model.dart';
import 'package:provider/provider.dart';
import '../../model/location.dart';
import '../../model/user.dart';
import 'sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../home_view/home.dart';
import '../user_view/Admin.dart';


class LoadingSignIn extends StatefulWidget {
  final String name;
  final String password;
  const LoadingSignIn({
    super.key,
    required this.name,
    required this.password,
  });
  @override
  State<LoadingSignIn> createState() => _LoadingSignInState();
}

class _LoadingSignInState extends State<LoadingSignIn> {
  User user = User();
  @override
  void initState() {
    super.initState();
    signIn(widget.name, widget.password);
  }
  pushToAdminScreen(User user){
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) {
          return Admin(user: user);
        }));
  }
  pushToHome(User user){
    constants.customizeBitmap();
    Provider.of<User>(context, listen: false).updateUser(user);
    print(Provider.of<User>(context, listen: false).email);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Home();
        },
      ),
    );
  }
  pushToSignUp(){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const SignInScreen(
            signedIn: "failed",
          );
        },
      ),
    );
  }
  void signIn(String name, String password) async{
    SignInViewModel signIn = SignInViewModel();
    User user = await signIn.getUserInformation(name, password);
    MapServices services = MapServices();

    if (user.exist) {
      if (user.isAdmin) {
        pushToAdminScreen(user);
      } else {


        Location currentLocation = Location();
        await services.getCurrentLocation();

        currentLocation.longitude = services.long;
        currentLocation.latitude = services.lat;
        user.location = currentLocation;

        pushToHome(user);

      }
    } else {
      pushToSignUp();
    }
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SpinKitPulse(
          color: Colors.black54,
          size: 70,
        ),
      ),
    );
  }
}
