import 'package:Dhyaa/constant.dart';
import 'package:Dhyaa/models/appointment.dart';
import 'package:Dhyaa/screens/student/verifyPayment.dart';
import 'package:Dhyaa/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:moyasar_payment/model/paymodel.dart';
import 'package:moyasar_payment/model/source/creditcardmodel.dart';
import 'package:moyasar_payment/moyasar_payment.dart';

class PaymentPage extends StatefulWidget {
  final Appointment appointmentData;
  final dynamic userData;
  final dynamic myUserData;
  const PaymentPage({super.key, required this.appointmentData, this.userData, this.myUserData});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  // Variables
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

// Functions
// initiates the payment process with a credit card.
// It uses the MoyasarPayment class to make a payment request and waits for the response.
// The payment request includes various parameters.
  byCard() async {
    PayModel res = await MoyasarPayment().creditCard(
      description: ' درس',
      amount: double.parse(widget.appointmentData.amount),
      publishableKey: moyasarAPIKey,
      cardHolderName: cardHolderName,
      cardNumber: cardNumber.replaceAll(' ', ''),
      cvv: int.parse(cvvCode),
      expiryManth: int.parse(expiryDate.split('/')[0]),
      expiryYear: int.parse(expiryDate.split('/')[1]),
      callbackUrl: 'https://google.com',
    );
 // If the payment request is successful, the response will contain the payment details.
// Otherwise, an error message will be returned.
    if (res.type != null) {
      print(res.message);
    } else {
// If the payment is successful, extract the payment details and navigate to the next screen.
      CreditcardModel cardModel = CreditcardModel.fromJson(res.source);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => VerifyPayment(
            url: cardModel.transactionUrl, // URL for payment verification
            appointmentData: widget.appointmentData, // appointment details
            myUserData:widget.myUserData, // details of student
            userData:widget.userData, // details of the the tutor 
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
          actions: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              margin: EdgeInsets.only(right: 20),
              child: Image.asset('assets/icons/DhyaaLogo.png', height: 40),
            ),
          ],
        ),
        body: Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            children: [
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                bankName: 'الدفع الالكتروني',
                labelExpiredDate: 'شهر/عام',
                labelCardHolder: 'رقم البطاقة',
                showBackView: isCvvFocused,
                obscureCardNumber: true,
                obscureCardCvv: true,
                isHolderNameVisible: true,
                cardBgColor: kBlueColor,
                isSwipeGestureEnabled: true,
                onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      CreditCardForm(
                        formKey: formKey,
                        obscureCvv: true,
                        obscureNumber: false,
                        cardNumber: cardNumber,
                        cvvCode: cvvCode,
                        isHolderNameVisible: true,
                        isCardNumberVisible: true,
                        isExpiryDateVisible: true,
                        cardHolderName: cardHolderName,
                        expiryDate: expiryDate,
                        themeColor: kBlueColor,
                        numberValidationMessage: 'الرجاء إدخال رقم صحيح',
                        dateValidationMessage: 'الرجاء إدخال تاريخ صالح',
                        cvvValidationMessage: 'الرجاء إدخال رمز CVV صالح',
                        cardNumberDecoration: InputDecoration(
                          labelText: 'رقم البطاقة',
                          hintText: 'XXXX XXXX XXXX XXXX',
                          hintStyle: TextStyle(fontFamily: 'cr'),
                          labelStyle: TextStyle(fontFamily: 'cr'),
                          focusedBorder: border,
                          enabledBorder: border,
                        ),
                        expiryDateDecoration: InputDecoration(
                          hintStyle: TextStyle(fontFamily: 'cr'),
                          labelStyle: TextStyle(fontFamily: 'cr'),
                          focusedBorder: border,
                          enabledBorder: border,
                          labelText: 'تاريخ الانتهاء',
                          hintText: 'XX/XX',
                        ),
                        cvvCodeDecoration: InputDecoration(
                          hintStyle: TextStyle(fontFamily: 'cr'),
                          labelStyle: TextStyle(fontFamily: 'cr'),
                          focusedBorder: border,
                          enabledBorder: border,
                          labelText: 'الارقام السريه CVV',
                          hintText: 'XXX',
                        ),
                        cardHolderDecoration: InputDecoration(
                          hintStyle: TextStyle(fontFamily: 'cr'),
                          labelStyle: TextStyle(fontFamily: 'cr'),
                          focusedBorder: border,
                          enabledBorder: border,
                          labelText: 'إسم صاحب البطاقة',
                        ),
                        onCreditCardModelChange: onCreditCardModelChange,
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.mainColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Center(
                            child: Text(
                              'ادفع الآن',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (formKey.currentState!.validate()) {
                            byCard();
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.black,
                              thickness: 1,
                            ),
                          ),
                          SizedBox(width: 20),
                          Text('البطاقات المدعومة'),
                          SizedBox(width: 20),
                          Expanded(
                            child: Divider(
                              color: Colors.black,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Image.asset('assets/images/supportedCards.png'),
                      )
                    ],
                  ),
                ),
              ),
            ],
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
}
