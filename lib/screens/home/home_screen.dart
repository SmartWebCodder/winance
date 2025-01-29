import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:winance/screens/home/search_screen.dart';
import 'package:winance/screens/home/trade_screen.dart';

enum Currency { USD, GBP, NGN }

enum CryptoFilter { ALL, HOT, GAINERS, LOSERS, NEW }

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Tracker',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _bottomNavIndex = 0;
  CryptoFilter _selectedFilter = CryptoFilter.ALL;
  Currency _selectedCurrency = Currency.USD; // Local currency state

  // Method to get the currency symbol
  String _getSymbol() {
    switch (_selectedCurrency) {
      case Currency.USD:
        return '\$';
      case Currency.GBP:
        return '£';
      case Currency.NGN:
        return '₦';
    }
  }

  // Method to convert USD amount to the selected currency
  double _getConvertedAmount(double usdAmount) {
    switch (_selectedCurrency) {
      case Currency.USD:
        return usdAmount;
      case Currency.GBP:
        return usdAmount * 0.79; // Example conversion rate
      case Currency.NGN:
        return usdAmount * 1750; // Example conversion rate
    }
  }

  // Method to format the balance
  String _formatBalance() {
    double amount = _getConvertedAmount(50000); // Example balance
    return NumberFormat.currency(
      locale: 'en_US',
      symbol: '',
      decimalDigits: 2,
    ).format(amount);
  }

  Widget _buildCurrencyDropdown() {
    return DropdownButton<Currency>(
      value: _selectedCurrency,
      onChanged: (Currency? newCurrency) {
        if (newCurrency != null) {
          setState(() {
            _selectedCurrency = newCurrency; // Update local state
          });
        }
      },
      dropdownColor:
          Colors.black.withOpacity(0.5), // Transparent white glassy effect
      items: Currency.values.map((Currency currency) {
        return DropdownMenuItem<Currency>(
          value: currency,
          child: Text(
            currency.toString().split('.').last,
            style: TextStyle(color: Colors.white),
          ),
        );
      }).toList(),
    );
  }

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
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      _buildBalanceCard(),
                      SizedBox(height: 24),
                      _buildActionButtons(),
                      SizedBox(height: 24),
                      _buildFavoriteCryptos(),
                      SizedBox(height: 24),
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
                icon: Icon(Icons.search, color: Colors.white),
                onPressed: () {},
              ),
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

  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      height: 150,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Total Balance',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFF00DC8A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '5.54%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              _buildCurrencyDropdown(),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '${_getSymbol()}${_formatBalance()}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: GlassmorphicContainer(
            width: double.infinity,
            height: 50,
            borderRadius: 12,
            blur: 20,
            border: 2,
            linearGradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
            ),
            borderGradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.transparent,
              ],
            ),
            child: Center(
              child: Text('Withdraw', style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text('Deposit', style: TextStyle(color: Colors.black)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteCryptos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Favorites',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            TextButton(
              onPressed: () {},
              child: Row(
                children: [
                  Text(
                    'See All',
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.yellow,
                  ),
                ],
              ),
            ),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildCryptoCard(
                imageUrl:
                    'https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400',
                name: 'Bitcoin',
                symbol: 'BTC',
                price: 102589.77,
                change: 5.54,
              ),
              SizedBox(width: 16),
              _buildCryptoCard(
                imageUrl:
                    'https://coin-images.coingecko.com/coins/images/279/large/ethereum.png?1696501628',
                name: 'Ethereum',
                symbol: 'ETH',
                price: 3137.77,
                change: 3.24,
              ),
              SizedBox(width: 16),
              _buildCryptoCard(
                imageUrl:
                    'https://coin-images.coingecko.com/coins/images/325/large/Tether.png?1696501661',
                name: 'Tether',
                symbol: 'USDT',
                price: 0.99,
                change: 3.24,
              ),
              SizedBox(width: 16),
              _buildCryptoCard(
                imageUrl:
                    'https://coin-images.coingecko.com/coins/images/44/large/xrp-symbol-white-128.png?1696501442',
                name: 'Ripple',
                symbol: 'XRP',
                price: 3.17,
                change: 3.24,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCryptoCard({
    required String imageUrl,
    required String name,
    required String symbol,
    required double price,
    required double change,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 220,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: Colors.white.withOpacity(0.1), width: 1), // Border
          color: Colors.white.withOpacity(0.05), // Glassy background
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  // Crypto Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.network(imageUrl, fit: BoxFit.contain),
                  ),
                  const SizedBox(width: 10),

                  // Crypto Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Name & Symbol
                        Text(
                          "$name ($symbol)",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Price & Percentage Change
                        Row(
                          children: [
                            Text(
                              '\$${NumberFormat.currency(locale: 'en_US', symbol: '', decimalDigits: 1).format(price)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${change > 0 ? '+' : ''}${change.toStringAsFixed(2)}%',
                              style: TextStyle(
                                color: change >= 0 ? Colors.green : Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TradeScreen()),
        );
        break;
      // Add cases for other indices if needed
      default:
        break;
    }
  }
}
