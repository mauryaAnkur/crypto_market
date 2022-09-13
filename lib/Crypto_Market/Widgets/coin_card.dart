// import 'package:flutter/material.dart';
//
// import '../Model/coin_model.dart';
//
// Widget coinCard(BuildContext context, Coin coin, Function()? onTap) {
//
//   double oldPrice = coin.coinLastPrice.isEmpty ? double.parse(coin.coinPrice) : double.parse(coin.coinLastPrice);
//   coin.coinLastPrice = coin.coinPrice;
//
//   final height = MediaQuery.of(context).size.height;
//   final width = MediaQuery.of(context).size.width;
//   return Column(
//     children: [
//       InkWell(
//         onTap: () {
//           onTap;
//         },
//         child: Container(
//           margin: EdgeInsets.symmetric(vertical: height * 0.003),
//           padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.014),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Image.network(coin.coinImage, height: width * 0.085, width: width * 0.085, fit: BoxFit.fill,
//                     errorBuilder: (context, error, stackTrace) =>
//                         Container(
//                           height: width * 0.083,
//                           width: width * 0.083,
//                           decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               border: Border.all(color: Colors.grey.shade400, width: 1)
//                           ),
//                           child: Center(
//                             child: Text(
//                                 coin.coinName.isEmpty
//                                     ? '-'
//                                     : coin.coinName[0]),
//                           ),
//                         ),
//                   ),
//                   SizedBox(width: width * 0.014,),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         width: width * 0.24,
//                         child: Row(
//                           children: [
//                             Text("${coin.coinShortName} / ", style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyText1!.color, fontWeight: FontWeight.w700),),
//                             Text(coin.coinPairWith, style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyText2!.color, fontWeight: FontWeight.w700),),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: height * 0.005,),
//                       Text(coin.coinName, style: TextStyle(color: Theme.of(context).textTheme.bodyText2!.color, fontSize: 10),)
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 width: width * 0.22,
//                 child: Text(
//                   coin.coinPairWith.toLowerCase() == 'inr'
//                       ? (double.parse(coin.coinPrice.toString()) * inrRate).toStringAsFixed(coin.coinDecimalPair)
//                       : double.parse(coin.coinPrice.toString()).toStringAsFixed(coin.coinDecimalPair),
//                   textAlign: TextAlign.end,
//                   maxLines: 1,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: double.parse(coin.coinPrice) > oldPrice ? Colors.lightGreen : double.parse(coin.coinPrice) < oldPrice ? Colors.red : Theme.of(context).textTheme.bodyText1!.color ,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//               Container(
//                 width: width * 0.16,
//                 height: height * 0.025,
//                 decoration: BoxDecoration(
//                   color: coin.coinPercentage.toString().startsWith('-') ? Colors.red : Colors.lightGreen,
//                   borderRadius: BorderRadius.circular(0),
//                 ),
//                 padding: const EdgeInsets.all(2),
//                 child: Center(child: FittedBox(child: Text('${coin.coinPercentage}%', style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700),))),
//                 //child: Text(percent + '%', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700),),
//               )
//             ],
//           ),
//         ),
//       ),
//     ],
//   );
// }