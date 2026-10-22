import 'package:flutter/material.dart';

class ActiveAds extends StatefulWidget {
  const ActiveAds({super.key});

  @override
  State<ActiveAds> createState() => _ActiveAdsState();
}

class _ActiveAdsState extends State<ActiveAds> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("٤٬٢٨٠",style: TextStyle(fontSize: 19,color: Color(0xff6E5F50)),),
        Text(" إعلان نشط في شمال كردفان",style: TextStyle(fontSize: 19,color: Color(0xff6E5F50)),)
      ],
    );
  }
}