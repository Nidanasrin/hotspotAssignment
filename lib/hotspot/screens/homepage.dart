import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotspotassignment/hotspot/model/hot_model.dart';
import 'package:hotspotassignment/hotspot/screens/screen2.dart';
import 'package:hotspotassignment/hotspot/service/controller.dart';

class HomePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController textController = TextEditingController();
  final Set<int> selectedIds = {};

  @override
  void initState() {
    super.initState();
    // Fetch data when screen opens
    Future.microtask(() => ref.read(apiProvider.notifier).fetchData());
  }

  @override
  Widget build(BuildContext context) {
    final hotState = ref.watch(apiProvider);
    // final hotController = ref.watch(apiProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text('01',style: TextStyle(color: Colors.white24),),
              Center(
                child: Text(
                  'What kind of hotspots do you want to host?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (hotState.isLoading)
                Expanded(child: Center(child: CircularProgressIndicator()))
              else if (hotState.error != null)
                Expanded(
                  child: Center(
                    child: Text(
                      'Error : ${hotState.error}',
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),
                )
              else
                SizedBox(
                  height: 150,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: hotState.experience?.length ?? 0,
                    separatorBuilder: (_, _) => SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final Experience exp = hotState.experience![index];
                      final isSelected = selectedIds.contains(exp.id);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedIds.remove(exp.id);
                            } else {
                              selectedIds.add(exp.id!);
                            }
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          width: 130,
                          decoration: ShapeDecoration(shape: BeveledRectangleBorder(
                            //borderRadius: BorderRadius.circular(5),
                            // border: Border.all(
                            //   color: isSelected
                            //       ? Colors.deepPurple
                            //       : Colors.transparent,
                            //   width: 2,
                            // ),
                          ),
                            image: DecorationImage(
                              image: (exp.imageUrl != null && exp.imageUrl!.isNotEmpty)
                                ? NetworkImage(exp.imageUrl ?? ''):
                              AssetImage('assets/placeholder.jpg'),
                              fit: BoxFit.cover,
                              colorFilter: isSelected
                                  ? null
                                  : ColorFilter.mode(
                                      Colors.grey,
                                      BlendMode.saturation,
                                    ),
                            ),
                          ),
                          //alignment: Alignment.bottomCenter,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              //borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              SizedBox(height: 16),
              TextField(
                controller: textController,
                maxLines: 5,
                style: TextStyle(color: Colors.white),
                maxLength: 250,
                decoration: InputDecoration(
                  hintText: '/Describe your perfect hotspot',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  fillColor: Colors.white.withOpacity(0.1),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),contentPadding: EdgeInsets.all(16)
                ),
              ),
              SizedBox(height: 12),
              Center(child:
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: Colors.grey, width: 1),
                  backgroundColor:
                  Colors.black,
                  foregroundColor: Colors.white70,
                  padding: EdgeInsets.symmetric(horizontal: 140, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(12),
                  ),
                ),
                onPressed:
                  () {
                  debugPrint("Selected ID's :$selectedIds");
                  debugPrint('User input : ${textController.text}');
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Screen2(textController.text, selectedIds.toString())));
                },
                child: Text(
                  'Next',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              ),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}
