import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fox_mate_app/constants/custom_colors.dart';
import 'package:fox_mate_app/constants/spacing.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField({
    Key? key,
    required this.label,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.placeholder,
    this.validator,
    this.maxLines,
    this.prefixIcon,
    this.inputFormatters,
    this.onChanged,
  }) : super(key: key);

  String label;
  bool isPassword;
  TextInputType keyboardType;
  TextEditingController? controller;
  String? placeholder;
  String? Function(String?)? validator;
  int? maxLines;
  Icon? prefixIcon;
  List<TextInputFormatter>? inputFormatters;
  String? Function(String?)? onChanged;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscured = true;
  @override
  void initState() {
    super.initState();
    _isObscured = widget.isPassword;
  }

  toggleObscure() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),),
        SizedBox(height: 10),
        TextFormField(
          obscureText: _isObscured,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          validator: widget.validator,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            prefixIcon: widget.prefixIcon != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 18,bottom: 18,left:15), // 👈 Ajusta aquí el espacio interno del ícono
                        child: widget.prefixIcon,
                      )
                    : null,
            hintText: widget.placeholder,
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
            ),
            suffixIcon:
                widget.isPassword
                    ? Padding(
                      padding: EdgeInsets.only(right:10),
                      child: IconButton(
                        icon: Icon(
                          _isObscured ? Icons.visibility : Icons.visibility_off,
                          color: CustomColors.grayTextColor,
                        ),
                        onPressed: toggleObscure,
                      ),
                    )
                    : null,
          ),
          onChanged: widget.onChanged,
        ),
        
      ],
    )
    ;
  }
}