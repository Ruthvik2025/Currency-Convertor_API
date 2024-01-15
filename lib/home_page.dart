import 'package:currency_con/components/any_to_any.dart';
import 'package:currency_con/components/usd_to_any.dart';
import 'package:currency_con/models/latest_rates.dart';
import 'package:currency_con/services/remote_service.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Initial Variables

  late Future<RatesModel> result;
  late Future<Map> allcurrencies;
  final formkey = GlobalKey<FormState>();

  //Getting RatesModel and All Currencies
  @override
  void initState() {
    super.initState();
    setState(() {
      result = fetchrates();
      allcurrencies = fetchcurrencies();
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(title: Text('Open Exchange Flutter')),

        //Future Builder for Getting Exchange Rates
        body: Container(
          height: h,
          width: w,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/currency.jpeg'),
                  fit: BoxFit.cover)),
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: FutureBuilder<RatesModel>(
                future: result,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return Center(
                    child: FutureBuilder<Map>(
                        future: allcurrencies,
                        builder: (context, currSnapshot) {
                          if (currSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              UsdToAny(
                                currencies: currSnapshot.data!,
                                rates: snapshot.data!.rates,
                              ),
                              AnyToAny(
                                currencies: currSnapshot.data!,
                                rates: snapshot.data!.rates,
                              ),
                            ],
                          );
                        }),
                  );
                },
              ),
            ),
          ),
        ));
  }
}
