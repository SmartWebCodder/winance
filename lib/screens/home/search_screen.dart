import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:winance/screens/home/home_screen.dart';
import 'package:winance/screens/home/trade_screen.dart';

enum CryptoFilter { ALL, HOT, GAINERS, LOSERS, NEW }

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> searchHistory = ['USD', 'Bitcoin', 'Ethereum'];
  CryptoFilter _selectedFilter = CryptoFilter.ALL;
  int _bottomNavIndex = 1; // Initialize with the index of the SearchScreen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/blur.png'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Black gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(175, 0, 0, 0), // Black color
                  Color.fromARGB(255, 0, 0, 0), // Slightly lighter black
                ],
              ),
            ),
          ),
          // Main content
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      hintText: 'Search',
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.5)),
                    ),
                    style: TextStyle(color: Colors.white),
                    onSubmitted: (value) {
                      setState(() {
                        searchHistory.insert(0, value);
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      Text(
                        'Search History',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      ...searchHistory.map((query) => ListTile(
                            leading: Icon(Icons.history, color: Colors.white),
                            title: Text(
                              query,
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios,
                                color: Colors.white, size: 16),
                          )),
                      SizedBox(height: 24),
                      Text(
                        'Cryptocurrencies',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildCryptoFilters(),
                      SizedBox(height: 16),
                      _buildCryptoList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height *
            0.15, // 10% of the screen height
        child: _buildBottomNav(context), // Your custom bottom navigation bar
      ),
    );
  }

  Widget _buildCryptoFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: CryptoFilter.values.map((filter) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(
                filter.toString().split('.').last.toUpperCase(),
                style: TextStyle(
                  color: Colors.white, // Always white text
                  fontWeight: FontWeight.bold,
                ),
              ),
              selected: _selectedFilter == filter,
              backgroundColor: Colors.black87, // No background color
              selectedColor: Colors.black87, // Keep transparent when selected
              side: BorderSide(
                color: _selectedFilter == filter
                    ? Colors.yellow // Yellow border when selected
                    : Colors.grey, // Grey border when not selected
                width: 0.5, // Border width
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10), // Rounded edges like the image
              ),
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              showCheckmark:
                  false, // Removes the check icon inside selected item
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCryptoList() {
    return Column(
      children: [
        _buildCryptoListTile(
          imageUrl:
              'https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400',
          name: 'Bitcoin',
          symbol: 'BTC',
          price: 102672.77,
          change: 5.54,
        ),
        _buildCryptoListTile(
          imageUrl:
              'https://coin-images.coingecko.com/coins/images/279/large/ethereum.png?1696501628',
          name: 'Ethereum',
          symbol: 'ETH',
          price: 3180.77,
          change: 3.24,
        ),
        _buildCryptoListTile(
          imageUrl:
              'https://coin-images.coingecko.com/coins/images/325/large/Tether.png?1696501661',
          name: 'Tether',
          symbol: 'USDT',
          price: 0.99,
          change: 13.24,
        ),
        _buildCryptoListTile(
          imageUrl:
              'https://coin-images.coingecko.com/coins/images/44/large/xrp-symbol-white-128.png?1696501442',
          name: 'Ripple',
          symbol: 'XRP',
          price: 3180.77,
          change: 3.24,
        ),
        _buildCryptoListTile(
          imageUrl:
              'https://coin-images.coingecko.com/coins/images/825/large/bnb-icon2_2x.png?1696501970',
          name: 'Binance Coin',
          symbol: 'BNB',
          price: 674.77,
          change: 3.24,
        ),
        _buildCryptoListTile(
          imageUrl:
              'https://coin-images.coingecko.com/coins/images/4128/large/solana.png?1718769756',
          name: 'Solana',
          symbol: 'SOL',
          price: 237.77,
          change: 11.24,
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.amber,
            child: Icon(Icons.person, color: Colors.white),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.qr_code_scanner, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.notifications_none, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCryptoListTile({
    required String imageUrl,
    required String name,
    required String symbol,
    required double price,
    required double change,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(237, 13, 13, 13),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.amber.withOpacity(0.1),
          child: Image.network(imageUrl, fit: BoxFit.contain),
        ),
        title: Text(name, style: TextStyle(color: Colors.white)),
        subtitle: Text(
          symbol,
          style: TextStyle(color: Colors.white),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${NumberFormat.currency(locale: 'en_US', symbol: '', decimalDigits: 2).format(price)}',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              '+${change.toStringAsFixed(2)}%',
              style: TextStyle(color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 90,
        margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07), // Set background color
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
            width: 1,
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _bottomNavIndex,
          onTap: (index) {
            setState(() => _bottomNavIndex = index);
            _navigateToScreen(index, context);
          },
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.amber,
          unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(8), // Reduced padding
                decoration: BoxDecoration(
                  color:
                      _bottomNavIndex == 0 ? Colors.amber : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.home,
                  color: _bottomNavIndex == 0
                      ? Colors.black
                      : const Color.fromARGB(255, 255, 255, 255),
                  size: 20, // Reduced icon size
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      _bottomNavIndex == 1 ? Colors.amber : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.bar_chart,
                  color: _bottomNavIndex == 1
                      ? Colors.black
                      : const Color.fromARGB(255, 255, 255, 255),
                  size: 20,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      _bottomNavIndex == 2 ? Colors.amber : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.pie_chart,
                  color: _bottomNavIndex == 2
                      ? Colors.black
                      : const Color.fromARGB(255, 255, 255, 255),
                  size: 20,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      _bottomNavIndex == 3 ? Colors.amber : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.credit_card,
                  color: _bottomNavIndex == 3
                      ? Colors.black
                      : const Color.fromARGB(255, 255, 255, 255),
                  size: 20,
                ),
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToScreen(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
        break;
      case 1:
        // Already on the SearchScreen, no need to navigate
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TradeScreen()),
        );
      // Add cases for other indices if needed
      default:
        break;
    }
  }
}
