
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'color_category.dart';
import 'constant_widget.dart';

/// selection dialog used for selection of the country code
class SelectionDialog extends StatefulWidget {
  final List<CountryCode> elements;
  final bool? showCountryOnly;
  final InputDecoration searchDecoration;
  final TextStyle? searchStyle;
  final TextStyle? textStyle;
  final BoxDecoration? boxDecoration;
  final WidgetBuilder? emptySearchBuilder;
  final bool? showFlag;
  final double flagWidth;
  final Decoration? flagDecoration;
  final Size? size;
  final bool hideSearch;
  final Icon? closeIcon;

  /// Background color of SelectionDialog
  final Color? backgroundColor;

  /// Boxshaow color of SelectionDialog that matches CountryCodePicker barrier color
  final Color? barrierColor;

  /// elements passed as favorite
  final List<CountryCode> favoriteElements;

  SelectionDialog(
    this.elements,
    this.favoriteElements, {
    Key? key,
    this.showCountryOnly,
    this.emptySearchBuilder,
    InputDecoration searchDecoration = const InputDecoration(),
    this.searchStyle,
    this.textStyle,
    this.boxDecoration,
    this.showFlag,
    this.flagDecoration,
    this.flagWidth = 32,
    this.size,
    this.backgroundColor,
    this.barrierColor,
    this.hideSearch = false,
    this.closeIcon,
  })  : searchDecoration = searchDecoration.prefixIcon == null
            ? searchDecoration.copyWith(prefixIcon: const Icon(Icons.search))
            : searchDecoration,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectionDialogState();
}

class _SelectionDialogState extends State<SelectionDialog> {
  /// this is useful for filtering purpose
  late List<CountryCode> filteredElements;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: bgDark,
        body: SafeArea(
          child: ListView(
            children: [
              getVerSpace(50.h),
              Stack(alignment: Alignment.center, children: [
                getCustomFont("Select Country", 26.sp, Colors.white, 1,
                    fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: getSvgImage("arrow_back.svg",
                            width: 24.h, height: 24.h)))
              ]).paddingSymmetric(horizontal: 20.h),
              getVerSpace(40.h),
              widget.favoriteElements.isEmpty
                  ? const DecoratedBox(decoration: BoxDecoration())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...widget.favoriteElements.map(
                          (f) => SimpleDialogOption(
                            child: _buildOption(f),
                            onPressed: () {
                              _selectItem(f);
                            },
                          ),
                        ),
                        // const Divider(),
                      ],
                    ),
              if (filteredElements.isEmpty)
                _buildEmptySearchWidget(context)
              else
                ...filteredElements.map(
                  (e) => SimpleDialogOption(
                    child: _buildOption(e),
                    onPressed: () {
                      _selectItem(e);
                    },
                  ),
                )
            ],
          ),
        ),
      );

  Widget _buildOption(CountryCode e) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (widget.showFlag!)
                  Container(
                    height: 28.h,
                    width: 40.h,
                    margin: const EdgeInsets.only(right: 16.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.h),
                        image: DecorationImage(
                            image: AssetImage(
                              e.flagUri!,
                              package: 'country_code_picker',
                            ),
                            fit: BoxFit.fill)),
                    // clipBehavior: widget.flagDecoration == null
                    //     ? Clip.none
                    //     : Clip.hardEdge,
                    // child: Image.asset(
                    //   e.flagUri!,
                    //   package: 'country_code_picker',
                    //   width: 40.h,
                    //   height: 28.h,
                    //
                    // ),
                  ),
                Expanded(
                  flex: 1,
                  child: getCustomFont(
                      e.toCountryStringOnly(), 16.sp, hintColor, 1,
                      fontWeight: FontWeight.w400),
                ),
                getCustomFont(e.dialCode ?? "", 16.sp, hintColor, 1,
                    fontWeight: FontWeight.w400)
              ],
            ),
          ),
          getDivider(setColor: dividerColor)
        ],
      ),
    );
  }

  Widget _buildEmptySearchWidget(BuildContext context) {
    if (widget.emptySearchBuilder != null) {
      return widget.emptySearchBuilder!(context);
    }

    return Center(
      child: Text(CountryLocalizations.of(context)?.translate("no country") ??
          "no country found"),
    );
  }

  @override
  void initState() {
    filteredElements = widget.elements;
    super.initState();
  }

  void _selectItem(CountryCode e) {
    Get.back(result: e);
  }
}
