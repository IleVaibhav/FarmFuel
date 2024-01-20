import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Color darkGreen = Colors.green.shade900;
final lightBlue = Colors.blue.shade50;

var selectedLangCode = "eng";
var selectedLangName = "English";
Map<dynamic, dynamic> userData = {};

Widget backGroundTheme({required child}) {
  return Container(
    width: double.infinity,
    height: double.infinity,
    decoration: BoxDecoration(
        image: const DecorationImage(
            image: AssetImage("assets/logo/bg.png"),
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomCenter,
            opacity: 0.7
        ),
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade500,
              Colors.blue.shade300,
              Colors.grey.shade100,
              Colors.white,
              Colors.green.shade500
            ]
        )
    ),
    child: child,
  );
}

int listLengthDB({input}) {
  if(input.toString() == "[]") {
    return 0;
  }
  String listB = input.toString().replaceAll("[", "").replaceAll("]", "").replaceAll("\n", "").replaceAll(" ", "").toString();
  var b = (listB.split(','));
  return (b.length);
}

Widget customTextFormField({required controller,
                            required title,
                            required obsecure,
                            required errorText,
                            required icon,
                            required titleColor,
                            required keyBoard,
                            maxLines = 1
                          }) {
  return TextFormField(
    controller: controller,

    obscureText: obsecure,
    obscuringCharacter: "v",
    cursorColor: Colors.green.shade900,

    keyboardType: keyBoard,

    maxLines: maxLines,

    decoration: InputDecoration(
      contentPadding: const EdgeInsets.all(17),

      label: Text(
          title,
          style: TextStyle(
              fontSize: 15,
              color: titleColor
          )
      ),

      hintText: "$title . . .",
      hintStyle: const TextStyle(fontSize: 15,color: Colors.black38),

      errorStyle: TextStyle(color: Colors.red.shade900),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red.shade900,width: 1)
      ),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue.shade300,width: 1)
      ),

      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue.shade300,width: 1)
      ),

      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.green.shade900,width: 1)
      ),

      prefixIcon: Icon(icon, color: Colors.green.shade900),
    ),

    validator: (value) {
      if(value!.isEmpty) {
        return errorText;
      }
      return null;
    },
  );
}

void customToastMsg(String str) {
  Fluttertoast.showToast(
      msg: str,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: const Color.fromARGB(255, 103, 2, 2),
      textColor: Colors.blue.shade50,
      fontSize: 16.0
  );
}

Widget langButton({
                  required langName,
                  required langCode,
                  required onPressed
                }) {
  return Container(
    width: 200,
    height: 45,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
        border: Border.all(color: darkGreen, width: 0.5),
        gradient: LinearGradient(
            begin: Alignment.bottomRight,
            colors: [
              Colors.green.shade200,
              Colors.green.shade800
            ]
        ),
        borderRadius: BorderRadius.circular(10)
    ),
    child: TextButton(
      onPressed: onPressed,
      style: const ButtonStyle(
          overlayColor: MaterialStatePropertyAll(Colors.transparent)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              langName,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,fontSize: 18
              )
          ),
          Text(
              langCode,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,fontSize: 16
              )
          ),
        ],
      ),
    ),
  );
}

Widget goBack(context) {
  return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white)
  );
}

