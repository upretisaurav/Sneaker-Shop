import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:priority_soft_test/models/review.dart';
import 'package:priority_soft_test/providers/selected_shoe_provider.dart';
import 'package:priority_soft_test/utils/constants/sizes.dart';
import 'package:priority_soft_test/widgets/review_item.dart';

class AllReviewsScreen extends StatefulWidget {
  final SelectedShoeProvider selectedShoeProvider;
  const AllReviewsScreen({
    super.key,
    required this.selectedShoeProvider,
  });

  @override
  State<AllReviewsScreen> createState() => _AllReviewsScreenState();
}

class _AllReviewsScreenState extends State<AllReviewsScreen> {
  String selectedReviewOption = "All";
  final List<String> reviewOptions = [
    "All",
    "5 Stars",
    "4 Stars",
    "3 Stars",
    "2 Stars",
    "1 Star"
  ];

  final ScrollController _scrollController = ScrollController();
  final List<Review> _allReviews = [];
  List<Review> _filteredReviews = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMoreReviews();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreReviews();
    }
  }

  Future<void> _loadMoreReviews() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    final selectedShoe = widget.selectedShoeProvider.selectedShoe;
    final newReviews = await selectedShoe.fetchReviews(limit: 10);
    setState(() {
      _allReviews.addAll(newReviews);
      _filterReviews();
      _isLoading = false;
    });
  }

  void _filterReviews() {
    _filteredReviews = _allReviews;
    if (selectedReviewOption != "All") {
      int rating = int.parse(selectedReviewOption.split(" ")[0]);
      _filteredReviews =
          _allReviews.where((review) => review.rating == rating).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedShoe = widget.selectedShoeProvider.selectedShoe;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Review (${selectedShoe.totalReviews})",
          style: const TextStyle(
            color: Colors.black,
            fontSize: Sizes.fontSize16,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset("assets/icons/arrow-left.svg"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: const [
          Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.orange,
                size: Sizes.md,
              ),
              SizedBox(
                width: Sizes.sm,
              ),
              Text(
                "4.5",
                style: TextStyle(
                  fontSize: Sizes.fontSize14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: Sizes.sm,
              ),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (String brandName in reviewOptions)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedReviewOption = brandName;
                          _filterReviews();
                        });
                      },
                      child: Text(
                        brandName,
                        style: TextStyle(
                          fontSize: Sizes.fontSize20,
                          color: brandName == selectedReviewOption
                              ? Colors.black
                              : Colors.grey,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(
              height: Sizes.sm,
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _filteredReviews.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < _filteredReviews.length) {
                    final review = _filteredReviews[index];
                    return buildReviewItem(review);
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
