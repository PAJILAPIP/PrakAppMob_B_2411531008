import 'package:flutter/material.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  //Global key untuk mengontrol form dan memicu validasi
  final _formKey = GlobalKey<FormState>();

  //controller untuk mengambil teks dari input
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();

  //state untuk dropdown
  String selectedCategory = 'Makanan';
  final List<String> categories = [
    'Makanan',
    'Transportasi',
    'Hiburan',
    'Lainnya'
  ];

  @override
  void dispose() {
    //Bersihkan controller saat halaman ditutup untuk mencegah memory leak
    _titleController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  //Fungsi untuk memilih tanggal dengan showDatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text =
            '${pickedDate.day.toString().padLeft(2, '0')}/'
            '${pickedDate.month.toString().padLeft(2, '0')}/'
            '${pickedDate.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catat Transaksi Baru'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      //SingleChildScrollView mencegah error layout saat keyboard muncul
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              //input 1: judul transaksi
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Transaksi',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              //Input 2: Nominal Saldo (keyboard angka)
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nominal (Rp)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nominal wajib diisi';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Harus berupa angka bulat yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              //Input 3: Kategori dropdown
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16.0),

              //Input 4: Tanggal Transaksi
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Tanggal Transaksi',
                  hintText: 'DD/MM/YYYY',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.calendar_today),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      _selectDate(context);
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),

              //Tombol simpan
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: () {
                  //Jalankan validasi
                  if (_formKey.currentState!.validate()) {
                    //Jika lolos validasi, tampilkan pop-up snackbar sukses
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Tersimpan: ${_titleController.text} '
                          '(Rp ${_amountController.text}) '
                          '- Tanggal: ${_dateController.text}',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: const Text(
                  'Simpan Transaksi',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}