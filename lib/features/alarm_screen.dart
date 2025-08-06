import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../common_widgets/primary_button.dart';
import '../helpers/notification_service.dart';

class AlarmScreen extends StatefulWidget {
  final Position position;
  final String address;

  const AlarmScreen({
    Key? key,
    required this.position,
    required this.address,
  }) : super(key: key);

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final List<Map<String, dynamic>> _alarms = [];

  Future<void> _pickAlarmTime() async {
    DateTime? selectedDateTime = await showOmniDateTimePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(seconds: 5)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      is24HourMode: false,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
    );

    if (selectedDateTime != null) {
      final int alarmId = _alarms.length;
      final int followUpId = alarmId + 1000;
      final DateTime followUpTime = selectedDateTime.add(const Duration(seconds: 15));

      setState(() {
        _alarms.add({
          'id': alarmId,
          'date': selectedDateTime,
          'enabled': true,
        });
      });

      await NotificationService.scheduleAlarmNotification(
        id: alarmId,
        dateTime: selectedDateTime,
        title: '⏰ Alarm',
        body: 'Your alarm for ${DateFormat.jm().format(selectedDateTime)} is ringing!',
      );

      await NotificationService.scheduleAlarmNotification(
        id: followUpId,
        dateTime: followUpTime,
        title: '✅ Alarm Completed',
        body: 'The alarm has ended. Hope you’re up!',
      );

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Alarm set for ${DateFormat.yMd().add_jm().format(selectedDateTime)}"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 41, 2, 2),
        elevation: 0,
        title: const Text("Alarm Manager"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Location:",
              style: AppTextStyles.subtitle.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white70),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.address,
                    style: AppTextStyles.subtitle.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // ⏰ Add Alarm Button
            PrimaryButton(
              text: "⏰ Add Alarm",
              icon: Icons.alarm_add_outlined,
              onPressed: _pickAlarmTime,
            ),

            const SizedBox(height: 32),
            Text(
              "Scheduled Alarms",
              style: AppTextStyles.title.copyWith(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 16),

            // Alarm List
            Expanded(
              child: _alarms.isEmpty
                  ? const Center(
                      child: Text(
                        "No alarms scheduled yet.",
                        style: TextStyle(color: Colors.white54),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _alarms.length,
                      itemBuilder: (context, index) {
                        final alarm = _alarms[index];
                        final date = alarm['date'] as DateTime;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[850],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat.yMd().add_jm().format(date),
                                style: AppTextStyles.subtitle.copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              Switch(
                                value: alarm['enabled'],
                                onChanged: (val) {
                                  setState(() {
                                    alarm['enabled'] = val;
                                  });
                                },
                                activeColor: Colors.purpleAccent,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
