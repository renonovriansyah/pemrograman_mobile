import 'package:flutter/material.dart';
import 'dart:ui'; 
import '../models/feedback_model.dart';
import 'feedback_result_screen.dart';

class FeedbackFormScreen extends StatefulWidget {
  const FeedbackFormScreen({super.key});

  @override
  State<FeedbackFormScreen> createState() => _FeedbackFormScreenState();
}

class _FeedbackFormScreenState extends State<FeedbackFormScreen> {
  // Global Key for form validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for text input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _roleController = TextEditingController(); 

  // FocusNodes for controlling focus and scrolling to invalid fields
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _commentFocus = FocusNode();
  final FocusNode _roleFocus = FocusNode();

  // State Variables for form elements
  double _overallRating = 4.5; 
  String? _productQuality; 
  String _customerSupportRating = 'Very Easy'; 
  bool _permissionToContact = false; 

  final List<String> _productQualityOptions = ['Excellent', 'Good', 'Fair', 'Poor'];

  // --- VALIDATION AND SUBMISSION ---
  void _submitFeedback() {
    bool isFormValid = _formKey.currentState!.validate();
    bool isProductQualitySelected = _productQuality != null;

    if (isFormValid && isProductQualitySelected) {
      _formKey.currentState!.save();
      
      final feedback = FeedbackData(
        name: _nameController.text,
        comment: _commentController.text,
        rating: _overallRating,
        email: _emailController.text,
        role: _roleController.text,
        productQuality: _productQuality!,
        customerSupportRating: _customerSupportRating,
      );

      _showThankYouDialog(feedback);
    } else {
      _scrollToFirstInvalid(isProductQualitySelected);
    }
  }

  void _scrollToFirstInvalid(bool isProductQualitySelected) {
    final nodes = [
      _nameFocus, _emailFocus, _commentFocus, _roleFocus
    ];
    
    // Autofocus on text fields first
    bool focused = false;
    for (var node in nodes) {
      if (node.context != null && Form.of(node.context!).validate()) {
        Scrollable.ensureVisible(
          node.context!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
          alignment: 0.1, 
        );
        node.requestFocus();
        focused = true;
        break;
      }
    }
    
    // If no text field was invalid, check the mandatory dropdown (Product Quality)
    if (!focused && !isProductQualitySelected) {
        if (_formKey.currentContext != null) {
            Scrollable.ensureVisible(
                _formKey.currentContext!,
                duration: const Duration(milliseconds: 300),
                alignment: 0.1
            );
        }
    }
  }

