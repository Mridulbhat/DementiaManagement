import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();

  // List of options for the dropdown
  final List<String> _educationOptions = [
    'HSC',
    'SSC',
    'Graduate',
    'Option 4',
  ];

  final List<String> _sexOptions = [
    'Male',
    'Female',
  ];

  String? _selectedEducation;
  String? _selectedSex;

  // Boolean variables to manage the visibility of the password
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _passwordErrorMessage;
  String? _confirmPasswordErrorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/character.png',
                            width: 80,
                            height: 80,
                          ),
                          Image.asset(
                            'assets/character.png',
                            width: 80,
                            height: 80,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Hello Beautiful",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  _buildTextField("Full Name", (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                      return 'Name should only contain letters';
                    }
                    return null;
                  }),
                  _buildTextField("Age", (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    final age = int.tryParse(value);
                    if (age == null || age < 20 || age > 200) {
                      return 'Please enter a valid age between 20 and 200';
                    }
                    return null;
                  }, inputType: TextInputType.number),
                  _buildDropdownField("Sex", _sexOptions, (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your sex';
                    }
                    return null;
                  }, (newValue) {
                    setState(() {
                      _selectedSex = newValue;
                    });
                  }),
                  _buildTextField("Contact Number", (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your contact number';
                    }
                    final contactNumber = value.replaceAll(RegExp(r'\D'), '');
                    if (contactNumber.length != 10) {
                      return 'Contact number must be exactly 10 digits long';
                    }
                    return null;
                  }, inputType: TextInputType.phone),
                  _buildDropdownField("Education", _educationOptions, (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your education';
                    }
                    return null;
                  }, (newValue) {
                    setState(() {
                      _selectedEducation = newValue;
                    });
                  }),
                  _buildPasswordField("Create Password", _passwordController, _obscurePassword, (value) {
                    setState(() {
                      _obscurePassword = value;
                    });
                  }),
                  _buildPasswordField("Re-enter the password", _confirmPasswordController, _obscureConfirmPassword, (value) {
                    setState(() {
                      _obscureConfirmPassword = value;
                    });
                  }, originalController: _passwordController),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordErrorMessage = _validatePassword(_passwordController.text);
                        _confirmPasswordErrorMessage = _validateConfirmPassword(_confirmPasswordController.text, _passwordController.text);
                      });

                      if (_formKey.currentState!.validate()) {
                        // Handle form submission
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Processing Data')),
                        );
                        Navigator.pushNamed(context, '/otp');
                      }
                    },
                    child: Text("Next"),
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Navigate back to the login page
                    },
                    child: Text(
                      "Already have an account? Login",
                      style: TextStyle(
                        color: Colors.deepPurple,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, FormFieldValidator<String>? validator, {TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        keyboardType: inputType,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          labelText: label,
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> items, FormFieldValidator<String>? validator, ValueChanged<String?>? onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          labelText: label,
        ),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        validator: validator,
        onChanged: onChanged,
        value: label == "Sex" ? _selectedSex : _selectedEducation,
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool obscureText, ValueChanged<bool> onVisibilityToggle, {TextEditingController? originalController}) {
    bool hasError = label == "Create Password" ? _passwordErrorMessage != null : _confirmPasswordErrorMessage != null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              labelText: label,
              suffixIcon: IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  onVisibilityToggle(!obscureText);
                },
              ),
              errorText: hasError ? (label == "Create Password" ? _passwordErrorMessage : _confirmPasswordErrorMessage) : null,
              errorBorder: hasError
                  ? OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(8),
                    )
                  : null,
              focusedErrorBorder: hasError
                  ? OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(8),
                    )
                  : null,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (label == "Create Password") {
                if (value.length < 9) {
                  return 'Password must be at least 9 characters long';
                }
                if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$%^&+=_]).*$').hasMatch(value)) {
                  return 'Password must include at least 1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character';
                }
              }
              if (originalController != null && value != originalController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          if (label == "Create Password" && hasError)
            Padding(
              padding: const EdgeInsets.only(top: 2.0), // Adjust this value as needed
              child: Row(
                children: [
                  // Expanded(
                  //   child: Text(
                  //     'Password must include at least 1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character',
                  //     style: TextStyle(color: Colors.red),
                  //   ),
                  // ),
                  IconButton(
                    icon: Icon(
                      Icons.info_outline,
                      color: Color.fromARGB(255, 202, 89, 81),
                      size: 20,
                    ),
                    onPressed: () => _showPasswordRequirementsDialog(context),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Please enter a password';
    }
    if (password.length < 9) {
      return 'Password must be at least 9 characters long';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$%^&+=_]).*$').hasMatch(password)) {
      return 'Password must include at least 1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character';
    }
    return null;
  }

  String? _validateConfirmPassword(String confirmPassword, String originalPassword) {
    if (confirmPassword.isEmpty) {
      return 'Please re-enter the password';
    }
    if (confirmPassword != originalPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _showPasswordRequirementsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Password Requirements"),
          content: Text(
              "Your password must be at least 9 characters long and include:\n- At least 1 uppercase letter\n- At least 1 lowercase letter\n- At least 1 number\n- At least 1 special character (@, #, \$, %, etc.)"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
