import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({required this.onPressed, required this.tittle, super.key});
  final String tittle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            colors: [
              Color(0xff0B20AA),
              Color(0xff041165),
            ]),
        borderRadius: BorderRadius.circular(30),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: Colors.transparent,
          elevation: 3,
          disabledForegroundColor: Colors.transparent.withOpacity(0.38),
          disabledBackgroundColor: Colors.transparent.withOpacity(0.12),
          shadowColor: Colors.transparent,
          fixedSize: const Size(260, 55),
        ),
        child: Text(
          tittle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "outfit2",
            fontSize: 25,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class CustomButton2 extends StatelessWidget {
  const CustomButton2({super.key, required this.tittle, required this.onPressed});
  final String tittle;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff009FE3).withOpacity(1),
        shape: const StadiumBorder(),
        disabledForegroundColor:
        const Color(0xff009FE3).withOpacity(1).withOpacity(0.38),
        disabledBackgroundColor:
        const Color(0xff009FE3).withOpacity(1).withOpacity(0.12),
        elevation: 3,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      ),
      child: Text(
        tittle,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
          letterSpacing: 1.2,
          color: Colors.white,
        ),
      ),
    );
  }
}