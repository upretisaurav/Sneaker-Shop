import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:priority_soft_test/models/brand.dart';
import 'package:priority_soft_test/models/shoe_color.dart';
import 'package:priority_soft_test/providers/cart_provider.dart';
import 'package:priority_soft_test/providers/selected_shoe_provider.dart';
import 'package:priority_soft_test/screens/all_reviews_screen.dart';
import 'package:priority_soft_test/screens/cart_screen.dart';
import 'package:priority_soft_test/utils/constants/colors.dart';
import 'package:priority_soft_test/utils/constants/sizes.dart';
import 'package:priority_soft_test/models/review.dart';
import 'package:priority_soft_test/widgets/black_button.dart';
import 'package:priority_soft_test/widgets/review_item.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  int _selectedSizeIndex = -1;
  List<ShoeColor> _shoeColors = [];
  String? _selectedColorName;
  String? _brandName;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fetchShoeColors();
    _fetchBrandName();
  }

  Future<void> _fetchBrandName() async {
    SelectedShoeProvider selectedShoeProvider =
        Provider.of<SelectedShoeProvider>(context, listen: false);
    final selectedShoe = selectedShoeProvider.selectedShoe;
    final brandRef = selectedShoe.brandRef;
    final brandDocumentSnapshot = await brandRef.get();
    final brandData = brandDocumentSnapshot.data() as Map<String, dynamic>;
    final brand = Brand.fromJson(brandData);
    setState(() {
      _brandName = brand.name;
    });
  }

  Future<void> _fetchShoeColors() async {
    SelectedShoeProvider selectedShoeProvider =
        Provider.of<SelectedShoeProvider>(context, listen: false);
    final selectedShoe = selectedShoeProvider.selectedShoe;
    final colors = await selectedShoe.getShoeColors();
    setState(() {
      _shoeColors = colors;
    });
  }

  @override
  Widget build(BuildContext context) {
    SelectedShoeProvider selectedShoeProvider =
        Provider.of<SelectedShoeProvider>(context);
    final selectedShoe = selectedShoeProvider.selectedShoe;
    final selectedImageUrl = selectedShoeProvider.selectedImageUrl;
    final selectedName = selectedShoe.name;
    final selectedTotalReviews = selectedShoe.totalReviews;
    final selectedPrice = selectedShoe.price;
    final selectedSizes = selectedShoe.sizes;
    final selectedDescription = selectedShoe.description;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset("assets/icons/arrow-left.svg"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
            icon: SvgPicture.asset("assets/icons/bag-2.svg"),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.xl),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: Sizes.sm,
                  ),
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Container(
                        height: 300,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Sizes.xl,
                            vertical: 67,
                          ),
                          child: PageView.builder(
                            controller: _pageController,
                            onPageChanged: (int page) {
                              setState(() {
                                _currentPage = page;
                              });
                            },
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return _buildCarouselItem(selectedImageUrl);
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: Sizes.lg, bottom: Sizes.lg),
                          child: Row(
                            children: List<Widget>.generate(3, (int index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: Sizes.xs),
                                height: 8.0,
                                width: 8.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentPage == index
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        margin: const EdgeInsets.only(
                          right: Sizes.sm,
                          bottom: Sizes.sm,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 10.0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children:
                                  List.generate(_shoeColors.length, (index) {
                                final shoeColor = _shoeColors[index];
                                final hexCode = shoeColor.hexCode;
                                final colorValue =
                                    int.parse(hexCode.substring(1), radix: 16) +
                                        0xFF000000;
                                final isSelectedColor =
                                    _selectedColorName == shoeColor.name;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedColorName = shoeColor.name;
                                    });
                                  },
                                  child: Container(
                                    margin:
                                        const EdgeInsets.only(right: Sizes.sm),
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Color(colorValue),
                                      shape: BoxShape.circle,
                                      border: colorValue == 0xffffffff
                                          ? Border.all(color: Colors.grey)
                                          : null,
                                    ),
                                    child: Center(
                                      child: isSelectedColor
                                          ? colorValue == 0xffffffff
                                              ? const Icon(
                                                  Icons.check,
                                                  color: Colors.black,
                                                  size: 12,
                                                )
                                              : const Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 12,
                                                )
                                          : Container(),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: Sizes.xl,
                  ),
                  Text(
                    selectedName,
                    style: const TextStyle(
                      fontSize: Sizes.lg,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: Sizes.xs,
                  ),
                  Text(
                    '($selectedTotalReviews Reviews)',
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                      color: PColors.secondary,
                    ),
                  ),
                  const SizedBox(
                    height: Sizes.xl,
                  ),
                  const Text(
                    'Size',
                    style: TextStyle(
                      fontSize: Sizes.fontSize16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: Sizes.sm,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(selectedSizes.length, (index) {
                        final size = selectedSizes[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedSizeIndex = index;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _selectedSizeIndex == index
                                  ? Colors.black
                                  : Colors.white,
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Center(
                              child: Text(
                                size.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _selectedSizeIndex == index
                                      ? Colors.white
                                      : PColors.secondary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(
                    height: Sizes.xl,
                  ),
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: Sizes.fontSize16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: Sizes.sm,
                  ),
                  Text(
                    selectedDescription,
                    style: const TextStyle(
                      fontSize: Sizes.fontSize14,
                      fontWeight: FontWeight.w400,
                      height: 2.4,
                      color: PColors.secondary,
                    ),
                  ),
                  const SizedBox(
                    height: Sizes.xl,
                  ),
                  Text(
                    "Review ($selectedTotalReviews)",
                    style: const TextStyle(
                      fontSize: Sizes.fontSize16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: Sizes.sm,
                  ),
                  FutureBuilder<List<Review>>(
                    future: selectedShoe.fetchReviews(limit: 3),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final reviews = snapshot.data ?? [];
                        return Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: reviews.length,
                              itemBuilder: (context, index) {
                                final review = reviews[index];
                                return buildReviewItem(review);
                              },
                            ),
                            if (selectedTotalReviews > 3)
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AllReviewsScreen(
                                        selectedShoeProvider:
                                            selectedShoeProvider,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 13.0,
                                      vertical: Sizes.lg,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "SEE ALL REVIEW",
                                        style: TextStyle(
                                          fontSize: Sizes.fontSize14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 120,
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(Sizes.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Price",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: PColors.secondary,
                          ),
                        ),
                        const SizedBox(
                          height: Sizes.xs,
                        ),
                        Text(
                          '\$$selectedPrice',
                          style: const TextStyle(
                            fontSize: Sizes.fontSize16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        _showAddToCartBottomSheet(context, selectedPrice);
                      },
                      child: blackButton("ADD TO CART"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselItem(String? imageUrl) {
    return Image.network(
      imageUrl ?? "",
      fit: BoxFit.contain,
    );
  }

  void _showAddToCartBottomSheet(BuildContext context, double selectedPrice) {
    int quantity = 1;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(Sizes.md),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.xl,
                  vertical: Sizes.md,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 44,
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: Sizes.xl,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add to Cart',
                          style: TextStyle(
                            fontSize: Sizes.fontSize20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: Sizes.md),
                    const Text(
                      'Quantity',
                      style: TextStyle(
                        fontSize: Sizes.fontSize16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: Sizes.xl),
                    Row(
                      children: [
                        Expanded(
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              TextField(
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                controller: TextEditingController(
                                    text: quantity.toString()),
                                onChanged: (newValue) {
                                  if (int.tryParse(newValue) != null) {
                                    setState(() {
                                      quantity = int.parse(newValue);
                                    });
                                  }
                                },
                                decoration: const InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15.0),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (quantity > 1) quantity--;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border:
                                              Border.all(color: Colors.grey),
                                        ),
                                        child: const Icon(
                                          Icons.remove,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: Sizes.md,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          quantity++;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border:
                                              Border.all(color: Colors.black),
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Sizes.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Price",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: PColors.secondary,
                              ),
                            ),
                            const SizedBox(
                              height: Sizes.xs,
                            ),
                            Text(
                              '\$$selectedPrice',
                              style: const TextStyle(
                                fontSize: Sizes.fontSize16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            _addToCart(context, selectedPrice, quantity);
                            Navigator.pop(context);
                          },
                          child: blackButton("ADD TO CART"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _addToCart(BuildContext context, double price, int quantity) {
    final selectedShoeProvider =
        Provider.of<SelectedShoeProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final selectedShoe = selectedShoeProvider.selectedShoe;
    final selectedColor = _selectedColorName ?? 'Unknown';
    final selectedSize = selectedShoe.sizes[_selectedSizeIndex];
    final selectedImageUrl = selectedShoeProvider.selectedImageUrl;

    cartProvider.addItem(
      name: selectedShoe.name,
      price: price,
      color: selectedColor,
      shoeSize: selectedSize,
      quantity: quantity,
      imageUrl: selectedImageUrl ?? '',
      brand: _brandName ?? '',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${selectedShoe.name} added to cart!'),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
