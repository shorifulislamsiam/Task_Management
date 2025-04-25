import"package:flutter/material.dart";

class obsecure{

  bool _isobsecure = true;
  bool get isobsecure=>_isobsecure;
  void toggleObsecure(){
    _isobsecure =!_isobsecure;
  }

  obsecureText(VoidCallback onPressedCallback){

    return IconButton(
      icon: Icon(
        _isobsecure
            ? Icons.visibility_off
            : Icons.visibility,
      ),
      onPressed: onPressedCallback
    );
  }
}