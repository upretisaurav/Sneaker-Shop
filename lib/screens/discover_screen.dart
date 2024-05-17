import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:priority_soft_test/models/shoe.dart';
import 'package:priority_soft_test/providers/selected_shoe_provider.dart';
import 'package:priority_soft_test/providers/shoe_provider.dart';
import 'package:priority_soft_test/screens/cart_screen.dart';
import 'package:priority_soft_test/screens/product_detail_screen.dart';
import 'package:priority_soft_test/utils/constants/sizes.dart';
import 'package:provider/provider.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String selectedBrand = "All";

  final List<String> filterBrandNames = [
    "All",
    "Nike",
    "Jordan",
    "Adidas",
    "Reebok",
    "Vans"
  ];

  @override
  void initState() {
    super.initState();
    Provider.of<ShoeProvider>(context, listen: false).fetchDocuments();
  }

  @override
  Widget build(BuildContext context) {
    var shoes = Provider.of<ShoeProvider>(context).shoes;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.xl),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Discover",
                    style: TextStyle(
                      fontSize: Sizes.fontSize30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ),
                      );
                    },
                    icon: SvgPicture.asset(
                      "assets/icons/cart.svg",
                      height: Sizes.iconMd,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Sizes.lg),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (String brandName in filterBrandNames)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedBrand = brandName;
                          });
                        },
                        child: Text(
                          brandName,
                          style: TextStyle(
                            fontSize: Sizes.fontSize20,
                            color: brandName == selectedBrand
                                ? Colors.black
                                : Colors.grey,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: Sizes.lg),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.55,
                  ),
                  itemCount: shoes.length * 100,
                  itemBuilder: (BuildContext context, int index) {
                    final shoe = shoes[index % shoes.length];
                    return _buildShoeCard(shoe);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text(
          "FILTER",
          style: TextStyle(
            fontSize: Sizes.fontSize14,
            fontWeight: FontWeight.w700,
          ),
        ),
        icon: SvgPicture.asset("assets/icons/setting-4.svg"),
        backgroundColor: Colors.black,
        onPressed: () {
          // Add your onPressed logic here
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildShoeCard(Shoe shoe) {
    String? imageUrl;

    return GestureDetector(
      onTap: () async {
        final selectedShoeProvider =
            Provider.of<SelectedShoeProvider>(context, listen: false);

        final imageUrls = await Future.wait([
          shoe.loadBrandLogoUrl(shoe.brandRef),
          shoe.loadImageUrl(),
        ]);

        imageUrl = imageUrls[1];

        selectedShoeProvider.setSelectedShoe(shoe, imageUrl);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProductDetailScreen(),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.shade200,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<List<String?>>(
                  future: Future.wait([
                    shoe.loadBrandLogoUrl(shoe.brandRef),
                    shoe.loadImageUrl(),
                  ]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError || snapshot.data == null) {
                      return const Text('Error loading data');
                    } else {
                      return Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, top: 15.0),
                            child: Row(
                              children: [
                                Image.network(
                                  snapshot.data![0]!,
                                  height: 40,
                                  width: 40,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 4.0,
                              left: 15,
                              right: 15,
                              bottom: 22,
                            ),
                            child: Center(
                              child: Image.network(
                                snapshot.data![1]!,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
            child: Text(
              shoe.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: Sizes.fontSize14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Row(
            children: [
              FutureBuilder<double>(
                future: shoe.calculateAverageRating(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 11,
                      width: 11,
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Error calculating average review');
                  } else {
                    return Row(
                      children: [
                        Image.asset(
                          "assets/icons/star.png",
                          height: 12,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          snapshot.data != null
                              ? snapshot.data!.toStringAsFixed(1)
                              : 'N/A',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(width: 5),
              Text(
                "(${shoe.totalReviews} reviews)",
                style: const TextStyle(
                  color: Color(0xffB7B7B7),
                  fontWeight: FontWeight.w400,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(width: 5),
          Text(
            "\$${shoe.price}",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}
