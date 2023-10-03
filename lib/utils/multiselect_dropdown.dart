import 'dart:async';
import 'package:flutter/material.dart';

import '../constants/fonts.dart';

const double tileHeight = 50;
const double selectAllButtonHeight = 40;
const double searchOptionHeight = 40;

class MultiSelectDropdown extends StatefulWidget {
  final List list;
  final String label;
  final String id;
  final ValueChanged<List> onChange;
  final int numberOfItemsLabelToShow;
  final List initiallySelected;
  final Decoration? boxDecoration;
  final bool isLarge;
  final bool isSimpleList;
  final double? width;
  final String whenEmpty;
  final bool includeSelectAll;
  final bool includeSearch;
  final TextStyle textStyle;
  final Duration duration;
  final Color? checkboxFillColor;
  final Color? splashColor;
  final TextStyle? listTextStyle;
  final EdgeInsets? padding;

  const MultiSelectDropdown({
    super.key,
    required this.list,
    required this.initiallySelected,
    this.label = 'label',
    this.id = 'id',
    required this.onChange,
    this.numberOfItemsLabelToShow = 3,
    this.boxDecoration,
    this.width,
    this.whenEmpty = 'Select options',
    this.isLarge = false,
    this.includeSelectAll = false,
    this.includeSearch = false,
    this.textStyle = const TextStyle(fontSize: 15),
    this.duration = const Duration(milliseconds: 300),
    this.checkboxFillColor,
    this.splashColor,
    this.listTextStyle,
    this.padding,
  }) : isSimpleList = false;

  const MultiSelectDropdown.simpleList({
    super.key,
    required this.list,
    required this.initiallySelected,
    required this.onChange,
    this.numberOfItemsLabelToShow = 3,
    this.boxDecoration,
    this.width,
    this.whenEmpty = 'Select options',
    this.isLarge = false,
    this.includeSelectAll = false,
    this.includeSearch = false,
    this.textStyle = const TextStyle(
      fontSize: 14,
      fontFamily: AppFonts.nunitoSansLight,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    this.duration = const Duration(milliseconds: 300),
    this.checkboxFillColor,
    this.splashColor,
    this.listTextStyle = const TextStyle(
      fontSize: 14,
      fontFamily: AppFonts.nunitoSansLight,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    this.padding = const EdgeInsets.symmetric(horizontal: 15),
  })  : label = '',
        id = '',
        isSimpleList = true;

  @override
  State<MultiSelectDropdown> createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  late List selected = [...widget.initiallySelected];
  late final Decoration boxDecoration;
  List filteredOptions = [];

  late final TextEditingController filterController;
  Timer? debounce;

  bool isSelected(data) {
    if (widget.isSimpleList) {
      return selected.contains(data);
    } else {
      for (Map obj in selected) {
        if (obj[widget.id] == data) {
          return true;
        }
      }
      return false;
    }
  }

  void handleOnChange(bool newValue, dynamic data) {
    if (newValue) {
      setState(() {
        selected.add(data);
      });
    } else {
      if (widget.isSimpleList) {
        setState(() {
          selected.remove(data);
        });
      } else {
        int itemIndex = selected.indexWhere(
          (obj) => obj[widget.id] == data[widget.id],
        );
        if (itemIndex == -1) {
          return;
        } else {
          setState(() {
            selected.removeAt(itemIndex);
          });
        }
      }
    }

    widget.onChange(selected);
  }

  Widget buildTile(data) {
    if (selected.length <= 3) {
      if (widget.isSimpleList) {
        return _CustomTile(
          value: isSelected(data),
          onChanged: (bool newValue) {
            handleOnChange(newValue, data);
          },
          title: '$data',
          checkboxFillColor: widget.checkboxFillColor,
          splashColor: widget.splashColor,
          textStyle: widget.listTextStyle,
        );
      } else {
        return _CustomTile(
          value: isSelected(data[widget.id]),
          onChanged: (bool newValue) {
            handleOnChange(newValue, data);
          },
          title: '${data[widget.label]}',
          checkboxFillColor: widget.checkboxFillColor,
          splashColor: widget.splashColor,
          textStyle: widget.listTextStyle,
        );
      }
    } else {
      return _CustomTile(
        value: isSelected(data),
        onChanged: (bool newValue) {
          handleOnChange(false, data);
        },
        title: '$data',
        checkboxFillColor: widget.checkboxFillColor,
        splashColor: widget.splashColor,
        textStyle: widget.listTextStyle,
      );
    }
  }

  void onSearchTextChanged(String searchText) {
    if (debounce?.isActive ?? false) debounce?.cancel();

    debounce = Timer(widget.duration, () {
      if (searchText.isEmpty) {
        setState(() {
          filteredOptions = widget.list;
        });
      } else {
        searchText = searchText.toLowerCase();
        if (widget.isSimpleList) {
          List newList = widget.list.where((text) {
            return '$text'.toLowerCase().contains(searchText);
          }).toList();
          setState(() {
            filteredOptions = newList;
          });
        } else {
          List newList = widget.list.where((objData) {
            return '${objData[widget.label]}'.toLowerCase().contains(searchText);
          }).toList();
          setState(() {
            filteredOptions = newList;
          });
        }
      }
    });
  }

  Widget buildSearchOption() {
    return TextField(
      controller: filterController,
      onChanged: onSearchTextChanged,
      textAlignVertical: TextAlignVertical.center,
      decoration: const InputDecoration(
        isDense: true,
        border: OutlineInputBorder(),
        hintText: 'filter...',
        constraints: BoxConstraints(
          minHeight: searchOptionHeight,
          maxHeight: searchOptionHeight,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
      ),
    );
  }

  Widget buildSelectAllButton() {
    return InkWell(
      onTap: () {
        if (selected.length == widget.list.length) {
          selected.clear();
        } else {
          selected.clear();
          selected = [...widget.list];
        }
        widget.onChange(selected);
        setState(() {});
      },
      child: Container(
        height: selectAllButtonHeight,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey),
          ),
        ),
        child: const Text('Select all'),
      ),
    );
  }

