// import 'package:flutter/material.dart';
// import 'package:comat_apps/ui/constant.dart';
// import 'dart:ui' as ui;

// class EventCategory extends StatefulWidget {
//   final Color colorStart;
//   final Color colorEnd;
//   final String title;
//   final String keys;
//   final String where;
//   final dynamic value;
//   const EventCategory({
//     Key key, this.colorStart, this.colorEnd, this.title, this.keys, this.value, this.where
//   }) : super(key: key);

//   @override
//   _EventCategoryState createState() => _EventCategoryState();
// }

// class _EventCategoryState extends State<EventCategory> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(top: 15, right: 15, left: 15),
//       child: Stack(
//         children: [
//           Stack(
//             children: [
//               Container(
//                 height: 50,
//                 width: 90,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(borderRadius),
//                   gradient: LinearGradient(
//                     colors: [
//                       widget.colorStart, widget.colorEnd
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: widget.colorStart,
//                       blurRadius: 12,
//                       offset: Offset(0,1)
//                     )
//                   ]
//                 ),
//                 child: Material(
//                   color: Colors.transparent,
//                   borderRadius: BorderRadius.circular(borderRadius),
//                   child: InkWell(
//                     onTap: () {
//                       setState(() {
//                         "key" => widget.keys;
//                       });
//                     },
//                     highlightColor: widget.colorStart,
//                     borderRadius: BorderRadius.circular(borderRadius),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 right: 0,
//                 bottom: 0,
//                 top: 0,
//                 child: CustomPaint(
//                   painter: CustomCardShapePainter(radius: 15, startColor: widget.colorStart, endColor: widget.colorEnd),
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 15, left: 10),
//                     child: Text(
//                       widget.title, 
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500
//                       ),
//                     ),
//                   )
//                 ],
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