  // --- DIALOG LOGIC (Confirmation Pop Up) ---
  void _showThankYouDialog(FeedbackData data) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, a1, a2, child) {
        // Simple scale transition for the pop-up effect
        return Transform.scale(
          scale: a1.value,
          child: Opacity(opacity: a1.value, child: child),
        );
      },
      pageBuilder: (context, a1, a2) {
        return _CustomDialog(
          title: 'Thank you, ${data.name}!',
          content: 'Your feedback has been successfully submitted.',
          action1Text: 'View Summary',
          action1OnPressed: () {
            Navigator.pop(context); // Close dialog
            Navigator.push(context, MaterialPageRoute(builder: (ctx) => FeedbackResultScreen(data: data)));
          },
          action2Text: 'Fill Again',
          action2OnPressed: () {
            Navigator.pop(context); // Close dialog
            // Reset the form state
            _formKey.currentState!.reset(); 
            _nameController.clear();
            _commentController.clear();
            _emailController.clear();
            _roleController.clear();
            setState(() {
              _overallRating = 4.5;
              _productQuality = null;
              _customerSupportRating = 'Very Easy';
              _permissionToContact = false;
            });
          },
        );
      },
    );
  }

  // --- WIDGET BUILDERS ---
  Widget _buildStarRating(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        IconData icon = Icons.star;
        Color color = Colors.grey.shade400;

        if (index < rating.floor()) {
          color = Colors.amber; 
        } else if (index < rating && rating < index + 1) {
          icon = Icons.star_half; 
          color = Colors.amber;
        }

        return Icon(icon, color: color, size: 24);
      }),
    );
  }
  
  Widget _buildRadioChip(String value, String display) {
    // Helper function for the radio chip (customer support rating)
    bool isSelected = _customerSupportRating == value;
    
    return GestureDetector(
      onTap: () => setState(() => _customerSupportRating = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          // REVISED: using withAlpha(255 * 0.8) = 204
          color: isSelected ? Theme.of(context).primaryColor : Colors.white.withAlpha(204),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Text(
          display,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose all controllers and focus nodes
    _nameController.dispose();
    _commentController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _commentFocus.dispose();
    _roleFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Attempt to focus on the Name field initially
    if (!_nameFocus.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _nameFocus.requestFocus();
      });
    }
    
    return Scaffold(
      body: Stack(
        children: [
          // Background with a subtle image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const NetworkImage("https://placehold.co/1000x1500/A0CED9/00bcd4?text=Background"), 
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  // REVISED: using withAlpha(255 * 0.3) = 77
                  Colors.blueGrey.withAlpha(77), 
                  BlendMode.darken
                ),
              ),
            ),
          ),
          
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                // Glassmorphism effect
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0), 
                  child: Container(
                    padding: const EdgeInsets.all(25.0),
                    width: MediaQuery.of(context).size.width > 600 ? 500 : double.infinity,
                    decoration: BoxDecoration(
                      // REVISED: using withAlpha(255 * 0.75) = 191
                      color: Colors.white.withAlpha(191), 
                      borderRadius: BorderRadius.circular(20.0),
                      // REVISED: using withAlpha(255 * 0.5) = 128
                      border: Border.all(color: Colors.white.withAlpha(128)),
                      boxShadow: [
                        BoxShadow(
                          // REVISED: using withAlpha(255 * 0.1) = 25
                          color: Colors.black.withAlpha(25),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form( 
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // --- Header ---
                            Center(
                              child: Column(
                                children: [
                                  const Icon(Icons.auto_fix_high, color: Color(0xFF00bcd4), size: 30),
                                  const Text("WE VALUE YOUR FEEDBACK", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF0D47A1))),
                                  const Text("Please share your thoughts and help us improve", style: TextStyle(fontSize: 12, color: Colors.grey)),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                            
                            // --- Overall Experience ---
                            const Text("Overall Experience", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Row(children: [
                              _buildStarRating(_overallRating),
                              const SizedBox(width: 10),
                              Text('${_overallRating.toStringAsFixed(1)}/5', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                            ]),
                            Slider(
                              value: _overallRating,
                              min: 1.0, max: 5.0, divisions: 8, 
                              activeColor: Colors.amber, inactiveColor: Colors.amber.withAlpha(77),
                              onChanged: (double newValue) => setState(() => _overallRating = newValue),
                            ),
                            
                            const Divider(height: 30, color: Colors.grey),

                            // --- Specific Areas ---
                            const Text("Specific Areas", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            
                            // Product/Service Quality (Dropdown - MANDATORY)
                            const Text("Product/Service Quality *", style: TextStyle(fontWeight: FontWeight.w500)),
                            DropdownButtonFormField<String>(
                              initialValue: _productQuality, // FIX: Use initialValue
                              decoration: const InputDecoration(hintText: "Select Quality"),
                              items: _productQualityOptions.map((String value) {
                                return DropdownMenuItem<String>(value: value, child: Text(value));
                              }).toList(),
                              onChanged: (String? newValue) => setState(() => _productQuality = newValue),
                              validator: (value) => value == null ? 'Product Quality is required' : null,
                            ),
                            const SizedBox(height: 15),
                            
                            // Customer Support Rating (Radio Chips)
                            const Text("Customer Support Rating *", style: TextStyle(fontWeight: FontWeight.w500)),
                            Wrap(
                              spacing: 8.0, runSpacing: 8.0,
                              children: <Widget>[
                                _buildRadioChip('Very Easy', 'Very Easy'),
                                _buildRadioChip('Easy', 'Easy'),
                                _buildRadioChip('Neutral', 'Neutral'),
                                _buildRadioChip('Difficult', 'Difficult'),
                                _buildRadioChip('Very Difficult', 'Very Difficult'),
                              ],
                            ),
                            const SizedBox(height: 15),

                            // Customer Support Comment (Optional)
                            const Text("Detailed Comments (Optional)", style: TextStyle(fontWeight: FontWeight.w500)),
                            TextFormField(
                              controller: _commentController,
                              focusNode: _commentFocus,
                              maxLines: 3,
                              decoration: const InputDecoration(hintText: "Describe your interaction or provide suggestions...", suffixIcon: Icon(Icons.comment, color: Color(0xFF00bcd4))),
                            ),
                            
                            const Divider(height: 30, color: Colors.grey),

                            // --- Permission to Contact ---
                            const Text("Permission to Contact", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            
                            Row(
                              children: [
                                Checkbox(
                                  value: _permissionToContact,
                                  onChanged: (bool? newValue) => setState(() => _permissionToContact = newValue ?? false),
                                  activeColor: Theme.of(context).primaryColor,
                                ),
                                const Flexible(child: Text("Yes, I would like to receive follow-up contact or updates.", style: TextStyle(color: Colors.grey, fontSize: 13))),
                                const Spacer(),
                                const Icon(Icons.edit, color: Colors.grey, size: 16), 
                              ],
                            ),
                            
                            const Divider(height: 30, color: Colors.grey),

                            // --- Contact Information (MANDATORY: Name & Email) ---
                            const Text("Contact Information (Required)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),

                            // Name (MANDATORY)
                            TextFormField(
                              controller: _nameController,
                              focusNode: _nameFocus,
                              decoration: const InputDecoration(hintText: "Name", labelText: "Name *"),
                              validator: (value) => value!.isEmpty ? 'Name is required' : null,
                              onFieldSubmitted: (_) => _emailFocus.requestFocus(),
                            ),
                            const SizedBox(height: 15),
                            
                            // Email (MANDATORY + Format @gmail.com)
                            TextFormField(
                              controller: _emailController,
                              focusNode: _emailFocus,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(hintText: "Email", labelText: "Email (Must be @gmail.com) *"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Email is required';
                                }
                                if (!value.endsWith('@gmail.com')) {
                                  return 'Email must end with @gmail.com';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) => _roleFocus.requestFocus(),
                            ),
                            const SizedBox(height: 15),
                            
                            // Role/Company (Optional)
                            TextFormField(
                              controller: _roleController,
                              focusNode: _roleFocus,
                              decoration: const InputDecoration(hintText: "Role/Company (Optional)", labelText: "Role/Company"),
                            ),
                            
                            const SizedBox(height: 30),

                            // --- Submit Button ---
                            Center(
                              child: _HoverButton(
                                color: Theme.of(context).primaryColor,
                                onPressed: _submitFeedback,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('SUBMIT FEEDBACK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                      SizedBox(width: 8),
                                      Icon(Icons.send_rounded, color: Colors.white, size: 18),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Widget for Hover Effect on Buttons
class _HoverButton extends StatefulWidget {
  final Widget child;
  final Color color;
  final VoidCallback onPressed;

  const _HoverButton({required this.child, required this.color, required this.onPressed});

  @override
  State<_HoverButton> createState() => __HoverButtonState();
}

class __HoverButtonState extends State<_HoverButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 14),
          decoration: BoxDecoration(
            // REVISED: using withAlpha(255 * 0.85) = 217
            color: _isHovering ? widget.color.withAlpha(217) : widget.color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                // REVISED: using withAlpha(255 * 0.5) = 128
                color: widget.color.withAlpha(128),
                blurRadius: _isHovering ? 18 : 10,
                offset: Offset(0, _isHovering ? 2 : 5),
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

// Custom Dialog for Success Message
class _CustomDialog extends StatelessWidget {
  final String title;
  final String content;
  final String action1Text;
  final VoidCallback action1OnPressed;
  final String action2Text;
  final VoidCallback action2OnPressed;

  const _CustomDialog({
    required this.title, required this.content, required this.action1Text,
    required this.action1OnPressed, required this.action2Text, required this.action2OnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // REVISED: using withAlpha(255 * 0.98) = 250
      backgroundColor: Colors.white.withAlpha(250), 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        // REVISED: using withAlpha(255 * 0.5) = 128
        side: BorderSide(color: Theme.of(context).primaryColor.withAlpha(128), width: 2),
      ),
      title: Center(
        child: Text(
          title,
          style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      content: Text(
        content,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
      ),
      actions: <Widget>[
        // Action 2: Fill Again
        TextButton(
          onPressed: action2OnPressed,
          child: Text(action2Text, style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
        ),
        // Action 1: View Summary
        _HoverButton(
          color: Theme.of(context).primaryColor,
          onPressed: action1OnPressed,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text("View Summary", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
      actionsAlignment: MainAxisAlignment.spaceEvenly,
    );
  }
}