  double getWidth(BoxConstraints boxConstraints) {
    if (widget.width != null && widget.width != double.infinity && widget.width != double.maxFinite) {
      return widget.width!;
    }
    if (boxConstraints.maxWidth == double.infinity || boxConstraints.maxWidth == double.maxFinite) {
      debugPrint("Invalid width given, MultiSelect Dropdown width will fallback to 250.");
      return 250;
    }
    return boxConstraints.maxWidth;
  }

  double getModalHeight() {
    double height = filteredOptions.length > 4
        ? widget.isLarge
            ? filteredOptions.length > 6
                ? 7 * tileHeight
                : filteredOptions.length * tileHeight
            : 5 * tileHeight
        : filteredOptions.length * tileHeight;

    if (widget.includeSelectAll) {
      height += selectAllButtonHeight;
    }

    if (widget.includeSearch) {
      height += searchOptionHeight;
    }

    return height;
  }

  String buildText() {
    if (selected.isEmpty) {
      return widget.whenEmpty;
    }

    if (widget.numberOfItemsLabelToShow < selected.length) {
      return '${widget.list[0]}';
    }

    if (widget.isSimpleList) {
      final int itemsToShow = selected.length;
      String finalString = "";
      for (int i = 0; i < itemsToShow; i++) {
        finalString = '$finalString ${selected[i]}, ';
      }
      return finalString.substring(0, finalString.length - 2);
    } else {
      final int itemsToShow = selected.length;
      String finalString = "";
      for (int i = 0; i < itemsToShow; i++) {
        finalString = '$finalString ${selected[i][widget.label]}, ';
      }
      return finalString.substring(0, finalString.length - 2);
    }
  }

  @override
  void initState() {
    super.initState();
    filterController = TextEditingController();
    filteredOptions = [...widget.list];
    boxDecoration = widget.boxDecoration ??
        BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        );
  }

  @override
  void dispose() {
    filterController.dispose();
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String textToShow = buildText();
    double modalHeight = getModalHeight();

    return LayoutBuilder(
      builder: (ctx, boxConstraints) {
        double modalWidth = getWidth(boxConstraints);

        return ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: modalWidth,
              minWidth: modalWidth,
              minHeight: tileHeight,
              maxHeight: selected.length == 1
                  ? 50
                  : selected.length == 2
                      ? 100
                      : selected.length == 3
                          ? 150
                          : selected.length == 4
                              ? 200
                              : 50),
          child: MenuAnchor(
            crossAxisUnconstrained: false,
            style: MenuStyle(
              fixedSize: MaterialStateProperty.resolveWith((states) {
                return Size(modalWidth, modalHeight);
              }),
              padding: MaterialStateProperty.resolveWith((states) {
                return EdgeInsets.zero;
              }),
            ),
            builder: (context, controller, _) {
              return InkWell(
                onTap: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 12),
                  decoration: boxDecoration,
                  width: modalWidth,
                  child: Row(
                    children: [
                      Expanded(
                        child: (selected.length == 0)
                            ? Text(
                                "Select defects",
                                style: TextStyle(color: Colors.black.withOpacity(0.5)),
                                overflow: TextOverflow.fade,
                                softWrap: false,
                              )
                            : ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: selected.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    width: MediaQuery.sizeOf(context).width / 2,
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                    margin: const EdgeInsets.fromLTRB(0, 7, 3, 7),
                                    decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          Text(
                                            selected[index],
                                            style: const TextStyle(color: Colors.white),
                                            overflow: TextOverflow.fade,
                                            softWrap: false,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                      const Icon(
                        Icons.expand_more_sharp,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              );
            },
            menuChildren: [
              if (widget.includeSearch) buildSearchOption(),
              if (widget.includeSelectAll) buildSelectAllButton(),
              ...filteredOptions.map((data) {
                return buildTile(data);
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}

// Simple list tiles in the modal
class _CustomTile extends StatelessWidget {
  const _CustomTile({
    required this.title,
    required this.value,
    required this.onChanged,
    this.checkboxFillColor,
    this.splashColor,
    this.textStyle,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  final Color? checkboxFillColor;
  final Color? splashColor;
  final TextStyle? textStyle;

  void handleOnChange() {
    if (value) {
      onChanged(false);
    } else {
      onChanged(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Column(
      children: [
        InkWell(
          splashColor: splashColor ?? themeData.primaryColor,
          hoverColor: Colors.black12,
          onTap: handleOnChange,
          child: Row(
            children: [
              // const SizedBox(width: 5),
              Checkbox(
                fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                  return value ? (checkboxFillColor ?? themeData.primaryColor ): Colors.transparent;
                }),
                value: value,
                onChanged: null,
              ),
              // const SizedBox(width: 3),
              Expanded(
                child: Text(
                  title,
                  style: textStyle,
                ),
              ),
              const SizedBox(width: 3)
            ],
          ),
        ),
        const Divider(
          height: 8,
          thickness: 0.8,
          indent: 12,
          endIndent: 12,
        )
      ],
    );
  }
}
