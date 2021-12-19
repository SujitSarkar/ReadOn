import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:read_on/controller/ebook_api_controller.dart';
import 'package:read_on/controller/public_controller.dart';
import 'package:read_on/eBook/ebook_widgets/ebook_home_page_list_preview.dart';
import '../ebook_screens/writter_detail_page.dart';
import 'package:read_on/public_variables/color_variable.dart';
import 'package:read_on/public_variables/style_variable.dart';
import 'package:read_on/widgets/gradient_button.dart';

class HomePageEbook extends StatefulWidget {
  const HomePageEbook({Key? key}) : super(key: key);

  @override
  State<HomePageEbook> createState() => _HomePageEbookState();
}

class _HomePageEbookState extends State<HomePageEbook> {
  int _sliderIndex = 0;
  int _tappedIndex = 0;
  int _count = 0;
  bool _loading = false;
  int _writerListLength = 0;

  void _customInit(EbookApiController ebookApiController) async {
    _count++;
    setState(() => _loading = true);
    await ebookApiController.getSiteSettings();
    await ebookApiController.getHomePageCategoryBooks();
    await ebookApiController.getWriterList();
    setState(() {
      _writerListLength = ebookApiController.writeModel.value.data!.length > 10 ? 10 : ebookApiController.writeModel.value.data!.length;
      _loading = false;
    });
    if (ebookApiController.freeBookList.isEmpty) await ebookApiController.getTenFreeBooks();
    if (ebookApiController.newBookList.isEmpty) await ebookApiController.getTenNewBooks();
  }

