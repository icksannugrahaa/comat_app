import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  
  final String decorationImg;
  final String titleText;
  final String titleImage;
  final double imageWidth;
  final double textSize;
  final bool textOrImg;
  final bool online;
  final IconData icon;
  final scaffoldKey;

  Header({
    Key key,
    this.decorationImg,
    this.titleText,
    this.titleImage,
    this.imageWidth,
    this.textSize,
    this.textOrImg,
    this.icon,
    this.online,
    this.scaffoldKey
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyClipper(),
      child: Container(
        padding: EdgeInsets.only(top: 45, left: 20, right: 20),
        height: 350,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF3383CD),
              Color(0xFF11249F)
            ]
          ),
          image: textOrImg == false 
            ? DecorationImage(
            image: AssetImage("assets/images/bg_transparent.png")) 
            : DecorationImage(
            image: AssetImage("assets/images/bg_transparent.png")),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                child: Material(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.transparent,
                  child: IconButton(
                    splashRadius: 50,
                    icon: Icon(icon, color: Colors.white,),
                    onPressed: () => scaffoldKey != null ? scaffoldKey.currentState.openDrawer() : Navigator.pop(context),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Expanded(
              child: Stack(
                children: [
                  textOrImg == true 
                  ? Text(
                      titleText, 
                      style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600, fontSize: textSize
                      )
                    ) 
                  :
                    online 
                    ?
                      Center(
                        child: Image.network(
                          titleImage,
                          width: imageWidth,
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.topCenter,
                        ),
                      )
                    :
                      Center(
                        child: Image.asset(
                          titleImage,
                          width: imageWidth,
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
      size.width/2,
      size.height,
      size.width,
      size.height-80
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}