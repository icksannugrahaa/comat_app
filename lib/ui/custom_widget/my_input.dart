import 'package:flutter/material.dart';

class NormalInput extends StatefulWidget {
  NormalInput({
    Key key,
    this.isPassword,
    this.label,
    this.enable,
    this.hint,
    this.inputType,
    this.controller,
  }) : super(key: key);
  
  final String label;
  final bool isPassword;
  final TextInputType inputType;
  final String hint;
  final bool enable;
  final TextEditingController controller;

  @override
  _NormalInputState createState() => _NormalInputState();
}

class _NormalInputState extends State<NormalInput> {
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    print("checking ${widget.label}");
    return Padding(
      padding: const EdgeInsets.only(bottom:35.0),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        controller: widget.controller,
        obscureText: widget.isPassword ? showPassword : false,
        keyboardType: widget.inputType,
        enabled: widget.enable,
        maxLines: widget.isPassword ? 1 : null,
        validator: (value) {
          if(value.isEmpty || value == "") {
            return "Please input ${widget.label}";
          } else {
            if(widget.hint == "Email" && !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(value)) {
              return "Invalid Email !";
            } else {
              return null;
            }
          }
        },
        decoration: InputDecoration(
          suffixIcon: widget.isPassword ? IconButton(
            icon: Icon((showPassword ? Icons.visibility_off : Icons.visibility), color: Colors.grey,),
            onPressed: () {
              setState(() => showPassword = !showPassword );
            } 
          ) : null,
          contentPadding: EdgeInsets.only(bottom: 10),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: widget.label,
          hintText: widget.hint,
        ),
      ),
    );
  }
}