import 'package:c4d/module_init/model/package/packages.model.dart';
import 'package:c4d/module_init/ui/screens/init_account_screen/init_account_screen.dart';
import 'package:c4d/module_init/ui/widget/package_card/package_card.dart';
import 'package:c4d/module_theme/service/theme_service/theme_service.dart';
import 'package:c4d/utils/project_colors/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

abstract class InitAccountState {
  final InitAccountScreenState screen;
  InitAccountState(this.screen);

  Widget getUI(BuildContext context);
}

class initAccountStateInit extends InitAccountState {
  initAccountStateInit(InitAccountScreenState screen) : super(screen) {
    screen.getPackages();
  }

  @override
  Widget getUI(BuildContext context) {
    return Text('Init Data');
  }
}

class InitAccountStateLoading extends InitAccountState {
  InitAccountStateLoading(screen) : super(screen);

  @override
  Widget getUI(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Loading')),
    );
  }
}

class InitAccountStateError extends InitAccountState {
  final String errorMsg;

  InitAccountStateError(
    this.errorMsg,
    InitAccountScreenState screen,
  ) : super(screen);

  @override
  Widget getUI(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(errorMsg),
      ),
    );
  }
}

class InitAccountStateSubscribeSuccess extends InitAccountState {
  InitAccountStateSubscribeSuccess(InitAccountScreenState screen)
      : super(screen);
  @override
  Widget getUI(BuildContext context) {
    return Scaffold();
  }
}

class InitAccountStatePackagesLoaded extends InitAccountState {
  List<PackageModel> packages;

  String _selectedCity;
  String _selectedSize;
  int _selectedPackageId;

  InitAccountStatePackagesLoaded(
    this.packages,
    InitAccountScreenState screen,
  ) : super(screen);
  @override
  Widget getUI(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //city
                  Container(
                    child: DropdownButtonFormField(
                        // value: _selectedCity,
                        decoration: InputDecoration(
                          hintText: 'Choose Your City',
                        ),
                        items: _getCities(),
                        onChanged: (value) {
                          _selectedCity = value;
                          screen.setState(() {});
                        }),
                  ),
                  //size
                  DropdownButtonHideUnderline(
                    child: DropdownButtonFormField(
                        value: _selectedSize,
                        decoration:
                            InputDecoration(hintText: 'Choose Your Size'),
                        items: _getSizes(),
                        onChanged: (value) {
                          _selectedCity = value;
                        }),
                  ),
                  //package
                  AnimatedContainer(
                    duration: Duration(microseconds: 500),
                    height: _selectedCity == null ? 0 : 275,
                    margin: EdgeInsets.only(top: 20),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _getPackages(),
                    ),
                  ),

                  // Submit Package
                  AnimatedContainer(
                    duration: Duration(microseconds: 500),
                    margin: EdgeInsets.only(top: 30),
                    height: _selectedPackageId == null ? 0 : 64,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      color: AppThemeDataService.PrimaryColor,
                      onPressed: () {
                        screen.subscribeToPackage(_selectedPackageId);
                      },
                      child: Text(
                        'CONTINUE',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getPackages() {
    if (packages == null) {
      return [];
    }
    if (packages.isEmpty) {
      return [];
    }
    if (_selectedCity == null) {
      return [];
    }

    return packages.map((element) {
      return GestureDetector(
        onTap: () {
          _selectedPackageId = element.id;
          screen.setState(() {});
        },
        child: Opacity(
          opacity: _selectedPackageId == element.id ? 0.5 : 1.0,
          child: PackageCard(
            package: element,
            active: element.id == _selectedPackageId,
          ),
        ),
      );
    }).toList();
  }

  List<DropdownMenuItem> _getCities() {
    var cityNames = <String>[];
    packages.forEach((element) {
      cityNames.add('${element.city}');
    });

    var cityDropDown = <DropdownMenuItem>[];
    cityNames.forEach((element) {
      cityDropDown.add(DropdownMenuItem(
        child: Text(element),
        value: element,
      ));
    });

    return cityDropDown;
  }

  List<DropdownMenuItem> _getSizes() {
    var sizeDropdowns = <DropdownMenuItem>[];
    sizeDropdowns.add(DropdownMenuItem(
      child: Text('Small'),
      value: 'sm',
    ));
    sizeDropdowns.add(DropdownMenuItem(
      child: Text('Medium'),
      value: 'md',
    ));
    sizeDropdowns.add(DropdownMenuItem(
      child: Text('Large'),
      value: 'lg',
    ));

    return sizeDropdowns;
  }
}