  @override
  Widget build(BuildContext context) {
    final PublicController publicController = Get.find();
    final EbookApiController ebookApiController = Get.find();
    final double size = publicController.size.value;
    if (_count == 0) _customInit(ebookApiController);
    return _loading? const Center(child: CupertinoActivityIndicator()) : SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size * .05),
            Container(
                width: size,
                height: size * .4,
                padding: EdgeInsets.symmetric(horizontal: size * .03),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(size * .02)),
                child: Carousel(
                  showIndicator: false,
                  borderRadius: true,
                  onImageChange: (x, index) {
                    setState(() => _sliderIndex = index);
                  },
                  images: [
                    ClipRRect(
                      child: Image.network(
                        "${ebookApiController.domainName}/public//slideshow/${ebookApiController.siteSettingImageList[0].sliderPath!}",
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(size * .02),
                    ),
                    ClipRRect(
                        child: Image.network(
                            "${ebookApiController.domainName}/public//slideshow/${ebookApiController.siteSettingImageList[1].sliderPath!}",
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(size * .02)),
                    ClipRRect(
                        child: Image.network(
                            "${ebookApiController.domainName}/public//slideshow/${ebookApiController.siteSettingImageList[2].sliderPath!}",
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(size * .02)),
                    ClipRRect(
                        child: Image.network(
                            "${ebookApiController.domainName}/public//slideshow/${ebookApiController.siteSettingImageList[3].sliderPath!}",
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(size * .02)),
                  ],
                )),
            SizedBox(height: size * .02),
            SizedBox(
              height: size * .04,
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, index) => Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: index == _sliderIndex
                                ? size * .025
                                : size * .02,
                            color: index == _sliderIndex
                                ? CColor.themeColor
                                : Colors.black38,
                          ),
                          SizedBox(
                            width: size * .015,
                          )
                        ],
                      )),
            ),
            SizedBox(height: size * .04),

            /// best seller section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size * .03),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'বেস্ট সেলার',
                      style: Style.headerTextStyle(
                          size * .05, Colors.black, FontWeight.normal),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(size * .4),
                        border:
                            Border.all(color: Colors.red, width: size * .005)),
                    padding: EdgeInsets.symmetric(
                        vertical: size * .004, horizontal: size * .03),
                    child: Text(
                      'আরও',
                      style: Style.headerTextStyle(
                          size * .035, Colors.black, FontWeight.normal),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: size * .03),
              height: size * .6,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (context, index) => index % 2 == 0
                      ? Padding(
                          padding: EdgeInsets.only(right: size * .06),
                          // child: BookPreview(
                          //     bookImageWidth: size * .26,
                          //     bookImageHeight: size * .4,
                          //     bookImage:
                          //         "https://1.bp.blogspot.com/-QoKjWWKcnC0/XWVnOba6kbI/AAAAAAAAXn4/fwXfr6wBflcYMrUlRSFxfB9K62_5SONAgCLcBGAs/s1600/Ekjon%2BMayaboti%2Bby%2BHumayun%2BAhmed%2B-%2BBangla%2BRomantic%2BNovel%2BPDF%2BBooks.jpg",
                          //     bookName: 'একজন মায়াবতী',
                          //     writerName: 'হুমায়ুন আহমেদ',
                          //  product: ,
                          // ),
                    child: Container(),
                        )
                      : Padding(
                          padding: EdgeInsets.only(right: size * .06),
                          child: Container(),
                          // child: BookPreview(
                          //     bookImageWidth: size * .26,
                          //     bookImageHeight: size * .4,
                          //     bookImage:
                          //         "https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1526455811l/40130315._SY475_.jpg",
                          //     bookName: 'রেশমি রেশমি রেশমি রেশমি রেশমি',
                          //     writerName: 'এমদাদুল হক মিলন রহমান তপু',
                          //   bookId: 1,
                          // ),
                        )),
            ),
            SizedBox(height: size * .02),

            /// free books
            EbookHomePageListPreview(
                title: 'ফ্রি বই', bookList: ebookApiController.freeBookList),
            SizedBox(height: size * .02),

            /// today's attraction
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: size * .03),
              child: Text(
                'আজকের আকর্ষণ',
                style: Style.headerTextStyle(
                    size * .05, Colors.black, FontWeight.normal),
              ),
            ),
            SizedBox(height: size * .02),
            Container(
              width: size,
              decoration: BoxDecoration(color: Colors.red.withOpacity(0.05)),
              padding: EdgeInsets.symmetric(
                  horizontal: size * .03, vertical: size * .045),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        margin: EdgeInsets.zero,
                        child: Container(
                          width: size * .35,
                          height: size * .55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: Image.network(
                                'https://1.bp.blogspot.com/-QoKjWWKcnC0/XWVnOba6kbI/AAAAAAAAXn4/fwXfr6wBflcYMrUlRSFxfB9K62_5SONAgCLcBGAs/s1600/Ekjon%2BMayaboti%2Bby%2BHumayun%2BAhmed%2B-%2BBangla%2BRomantic%2BNovel%2BPDF%2BBooks.jpg',
                                fit: BoxFit.cover,
                              )),
                        ),
                      ),
                      SizedBox(
                        width: size * .05,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'একজন মায়াবতী',
                              style: Style.headerTextStyle(
                                  size * .05, Colors.black, FontWeight.w500),
                            ),
                            Text(
                              'হুমায়ুন আহমেদ',
                              style: Style.headerTextStyle(size * .045,
                                  Colors.grey.shade600, FontWeight.normal),
                            ),
                            SizedBox(
                              height: size * .03,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(size * .4),
                                  color: Colors.grey.shade300,
                                  border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: size * .005)),
                              padding: EdgeInsets.symmetric(
                                  vertical: size * .005,
                                  horizontal: size * .04),
                              child: Text(
                                'উপন্যাস',
                                style: Style.bodyTextStyle(size * .035,
                                    Colors.black, FontWeight.normal),
                              ),
                            ),
                            SizedBox(
                              height: size * .03,
                            ),
                            RichText(
                              text: TextSpan(
                                  style: Style.bodyTextStyle(size * .045,
                                      Colors.grey.shade600, FontWeight.normal),
                                  children: [
                                    TextSpan(
                                      text: '৳',
                                      style: Style.bodyTextStyle(size * .07,
                                          CColor.themeColor, FontWeight.w500),
                                    ),
                                    TextSpan(
                                      text: '৩০ ',
                                      style: Style.headerTextStyle(size * .07,
                                          CColor.themeColor, FontWeight.normal),
                                    ),
                                    TextSpan(
                                      text: '৳৫৫',
                                      style: TextStyle(
                                          color: Colors.black,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontSize: size * .04),
                                    ),
                                    TextSpan(
                                      text: ' (\$0.99)',
                                      style: Style.bodyTextStyle(size * .035,
                                          Colors.black, FontWeight.normal),
                                    ),
                                  ]),
                            ),
                            SizedBox(
                              height: size * .03,
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: GradientButton(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'পড়ুন',
                                        style: Style.buttonTextStyle(size * .04,
                                            Colors.white, FontWeight.w500),
                                      ),
                                      SizedBox(
                                        width: size * .04,
                                      ),
                                      const Icon(
                                        Icons.double_arrow_outlined,
                                      ),
                                    ],
                                  ),
                                  onPressed: () {},
                                  borderRadius: size * .01,
                                  height: size * .1,
                                  width: size * .25,
                                  gradientColors: const [
                                    CColor.themeColor,
                                    CColor.themeColorLite
                                  ]),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: size * .03,
                  ),
                  Text(
                    'বইটি মানব প্রকৃতি এবং সম্পর্কের বেড়াজাল নিয়ে শব্দের রং তুলিতে আঁকা জীবনের গল্প। জটিল মানব মনের জটিল ভাবাবেগ তুলে ধরা হয়েছে গল্পটিতে। আধুনিক ধারার লোক দেখানো আর চাটুকারিতা ছাপিয়ে ভালোবাসাকে একটা নতুন মাত্রা দেওয়া হয়েছে। যে ভালোবাসা ধরা যায় না,ছোঁয়া যায় না। শুধু অন্তর দিয়ে অনুভব করতে হয়।',
                    maxLines: 3,
                    style: Style.bodyTextStyle(
                        size * .04, Colors.grey.shade800, FontWeight.normal),
                  )
                ],
              ),
            ),
            SizedBox(height: size * .03),

            /// special offers
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size * .03),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'বিশেষ ছাড়',
                      style: Style.headerTextStyle(
                          size * .05, Colors.black, FontWeight.normal),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(size * .4),
                        border:
                            Border.all(color: Colors.red, width: size * .005)),
                    padding: EdgeInsets.symmetric(
                        vertical: size * .004, horizontal: size * .03),
                    child: Text(
                      'আরও',
                      style: Style.headerTextStyle(
                          size * .035, Colors.black, FontWeight.normal),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: size * .03),
              height: size * .6,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(right: size * .06),
                        // child: BookPreview(
                        //     bookImageWidth: size * .26,
                        //     bookImageHeight: size * .4,
                        //     bookImage:
                        //         "https://1.bp.blogspot.com/-QoKjWWKcnC0/XWVnOba6kbI/AAAAAAAAXn4/fwXfr6wBflcYMrUlRSFxfB9K62_5SONAgCLcBGAs/s1600/Ekjon%2BMayaboti%2Bby%2BHumayun%2BAhmed%2B-%2BBangla%2BRomantic%2BNovel%2BPDF%2BBooks.jpg",
                        //     bookName: 'একজন মায়াবতী',
                        //     writerName: 'হুমায়ুন আহমেদ',
                        //   bookId: 1,
                        // ),
                    child: Container(),
                      )),
            ),
            SizedBox(height: size * .02),

            /// new books section
            EbookHomePageListPreview(title: 'নতুন বই', bookList: ebookApiController.newBookList),
            SizedBox(height: size * .02),

            /// famous writers
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size * .03),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'জনপ্রিয় লেখক',
                      style: Style.headerTextStyle(
                          size * .05, Colors.black, FontWeight.w700),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(size * .4),
                        border:
                            Border.all(color: Colors.red, width: size * .005)),
                    padding: EdgeInsets.symmetric(
                        vertical: size * .004, horizontal: size * .03),
                    child: Text(
                      'আরও',
                      style: Style.bodyTextStyle(
                          size * .035, Colors.black, FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: size * .03),
              height: size * .5,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  itemCount: _writerListLength,
                  itemBuilder: (context, index){
                    String writterName = ebookApiController.writeModel.value.data![index].writer![0].name!.length > 16
                        ? ebookApiController.writeModel.value.data![index].writer![0].name!.substring(0, 13) + '...'
                        : ebookApiController.writeModel.value.data![index].writer![0].name!;
                    return  Padding(
                      padding: EdgeInsets.only(right: size * .04),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              setState(() =>  _tappedIndex = index);
                              Get.to(() => WriterDetailPage(writerInfoData: ebookApiController.writeModel.value.data![index],));
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                /// writer image
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: _tappedIndex == index
                                              ? CColor.themeColor
                                              : Colors.white,
                                          width: size * .005)),
                                  child: CircleAvatar(
                                    backgroundImage: const NetworkImage(
                                      'https://m.media-amazon.com/images/M/MV5BNTM5YmQ5ZGYtMzRiMC00ZmVkLWIzMGItYjkwMTRkZWIyMTk1XkEyXkFqcGdeQXVyNDI3NjcxMDA@._V1_.jpg',
                                    ),
                                    radius: size * .12,
                                  ),
                                ),
                                SizedBox(height: size * .015),

                                /// writer name
                                SizedBox(
                                  width: size * .3,
                                  child: Text(
                                    writterName,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: Style.bodyTextStyle(
                                        size * .035,
                                        _tappedIndex == index
                                            ? CColor.themeColor
                                            : Colors.black,
                                        FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: ebookApiController.homePageBookListModel.value.data!.length,
                itemBuilder: (context, index){
                  return ebookApiController.homePageBookListModel.value.data![index].product!.isEmpty
                      ? const SizedBox() :
                        EbookHomePageListPreview(title: ebookApiController.homePageBookListModel.value.data![index].catName!, bookList: ebookApiController.homePageBookListModel.value.data![index].product!);
                })
          ],
        ),
      ),
    );
  }
}
