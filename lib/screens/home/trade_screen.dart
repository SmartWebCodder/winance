import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:winance/screens/home/search_screen.dart';
import 'package:winance/screens/home/home_screen.dart';

class TradeScreen extends StatefulWidget {
  @override
  _TradeScreenState createState() => _TradeScreenState();
}

class _TradeScreenState extends State<TradeScreen> {
  int _selectedTabIndex = 2; // Index for BottomNavigationBar
  int _selectedTradingTypeIndex = 2; // Initial index for trading types
  int _bottomNavIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/blur.png'),
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
                  Color.fromARGB(175, 0, 0, 0),
                  Color.fromARGB(255, 0, 0, 0),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                SizedBox(height: 16),
                _buildTradingTypeTabs(),
                SizedBox(height: 16),
                _buildBalanceSection(),
                SizedBox(height: 16),
                _buildChartSection(),
                SizedBox(height: 16),
                _buildOrderSection(),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

  Widget _buildTradingTypeTabs() {
    final List<String> tradingTypes = [
      'Convert',
      'Spot',
      'Margin',
      'Bots',
      'Copy'
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tradingTypes.map((type) {
          int index = tradingTypes.indexOf(type);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ChoiceChip(
              label: Text(
                type,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              selected: _selectedTradingTypeIndex == index,
              backgroundColor: Colors.black87,
              selectedColor: Colors.black87,
              side: BorderSide(
                color: _selectedTradingTypeIndex == index
                    ? Colors.yellow
                    : Colors.grey,
                width: 0.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onSelected: (selected) {
                setState(() {
                  _selectedTradingTypeIndex = index;
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBalanceSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Balance',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '\$48,341.77',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '5.54%',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          DropdownButton<String>(
            dropdownColor: Colors.black,
            value: 'USD/USDT',
            items: ['USD/USDT', 'BTC/USD', 'ETH/USDT']
                .map((e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e, style: TextStyle(color: Colors.white)),
                    ))
                .toList(),
            onChanged: (val) {}, // Handle currency pair change
          ),
        ],
      ),
    );
  }

class CandlestickPainter extends CustomPainter {
  final List<Map<String, dynamic>> candles;

  CandlestickPainter(this.candles);

  @override
  void paint(Canvas canvas, Size size) {
    final double candleWidth = size.width / candles.length;
    final double maxPrice = candles.map((c) => c['high']).reduce((a, b) => a > b ? a : b);
    final double minPrice = candles.map((c) => c['low']).reduce((a, b) => a < b ? a : b);
    final double priceRange = maxPrice - minPrice;
    final double heightPerPrice = size.height / priceRange;

    for (int i = 0; i < candles.length; i++) {
      final candle = candles[i];
      final double x = i * candleWidth + candleWidth / 2;
      final double openY = size.height - (candle['open'] - minPrice) * heightPerPrice;
      final double closeY = size.height - (candle['close'] - minPrice) * heightPerPrice;
      final double highY = size.height - (candle['high'] - minPrice) * heightPerPrice;
      final double lowY = size.height - (candle['low'] - minPrice) * heightPerPrice;

      final Paint paint = Paint()
        ..color = candle['isGreen'] ? Colors.green : Colors.red
        ..strokeWidth = 2;

      // Draw the high-low line
      canvas.drawLine(Offset(x, highY), Offset(x, lowY), paint);

      // Draw the candle body
      final double bodyTop = openY < closeY ? openY : closeY;
      final double bodyBottom = openY < closeY ? closeY : openY;
      canvas.drawRect(
        Rect.fromPoints(
          Offset(x - candleWidth / 4, bodyTop),
          Offset(x + candleWidth / 4, bodyBottom),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
  Widget _buildOrderSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Cross 5x',
                style:
                    TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
              ),
              Text(
                'Auto',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'B/R',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            height: 200,
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '68,232.30',
                      style: TextStyle(
                          color: index % 2 == 0 ? Colors.green : Colors.red),
                    ),
                    Text(
                      '68,232.30',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchScreen()),
        );
        break;
      case 2:

      // Add cases for other indices if needed
      default:
        break;
    }
  }
}
