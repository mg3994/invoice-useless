import 'dart:convert';
import 'dart:io';

import 'package:fast_inspection/utils/multiselect_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../constants/colors.dart';
import '../constants/constant_values.dart';
import '../constants/fonts.dart';

class HallwayRoomWidget extends HookWidget {
  HallwayRoomWidget({
    super.key,

  });


  List<String> kitchenList = [
    'Satisfactory',
    'Minor defect',
    'Major defect',
    'N/A',
    'No access',
  ];

  List<String> hallwayDefectList = [
    "High moisture level detected in wall. I recommend services of a licenced plumber for advice.",
    "Floor is bouncy in places. Caused by movement of sub floor piers and footings. . Specialist advice required.",
    "Rising damp is evident to walls in places. Caused by failed damp proof membrane and poor sub floor ventilation. Specialist advice required.",
    "Mild cracking is evident to walls and/or ceiling in places.  Generally caused by reactive soil, movement of sub floor piers and footings. Is non structural but should be monitored for change going forward.",
    "Major cracking is evident to walls and/ or ceiling in places. Is a structural issue. Recommend to contact a structural engineer for advice.",
    "Door is binding on frame/floor. Caused by general movement of sub floor piers and footings. Specialist advice required.",
    "Window is binding on frame. Caused by general movement of sub floor piers and footings. Specialist advice required.",
    "Windows have been painted closed.",
    "Window sash cords are missing/damaged in places. Installation of new shash cords required.",
    "Windows do not meet current 125mm restricted opening regulations. Caution with children.",
    "Carpet is in poor condition. Requires repair/replacement.",
    "Doors do not close/lock correctly Maintenance is required.",
    "Windows do not close/lock correctly. Maintenance is required.",
    "Ceiling is sagging. Caused by weight of plaster and/or incorrect installation. Repairs are required.",

  ];
  @override
  Widget build(BuildContext context) {
       Future<List<String>> getImage() async {
      final ImagePicker picker = ImagePicker();
      XFile? image;
      List<XFile?> images;
      List<String> listPath = [];
      await showInDialog(context,
          contentPadding: const EdgeInsets.all(0),
          builder: (context) => SizedBox(
              height: 300,
              width: 300,
              child: Column(
                children: [
                  Container(
                    height: 190,
                    width: 500,
                    color: AppColors.primaryColor.withOpacity(0.3),
                    child: const Icon(
                      Icons.image_outlined,
                      size: 100,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Please pick where you want to pick the image',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  20.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          images = await picker.pickMultiImage();
                          for (XFile? value in images) {
                            if (value != null) {
                              listPath.add(value.path);
                            }
                          }
                          context.pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(10), // radius of 10
                              color: AppColors
                                  .primaryColor // green as background color
                              ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.camera_alt_outlined,
                                size: 25,
                                color: Colors.white,
                              ),
                              5.width,
                              const Text(
                                'Gallery',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          image = await picker.pickImage(
                              maxHeight: 200,
                              maxWidth: 200,
                              source: ImageSource.camera);
                          if (image != null) {
                            listPath.add(image!.path);
                          }

                          context.pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(10), // radius of 10
                              color: AppColors
                                  .primaryColor // green as background color
                              ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.camera,
                                size: 25,
                                color: Colors.white,
                              ),
                              5.width,
                              const Text(
                                'Camera',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )),
          dialogAnimation: DialogAnimation.SLIDE_BOTTOM_TOP);
      // print(image?.path ?? "");
      return listPath;
    }

  /*    Future<String> getImage() async {
      final ImagePicker picker = ImagePicker();
      XFile? image;
      await showInDialog(context,
          contentPadding: const EdgeInsets.all(0),
          builder: (context) => SizedBox(
              height: 300,
              width: 300,
              child: Column(
                children: [
                  Container(
                    height: 190,
                    width: 500,
                    color: AppColors.primaryColor.withOpacity(0.3),
                    child: const Icon(
                      Icons.image_outlined,
                      size: 100,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Please pick where you want to pick the image',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  20.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          image = await picker.pickImage(
                              source: ImageSource.gallery);
                          context.pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(10), // radius of 10
                              color: AppColors
                                  .primaryColor // green as background color
                              ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.camera_alt_outlined,
                                size: 25,
                                color: Colors.white,
                              ),
                              5.width,
                              const Text(
                                'Gallery',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          image = await picker.pickImage(
                              source: ImageSource.camera);
                          context.pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(10), // radius of 10
                              color: AppColors
                                  .primaryColor // green as background color
                              ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.camera,
                                size: 25,
                                color: Colors.white,
                              ),
                              5.width,
                              const Text(
                                'Camera',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )),
          dialogAnimation: DialogAnimation.SLIDE_BOTTOM_TOP);
      print(image?.path ?? "");
      return image?.path ?? "";
    }
 */

    final imageChange = useState(true);
    //propery facade
    final newImageList =
        useState(getStringAsync(k5Hallway1Picture, defaultValue: ''));
    List<String> listman = newImageList.value.split('J@^J');
    listman.removeWhere(
        (element) => element == 'J@^J' || element.trim().isEmptyOrNull);
    final imageList = useState<List<String>>(listman);
    // property

/* 
    final image2 =
        useState(getStringAsync(k5Hallway1Picture, defaultValue: ''));
 */
    final bathTiles = useState(
        getStringAsync(k5Hallway1WallTiles, defaultValue: 'Satisfactory'));
    final bathFloor = useState(
        getStringAsync(k5Hallway1FloorTiles, defaultValue: 'Satisfactory'));
    final bathVanity = useState(
        getStringAsync(k5Hallwayroom1Vanity, defaultValue: 'Satisfactory'));
    final bathShower = useState(
        getStringAsync(k5Hallway1Shower, defaultValue: 'Satisfactory'));
    final bathWaste = useState(
        getStringAsync(k5Hallway1FloorWaste, defaultValue: 'Satisfactory'));
    final bathDoor =
        useState(getStringAsync(k5Hallway1Door, defaultValue: 'Satisfactory'));
    final bathWindow = useState(
        getStringAsync(k5Hallway1Window, defaultValue: 'Satisfactory'));

    final noteHallway = useTextEditingController(
        text: getStringAsync(k5Hallway1Note, defaultValue: ''));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      width: double.maxFinite,
      color: const Color(0xff39A78E).withOpacity(0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*  if (index != 1)
            GestureDetector(
              onTap: () => showConfirmDialog(context, 'Delete Hallway $index',
                  positiveText: 'Delete', negativeText: 'Cancel', onAccept: () {
                onTapAction();
              }),
              child: const Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.cancel_outlined,
                  color: Colors.red,
                ),
              ),
            ), */
          const Text(
            'Hallway/Foyer etc ',
            style: TextStyle(
                fontSize: 16,
                fontFamily: AppFonts.nunitoSansRegular,
                fontWeight: FontWeight.w700),
          ),
          /*   const Text(
            'Pictures',
            style: TextStyle(
                fontSize: 14,
                fontFamily: AppFonts.nunitoSansRegular,
                fontWeight: FontWeight.w700),
          ), */
          const Gap(10),
          const Gap(20),
          const Text(
            'Walls',
            style: TextStyle(
                fontSize: 12,
                fontFamily: AppFonts.nunitoSansRegular,
                fontWeight: FontWeight.w700),
          ),
          const Gap(10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
            decoration: BoxDecoration(
                color: const Color(0xff96C8A2).withOpacity(0.5),
                borderRadius: BorderRadius.circular(5)),
            child: DropdownButton<String>(
              value: bathTiles.value,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey,
              ),
              //SvgPicture.asset(AppAsset.arrowDown, color: const Color(0xff000000),),
              dropdownColor: Colors.white,
              elevation: 16,
              isExpanded: true,
              hint: const Text(
                'Walls',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: AppFonts.nunitoSansLight,
                  color: Colors.black,
                ),
              ),
              style: const TextStyle(
                fontSize: 14,
                fontFamily: AppFonts.nunitoSansLight,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
              underline: const SizedBox(),
              onChanged: (value) {
                bathTiles.value = value!;
                setValue(k5Hallway1WallTiles, value);
                /*  setState(() {
                      bathTiles = value;
                    }); */
              },
              items: kitchenList.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: AppFonts.nunitoSansLight,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const Gap(20),
          const Text(
            'Floor',
            style: TextStyle(
                fontSize: 12,
                fontFamily: AppFonts.nunitoSansRegular,
                fontWeight: FontWeight.w700),
          ),
          const Gap(10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
            decoration: BoxDecoration(
                color: const Color(0xff96C8A2).withOpacity(0.5),
                borderRadius: BorderRadius.circular(5)),
            child: DropdownButton<String>(
              value: bathFloor.value,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey,
              ),
              //SvgPicture.asset(AppAsset.arrowDown, color: const Color(0xff000000),),
              dropdownColor: Colors.white,
              elevation: 16,
              isExpanded: true,
              hint: const Text(
                'Building and pest',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: AppFonts.nunitoSansLight,
                  color: Colors.black,
                ),
              ),
              style: const TextStyle(
                fontSize: 14,
                fontFamily: AppFonts.nunitoSansLight,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
              underline: const SizedBox(),
              onChanged: (value) {
                bathFloor.value = value!;
                setValue(k5Hallway1FloorTiles, value);
                /*  setState(() {
                      bathFloor = value;
                    }); */
              },
              items: kitchenList.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: AppFonts.nunitoSansLight,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const Gap(20),
          const Text(
            'Windows',
            style: TextStyle(
                fontSize: 12,
                fontFamily: AppFonts.nunitoSansRegular,
                fontWeight: FontWeight.w700),
          ),
          const Gap(10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
            decoration: BoxDecoration(
                color: const Color(0xff96C8A2).withOpacity(0.5),
                borderRadius: BorderRadius.circular(5)),
            child: DropdownButton<String>(
              value: bathVanity.value,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey,
              ),
              //SvgPicture.asset(AppAsset.arrowDown, color: const Color(0xff000000),),
              dropdownColor: Colors.white,
              elevation: 16,
              isExpanded: true,
              hint: const Text(
                'Windows',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: AppFonts.nunitoSansLight,
                  color: Colors.black,
                ),
              ),
              style: const TextStyle(
                fontSize: 14,
                fontFamily: AppFonts.nunitoSansLight,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
              underline: const SizedBox(),
              onChanged: (value) {
                bathVanity.value = value!;
                setValue(k5Hallwayroom1Vanity,
                    value); /* setState(() {
                      bathVanity = value;
                    }); */
              },
              items: kitchenList.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: AppFonts.nunitoSansLight,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const Gap(20),
          const Text(
            'Door',
            style: TextStyle(
                fontSize: 12,
                fontFamily: AppFonts.nunitoSansRegular,
                fontWeight: FontWeight.w700),
          ),
          const Gap(10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
            decoration: BoxDecoration(
                color: const Color(0xff96C8A2).withOpacity(0.5),
                borderRadius: BorderRadius.circular(5)),
            child: DropdownButton<String>(
              value: bathShower.value,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey,
              ),
              //SvgPicture.asset(AppAsset.arrowDown, color: const Color(0xff000000),),
              dropdownColor: Colors.white,
              elevation: 16,
              isExpanded: true,
              hint: const Text(
                'Door',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: AppFonts.nunitoSansLight,
                  color: Colors.black,
                ),
              ),
              style: const TextStyle(
                fontSize: 14,
                fontFamily: AppFonts.nunitoSansLight,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
              underline: const SizedBox(),
              onChanged: (value) {
                bathShower.value = value!;
                setValue(k5Hallway1Shower, value);
                /* setState(() {
                      bathShower = value;
                    }); */
              },
              items: kitchenList.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: AppFonts.nunitoSansLight,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const Gap(20),
          const Text(
            'Ceiling',
            style: TextStyle(
                fontSize: 12,
                fontFamily: AppFonts.nunitoSansRegular,
                fontWeight: FontWeight.w700),
          ),
          const Gap(10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
            decoration: BoxDecoration(
                color: const Color(0xff96C8A2).withOpacity(0.5),
                borderRadius: BorderRadius.circular(5)),
            child: DropdownButton<String>(
              value: bathWaste.value,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey,
              ),
              //SvgPicture.asset(AppAsset.arrowDown, color: const Color(0xff000000),),
              dropdownColor: Colors.white,
              elevation: 16,
              isExpanded: true,
              hint: const Text(
                'Ceiling',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: AppFonts.nunitoSansLight,
                  color: Colors.black,
                ),
              ),
              style: const TextStyle(
                fontSize: 14,
                fontFamily: AppFonts.nunitoSansLight,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
              underline: const SizedBox(),
              onChanged: (value) {
                bathWaste.value = value!;
                setValue(k5Hallway1FloorWaste, value);
                /*  setState(() {
                      bathWaste = value;
                    }); */
              },
              items: kitchenList.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: AppFonts.nunitoSansLight,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const Gap(20),
         
         /*  const Text(
            'Door',
            style: TextStyle(
                fontSize: 12,
                fontFamily: AppFonts.nunitoSansRegular,
                fontWeight: FontWeight.w700),
          ),
          const Gap(10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
            decoration: BoxDecoration(
                color: const Color(0xff96C8A2).withOpacity(0.5),
                borderRadius: BorderRadius.circular(5)),
            child: DropdownButton<String>(
              value: bathDoor.value,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey,
              ),
              //SvgPicture.asset(AppAsset.arrowDown, color: const Color(0xff000000),),
              dropdownColor: Colors.white,
              elevation: 16,
              isExpanded: true,
              hint: const Text(
                'Building and pest',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: AppFonts.nunitoSansLight,
                  color: Colors.black,
                ),
              ),
              style: const TextStyle(
                fontSize: 14,
                fontFamily: AppFonts.nunitoSansLight,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
              underline: const SizedBox(),
              onChanged: (value) {
                bathDoor.value = value!;
                setValue(k5Hallway1Door, value);
                /*  setState(() {
                      bathDoor = value;
                    }); */
              },
              items: kitchenList.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: AppFonts.nunitoSansLight,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const Gap(20),
          const Text(
            'Window',
            style: TextStyle(
                fontSize: 12,
                fontFamily: AppFonts.nunitoSansRegular,
                fontWeight: FontWeight.w700),
          ),
          const Gap(10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
            decoration: BoxDecoration(
                color: const Color(0xff96C8A2).withOpacity(0.5),
                borderRadius: BorderRadius.circular(5)),
            child: DropdownButton<String>(
              value: bathWindow.value,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey,
              ),
              //SvgPicture.asset(AppAsset.arrowDown, color: const Color(0xff000000),),
              dropdownColor: Colors.white,
              elevation: 16,
              isExpanded: true,
              hint: const Text(
                'Building and pest',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: AppFonts.nunitoSansLight,
                  color: Colors.black,
                ),
              ),
              style: const TextStyle(
                fontSize: 14,
                fontFamily: AppFonts.nunitoSansLight,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
              underline: const SizedBox(),
              onChanged: (value) {
                bathWindow.value = value!;
                setValue(k5Hallway1Window, value);
                /* setState(() {
                      bathWindow = value;
                    }); */
              },
              items: kitchenList.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: AppFonts.nunitoSansLight,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const Gap(20), */
          const Text(
            'Pictures',
            style: TextStyle(
                fontSize: 14,
                fontFamily: AppFonts.nunitoSansRegular,
                fontWeight: FontWeight.w700),
          ),
          Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
                color: const Color(0xff96C8A2).withOpacity(0.5),
                borderRadius: BorderRadius.circular(5)),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                   /*  image2.value = await getImage() ?? '';
                    setValue(k5Hallway1Picture, image2.value); */
                     List<String> path = await getImage();

                        path.addAll(imageList.value);
                        String addedString = '';
                        for (String vlist in path) {
                          addedString = "${addedString}J@^J$vlist";
                        }

                        imageChange.value = false;
                        imageList.value.clear();
                        imageList.value.addAll(path);

                        setValue(k5Hallway1Picture, addedString);
                        imageChange.value = true;
                  },
                  child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15),
                          child: Text(
                            'Upload',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: AppFonts.nunitoSansRegular),
                          ),
                        ),
                      ),
                ),
               /*  if (!image2.value.trim().isEmptyOrNull)
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.file(
                      File(image2.value),
                      height: 100,
                      width: 100,
                    ),
                  ) */

                    if (imageList.value.isNotEmpty && imageChange.value)
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            ...imageList.value.map((e) {
                              print(e);
                              print(e);
                              return e == 'J@^J'.trim() || e.trim().isEmpty
                                  ? Container()
                                  : Column(
                                      children: [
                                        ListTile(
                                          leading: SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: Image.file(
                                              File(e),
                                              height: 100,
                                              width: 100,
                                            ),
                                          ),
                                          trailing: GestureDetector(
                                            onTap: () {
                                              imageList.value.remove(e);
                                              String addedString = '';
                                              for (String vlist
                                                  in imageList.value) {
                                                addedString =
                                                    "${addedString}J@^J$vlist";
                                              }

                                              imageList.value = imageList.value;

                                              setValue(
                                                  k5Hallway1Picture, addedString);
                                              imageChange.value = false;
                                              imageChange.value = true;
                                            },
                                            child: const Icon(
                                              Icons.cancel_outlined,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                        const Divider()
                                      ],
                                    );
                            })
                          ],
                        ),
                      )
                 
              ],
            ),
          ),
          const Gap(20),
          // MultiSelectDropdown.simpleList(
          //   list: kitchenDefectList,
          //   initiallySelected: jsonDecode(sharedPreferences.getString("k5Kitchen1Defects$listValue").toString()) ?? [],
          //   onChange: (newList) {
          //     sharedPreferences.setString('k5Kitchen1Defects$listValue', jsonEncode(newList));
          //     debugPrint("----------> ${jsonDecode(sharedPreferences.getString("k5Kitchen1Defects$listValue").toString())}");
          //   },
          //   isLarge: true,
          //   numberOfItemsLabelToShow: 0,
          //
          //   width: double.infinity,
          //   boxDecoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(5),
          //       color: const Color(0xff96C8A2).withOpacity(0.5)),
          //   whenEmpty: "Select defects",
          // ),
          const Text(
            'Defect Notes',
            style: TextStyle(fontSize: 12, fontFamily: AppFonts.nunitoSansRegular, fontWeight: FontWeight.w700),
          ),
          const Gap(10),
          MultiSelectDropdown.simpleList(
            list: hallwayDefectList,
            initiallySelected: jsonDecode(sharedPreferences.getString("k5hallway1Defects").toString()) ?? [],
            onChange: (newList) {
              sharedPreferences.setString('k5hallway1Defects', jsonEncode(newList));
              debugPrint("----------> ${jsonDecode(sharedPreferences.getString("k5hallway1Defects").toString())}");

            },
            isLarge: true,
            numberOfItemsLabelToShow: 0,

            width: double.infinity,
            boxDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color(0xff96C8A2).withOpacity(0.5)),
            whenEmpty: "Select defects",
          ),
          const Gap(20),
          const Text(
            'Notes',
            style: TextStyle(
                fontSize: 12,
                fontFamily: AppFonts.nunitoSansRegular,
                fontWeight: FontWeight.w700),
          ),
          const Gap(10),
          Container(
            decoration: BoxDecoration(
                //color: Colors.white,
                borderRadius: BorderRadius.circular(5)),
            child: TextFormField(
              controller: noteHallway,
              maxLines: 4,
              keyboardType: TextInputType.name,
              //controller: _firstName,
              //textInputAction: TextInputType.emailAddress,
              cursorWidth: 0.5,
              cursorColor: AppColors.primaryColor.withOpacity(0.1),
              onChanged: (value) {
                setValue(k5Hallway1Note, value);
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Email field cannot be empty';
                }
                return null;
              },

              style: const TextStyle(
                  fontSize: 18,
                  fontFamily: AppFonts.nunitoSansRegular,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: AppColors.primaryColor, width: 0.2),
                  borderRadius: BorderRadius.circular(5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: AppColors.primaryColor, width: 0.2),
                  borderRadius: BorderRadius.circular(5),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                hintStyle: const TextStyle(
                    fontFamily: AppFonts.nunitoSansRegular,
                    fontSize: 14,
                    color: Color(0xff4E4E4E)),
                hintText: 'Type something',
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
