
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:food_serving_app/utils/app.dart';
import 'package:food_serving_app/utils/color_res.dart';
import 'package:food_serving_app/utils/styles.dart';
import 'package:get/get.dart';



class BottomBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onContinue;

  BottomBar({this.onBack, @required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [


        ],
      ),
    );
  }
}

class GreenButton extends StatelessWidget {

  final String title;
  final VoidCallback onTap;
  final double width;
  final double height;

  GreenButton({@required this.title, @required this.onTap, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(),
    );
  }
}
class CommonButton extends StatelessWidget {
  final String text;
  final double width;
  final TextAlign textAlign;

CommonButton(this.text,this.width,this.textAlign);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      width: width,
      

      decoration: BoxDecoration(
        boxShadow:[
          BoxShadow(
            color: ColorRes.blue.withOpacity(0.3),offset: const Offset(5.0, 5.0),blurRadius: 1.0, spreadRadius: 2.0
          )
        ],
          color: ColorRes.blue.withOpacity(0.70),
        borderRadius: BorderRadius.circular(18)
      ),
      child: Text(text,textAlign: textAlign,style: AppTextStyle(textColor: ColorRes.white,size: 20,weight: FontWeight.bold),),
    );
  }
}

class CommonContainer extends StatelessWidget {
  final double height;
  final String text;
  final Color color;
  final double width;
  CommonContainer({this.height,this.text,this.color,this.width});


  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
        height: height,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(20)),
        child: Center(
            child: Text(text,style: TextStyle(color: color==null?ColorRes.black:ColorRes.blue,),)));
  }
}
class CommonBtn extends StatefulWidget {
  @required
  final String btnText;
  final VoidCallback onButtonPressed;
  final IconData icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color iconColor;
  final EdgeInsetsGeometry padding;
  final Size height;
  final Size width;
  final TextStyle textStyle;
  final double borderRadius;
  final bool isIconAvailable;
  final int fontSize;

  CommonBtn(
      {this.btnText,
        this.onButtonPressed,
        this.icon,
        this.backgroundColor,
        this.borderColor,
        this.textColor,
        this.padding,
        this.height,
        this.width,
        this.textStyle,
        this.borderRadius,
        this.iconColor,
        this.isIconAvailable, this.fontSize});

  @override
  _CommonButtonState createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonBtn> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onButtonPressed,
      child: Container(
        margin: EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(color: widget.backgroundColor ?? widget.backgroundColor)
        ),
        child: Padding(
          padding: widget.padding,
          child: widget.isIconAvailable ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.btnText,
                style: TextStyle(color: widget.textColor, fontSize: widget.fontSize.toDouble(),fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 8,
              ),
              Icon(
                widget.icon,
                color: widget.iconColor,
                size: 20,
              ) ,
            ],
          ) : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.btnText,
                style: TextStyle(color: widget.textColor, fontSize: widget.fontSize.toDouble(),fontWeight: FontWeight.bold),
              ),
            ],
          ) ,
        ),
      ),
    );

  }
}


class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType textInputType;
  final bool obscureText;
  final Widget prefix;
  final Widget suffix;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onChanged;
  final FormFieldSetter<String> onSaved;
  final String initialValue;
  final bool isPassword;
  final FocusNode focusNode;
  List<TextInputFormatter> inputFormatters;
  GestureTapCallback onTap;


  CommonTextField(
      {this.controller,
        this.textInputType,
        this.icon,
        this.hintText,
        this.obscureText = false,
        this.prefix,
        this.suffix,
        this.onChanged,
        this.onSaved,
        this.initialValue,
        this.isPassword = false,
        this.validator,this.focusNode,this.inputFormatters,this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: false,
      focusNode: focusNode,
      initialValue: initialValue,
      obscureText: obscureText,
      keyboardType: textInputType,
      decoration: InputDecoration(
          prefixIcon: prefix,
          hintText: hintText,

          suffixIcon: suffix,
          prefixIconConstraints: BoxConstraints(
              maxHeight: 60,
              maxWidth: 60,
              minWidth: 22
          ),
          hintStyle: TextStyle(fontSize: 14, color: ColorRes.grey)),
      validator: validator,
      onChanged: onChanged,
      onSaved: onSaved,
      inputFormatters: inputFormatters,
      onTap: onTap,
    );
  }
}
class ToastUtils {
  static void showSuccess({@required String message}) {
    BotToast.showCustomNotification(
      duration: Duration(seconds: 3),
      toastBuilder: (cancelFunc) {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Card(
            elevation: 15,
            color: Colors.green[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/icons/success_toast.png",
                    height: 30,
                    width: 30,
                    color: Colors.white,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: AppRes.success,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            text: message,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void showError({@required String message}) {
    BotToast.showCustomNotification(
      duration: Duration(seconds: 3),
      toastBuilder: (cancelFunc) {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Card(
            elevation: 15,
            color: Colors.red[400],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/icons/failure_toast.png",
                    height: 30,
                    width: 30,
                    color: Colors.white,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: AppRes.error,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            text: message,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
class Loader {
  void showLoader(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
              ),
              Center(
                child: CircularProgressIndicator(),
              )
            ],
          ),
        );
      },
    );
  }

  void hideLoader(BuildContext context) {
    Navigator.of(context, rootNavigator: false).pop();
  }
}