import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard.dart';

class PaymentCardPage extends StatefulWidget {
  late DateTime? getData;
  final int priceTotal;
  PaymentCardPage({
    Key? key,
    required this.getData,
    required this.priceTotal,
  }) : super(key: key);

  @override
  State<PaymentCardPage> createState() => PaymentCardPageState();
}

class PaymentCardPageState extends State<PaymentCardPage> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[900],
          title: Text("Payment", style: GoogleFonts.lato()),
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
            image: !useBackgroundImage
                ? const DecorationImage(
                    image: ExactAssetImage('lib/assets/images/bg.png'),
                    fit: BoxFit.fill,
                  )
                : null,
            color: Colors.black,
          ),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                CreditCardWidget(
                  glassmorphismConfig:
                      useGlassMorphism ? Glassmorphism.defaultConfig() : null,
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName.toUpperCase(),
                  cvvCode: cvvCode,
                  showBackView: isCvvFocused,
                  obscureCardNumber: true,
                  obscureCardCvv: true,
                  isHolderNameVisible: true,
                  cardBgColor: Colors.blueGrey,
                  backgroundImage: useBackgroundImage
                      ? 'lib/assets/images/card_bg.png'
                      : null,
                  isSwipeGestureEnabled: true,
                  onCreditCardWidgetChange:
                      (CreditCardBrand creditCardBrand) {},
                  customCardTypeIcons: <CustomCardTypeIcon>[
                    CustomCardTypeIcon(
                      cardType: CardType.mastercard,
                      cardImage: Image.asset(
                        'lib/assets/images/mastercard.png',
                        height: 48,
                        width: 48,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        CreditCardForm(
                          formKey: formKey,
                          obscureCvv: true,
                          obscureNumber: true,
                          cardNumber: cardNumber,
                          cvvCode: cvvCode,
                          isHolderNameVisible: true,
                          isCardNumberVisible: true,
                          isExpiryDateVisible: true,
                          cardHolderName: cardHolderName,
                          expiryDate: expiryDate,
                          themeColor: Colors.blue,
                          textColor: Colors.white,
                          cardNumberDecoration: InputDecoration(
                            labelText: 'Number',
                            hintText: 'XXXX XXXX XXXX XXXX',
                            hintStyle: const TextStyle(color: Colors.white),
                            labelStyle: const TextStyle(color: Colors.white),
                            focusedBorder: border,
                            enabledBorder: border,
                          ),
                          expiryDateDecoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.white),
                            labelStyle: const TextStyle(color: Colors.white),
                            focusedBorder: border,
                            enabledBorder: border,
                            labelText: 'Expired Date',
                            hintText: 'XX/XX',
                          ),
                          cvvCodeDecoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.white),
                            labelStyle: const TextStyle(color: Colors.white),
                            focusedBorder: border,
                            enabledBorder: border,
                            labelText: 'CVV',
                            hintText: 'XXX',
                          ),
                          cardHolderDecoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.white),
                            labelStyle: const TextStyle(color: Colors.white),
                            focusedBorder: border,
                            enabledBorder: border,
                            labelText: 'Card Holder',
                          ),
                          onCreditCardModelChange: onCreditCardModelChange,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            primary: const Color(0xff1b447b),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(12),
                            child: const Text(
                              'Validate',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'halter',
                                fontSize: 14,
                                package: 'flutter_credit_card',
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              print('valid!');
                              sendData();
                              currentIndex = 1;

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Dashboard()));
                            } else {
                              print('invalid!');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  sendData() async {
    print("Sending Data.....");
    final Map<String, dynamic> data = new Map<String, dynamic>();
    final prefs = await SharedPreferences.getInstance();

    var endDateTime = widget.getData?.add(Duration(hours: 1));
    data['totalPayment'] = widget.priceTotal;
    data['startDate'] = widget.getData;
    data['endDate'] = endDateTime;
    data['createdDate'] = DateTime.now().toString();
    data['userEmail'] = user.email;
    data['userId'] = prefs.getString('userId');
    data['futsalId'] = prefs.getString('futsalId');
    data['courtId'] = prefs.getString('courtId');
    data['futsalTitle'] = prefs.getString('futsalTitle');

    // data['bookId'] = "inspect(data)";
    String id = FirebaseFirestore.instance.collection('Posts').doc().id;
    try {
      print("post created");
      // ignore: avoid_single_cascade_in_expression_statements
      FirebaseFirestore.instance
        ..collection("UserData")
            .doc(user.email)
            .collection('Booked')
            .doc(id)
            .set({
          "paymentTotal": widget.priceTotal,
          "startDate": widget.getData,
          'endDate': endDateTime,
          'createdDate': DateTime.now().toString(),
          'userEmail': user.email,
          'userId': prefs.getString('userId'),
          'futsalId': prefs.getString('futsalId'),
          'courtId': prefs.getString('courtId'),
          'futsalTitle': prefs.getString('futsalTitle'),
          'bookId': id,
        });
      // ignore: avoid_single_cascade_in_expression_statements
      FirebaseFirestore.instance.collection("BookedListFromUser").doc(id).set({
        "paymentTotal": widget.priceTotal,
        "startDate": widget.getData,
        'endDate': endDateTime,
        'createdDate': DateTime.now().toString(),
        'userEmail': user.email,
        'userId': prefs.getString('userId'),
        'futsalId': prefs.getString('futsalId'),
        'courtId': prefs.getString('courtId'),
        'futsalTitle': prefs.getString('futsalTitle'),
        'bookId': id,
      });
    } catch (e) {
      print(e);
    }
  }
}
