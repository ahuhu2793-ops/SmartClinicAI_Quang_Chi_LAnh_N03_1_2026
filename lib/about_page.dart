import 'package:flutter/material.dart';

class ResponsiveHelper {
  static double getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 16.0;
    if (width < 1200) return 40.0;
    return 80.0;
  }

  static double getVerticalPadding(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (height < 800) return 20.0;
    if (height < 1200) return 40.0;
    return 60.0;
  }

  static double getHeroPadding(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (height < 800) return 40.0;
    if (height < 1200) return 60.0;
    return 80.0;
  }

  static double getFooterPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 20.0;
    if (width < 1200) return 40.0;
    return 60.0;
  }

  static int getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 1;
    if (width < 1200) return 2;
    return 3;
  }

  static double getChildAspectRatio(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 1.0;
    if (width < 1200) return 1.2;
    return 1.5;
  }
}

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.medical_services,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'SmartClinicAI',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () {}, child: const Text('Dịch vụ')),
          TextButton(onPressed: () {}, child: const Text('Giải pháp')),
          TextButton(onPressed: () {}, child: const Text('Cộng đồng')),
          TextButton(onPressed: () {}, child: const Text('Tài nguyên')),
          TextButton(onPressed: () {}, child: const Text('Bảng giá')),
          TextButton(onPressed: () {}, child: const Text('Liên hệ')),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.blue,
              side: const BorderSide(color: Colors.blue),
            ),
            child: const Text('Đăng nhập'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Đăng ký'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(ResponsiveHelper.getHeroPadding(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Về Chúng Tôi',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'SmartClinicAI - Trusted Care with 15 Years of Experience',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            // Contact Form Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.getHorizontalPadding(context), vertical: 40),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = MediaQuery.of(context).size.width < 600;
                  
                  if (isMobile) {
                    // Mobile layout - vertical column
                    return Column(
                      children: [
                        // Clinic Info
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 300,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.local_hospital,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              'Phòng Khám Hiện Đại',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Với không gian rộng rãi, trang thiết bị hiện đại và đội ngũ chuyên viên tận tâm, chúng tôi cam kết mang đến trải nghiệm tốt nhất cho bệnh nhân.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 24),
                            _buildInfoRow(Icons.location_on, 'SmartClinicAI Headquarters, 10 Lê Lợi, District 1, Ho Chi Minh City'),
                            const SizedBox(height: 12),
                            _buildInfoRow(Icons.phone, '+84 28 3827 0000'),
                            const SizedBox(height: 12),
                            _buildInfoRow(Icons.email, 'contact@smartclinic.ai'),
                            const SizedBox(height: 12),
                            _buildInfoRow(Icons.access_time, 'Mon - Sat: 08:00 - 18:00'),
                            const SizedBox(height: 30),
                          ],
                        ),
                        // Contact Form
                        Container(
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade100,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: _buildContactForm(),
                        ),
                      ],
                    );
                  } else {
                    // Desktop/Tablet layout - side by side
                    return Row(
                      children: [
                        // Left side - Clinic Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 400,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.local_hospital,
                                    size: 100,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                              const Text(
                                'Phòng Khám Hiện Đại',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Với không gian rộng rãi, trang thiết bị hiện đại và đội ngũ chuyên viên tận tâm, chúng tôi cam kết mang đến trải nghiệm tốt nhất cho bệnh nhân.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 24),
                              _buildInfoRow(Icons.location_on, 'SmartClinicAI Headquarters, 10 Lê Lợi, District 1, Ho Chi Minh City'),
                              const SizedBox(height: 12),
                              _buildInfoRow(Icons.phone, '+84 28 3827 0000'),
                              const SizedBox(height: 12),
                              _buildInfoRow(Icons.email, 'contact@smartclinic.ai'),
                              const SizedBox(height: 12),
                              _buildInfoRow(Icons.access_time, 'Mon - Sat: 08:00 - 18:00'),
                            ],
                          ),
                        ),
                        const SizedBox(width: 60),
                        // Right side - Contact Form
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(40),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade100,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: _buildContactForm(),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            
            const SizedBox(height: 80),
            
            // Footer
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.blue,
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildContactForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Liên Hệ Với Chúng Tôi',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Để lại thông tin và chúng tôi sẽ liên hệ với bạn trong vòng 24 giờ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 32),
          // Name Field
          const Text(
            'First Name',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Enter your first name',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your first name';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Surname Field
          const Text(
            'Last Name',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _surnameController,
            decoration: const InputDecoration(
              hintText: 'Enter your last name',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your last name';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Email Field
          const Text(
            'Email',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              hintText: 'Nhập email của bạn',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Email không hợp lệ';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Message Field
          const Text(
            'Message',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _messageController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Enter your message',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your message';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Handle form submission
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Message sent successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Clear form
                  _nameController.clear();
                  _surnameController.clear();
                  _emailController.clear();
                  _messageController.clear();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text('Send Message'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveHelper.getFooterPadding(context)),
      color: Colors.grey[50],
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo and Social Icons
              if (!isMobile)
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.medical_services,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Nha Khoa',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          _buildSocialIcon(Icons.alternate_email),
                          const SizedBox(width: 12),
                          _buildSocialIcon(Icons.camera_alt),
                          const SizedBox(width: 12),
                          _buildSocialIcon(Icons.play_circle),
                          const SizedBox(width: 12),
                          _buildSocialIcon(Icons.work),
                        ],
                      ),
                    ],
                  ),
                ),
              // Use Cases
              if (!isMobile)
                Expanded(
                  child: _buildFooterColumn('Dịch vụ', [
                    'Niềng răng',
                    'Răng sứ thẩm mỹ',
                    'Cấy ghép implant',
                    'Trám răng',
                    'Vệ sinh răng miệng',
                    'Whitening răng',
                  ]),
                ),
              // Explore
              if (!isMobile)
                Expanded(
                  child: _buildFooterColumn('Khám phá', [
                    'Đội ngũ bác sĩ',
                    'Công nghệ',
                    'Hệ thống phòng khám',
                    'Quy trình',
                    'Chính sách bảo hành',
                    'Hỏi đáp',
                  ]),
                ),
              // Resources
              if (!isMobile)
                Expanded(
                  child: _buildFooterColumn('Tài nguyên', [
                    'Blog',
                    'Kiến thức nha khoa',
                    'Video hướng dẫn',
                    'Bảng giá',
                    'Hỗ trợ khách hàng',
                    'Liên hệ',
                  ]),
                ),
              
              // Mobile layout - stacked columns
              if (isMobile)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo and Social Icons
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.medical_services,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Nha Khoa ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _buildSocialIcon(Icons.alternate_email),
                        const SizedBox(width: 12),
                        _buildSocialIcon(Icons.camera_alt),
                        const SizedBox(width: 12),
                        _buildSocialIcon(Icons.play_circle),
                        const SizedBox(width: 12),
                        _buildSocialIcon(Icons.work),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Mobile columns
                    _buildFooterColumn('Dịch vụ', [
                      'Niềng răng',
                      'Răng sứ thẩm mỹ',
                      'Cấy ghép implant',
                      'Trám răng',
                      'Vệ sinh răng miệng',
                      'Whitening răng',
                    ]),
                    const SizedBox(height: 30),
                    _buildFooterColumn('Khám phá', [
                      'Đội ngũ bác sĩ',
                      'Công nghệ',
                      'Hệ thống phòng khám',
                      'Quy trình',
                      'Chính sách bảo hành',
                      'Hỏi đáp',
                    ]),
                    const SizedBox(height: 30),
                    _buildFooterColumn('Tài nguyên', [
                      'Blog',
                      'Kiến thức nha khoa',
                      'Video hướng dẫn',
                      'Bảng giá',
                      'Hỗ trợ khách hàng',
                      'Liên hệ',
                    ]),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(
        icon,
        size: 20,
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildFooterColumn(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _FooterLinkItem(text: item),
        )),
      ],
    );
  }
}

class _FooterLinkItem extends StatefulWidget {
  final String text;
  
  const _FooterLinkItem({required this.text});
  
  @override
  State<_FooterLinkItem> createState() => _FooterLinkItemState();
}

class _FooterLinkItemState extends State<_FooterLinkItem> {
  bool _isHovering = false;
  
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Handle navigation
        },
        child: AnimatedScale(
          scale: _isHovering ? 1.08 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 14,
              color: _isHovering ? Colors.blue[700] : Colors.blue,
              fontWeight: _isHovering ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
