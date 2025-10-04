import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/features/operation-or-task/data/model/assigned_employee_status_model.dart';
import 'package:dazzles/features/operation-or-task/data/provider/operation%20controller.dart/operation_controller.dart';
import 'package:dazzles/features/operation-or-task/data/provider/operation%20controller.dart/operation_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OperationAssigedEmployeesView extends ConsumerStatefulWidget {
  final String operationId;

  const OperationAssigedEmployeesView({super.key, required this.operationId});

  @override
  ConsumerState<OperationAssigedEmployeesView> createState() =>
      _OperationAssigedEmployeesViewState();
}

class _OperationAssigedEmployeesViewState
    extends ConsumerState<OperationAssigedEmployeesView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  String? _deletingEmployeeId;
  String _filterStatus = 'all'; // all, completed, pending, expired

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    Future.microtask(() {
      ref
          .read(operationControllerProvider.notifier)
          .onGetAssignedEmployeeStatus(widget.operationId);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<AssignedEmployeeStatusModel> _getFilteredEmployees(
      List<AssignedEmployeeStatusModel> employees) {
    if (_filterStatus == 'all') return employees;
    return employees
        .where((e) => e.status.toLowerCase() == _filterStatus)
        .toList();
  }

  Map<String, int> _getStatusCounts(
      List<AssignedEmployeeStatusModel> employees) {
    return {
      'all': employees.length,
      'completed':
          employees.where((e) => e.status.toLowerCase() == 'completed').length,
      'pending':
          employees.where((e) => e.status.toLowerCase() == 'pending').length,
      // 'expired': employees.where((e) => e.status.toLowerCase() == 'expired').length,
    };
  }

  @override
  Widget build(BuildContext context) {
    final state =
        ref.watch(operationControllerProvider).value ?? OperationState();
    final isLoading = state.isLoadingAssignedEmployeesList;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const AppBarText(title: "Assigned Employees"),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        actions: [
          IconButton(
            onPressed: () {
              ref
                  .read(operationControllerProvider.notifier)
                  .onGetAssignedEmployeeStatus(widget.operationId);
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: AppLoading())
          : state.assignedEmployeesStatus.isEmpty
              ? _buildEmptyState(theme)
              : _buildEmployeesList(context, state, theme),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: AppMargin(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_off,
                size: 80,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Employees Assigned',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This task has not been assigned to any employees yet.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeesList(
      BuildContext context, OperationState state, ThemeData theme) {
    final statusCounts = _getStatusCounts(state.assignedEmployeesStatus);
    final filteredEmployees =
        _getFilteredEmployees(state.assignedEmployeesStatus);

    return Column(
      children: [
        // Statistics Cards
        _buildStatisticsSection(statusCounts, theme),

        // Filter Chips
        _buildFilterChips(statusCounts, theme),

        // Employees List
        Expanded(
          child: filteredEmployees.isEmpty
              ? _buildNoResultsState(theme)
              : AppMargin(
                  child: RefreshIndicator.adaptive(
                    onRefresh: () async {
                      await ref
                          .read(operationControllerProvider.notifier)
                          .onGetAssignedEmployeeStatus(widget.operationId);
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 16),
                      itemCount: filteredEmployees.length,
                      itemBuilder: (context, index) {
                        return _buildEmployeeCard(
                          filteredEmployees[index],
                          theme,
                          index,
                        );
                      },
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildStatisticsSection(Map<String, int> counts, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.1),
            theme.colorScheme.primary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
              'Total', counts['all']!, Icons.people, theme.colorScheme.primary),
          _buildStatDivider(theme),
          _buildStatItem('Completed', counts['completed']!, Icons.check_circle,
              Colors.green),
          _buildStatDivider(theme),
          _buildStatItem(
              'Pending', counts['pending']!, Icons.pending, Colors.orange),
          // _buildStatDivider(theme),
          // _buildStatItem('Expired', counts['expired']!, Icons.exit_to_app, Colors.red),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider(ThemeData theme) {
    return Container(
      width: 1,
      height: 40,
      color: theme.dividerColor,
    );
  }

  Widget _buildFilterChips(Map<String, int> counts, ThemeData theme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildFilterChip('All', 'all', counts['all']!, theme),
          const SizedBox(width: 8),
          _buildFilterChip(
              'Completed', 'completed', counts['completed']!, theme),
          const SizedBox(width: 8),
          _buildFilterChip('Pending', 'pending', counts['pending']!, theme),
          // const SizedBox(width: 8),
          // _buildFilterChip('Expired', 'expired', counts['expired']!, theme),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
      String label, String value, int count, ThemeData theme) {
    final isSelected = _filterStatus == value;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (count > 0) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color:
                    isSelected ? theme.colorScheme.onPrimary : AppColors.kWhite,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? AppColors.kWhite
                      : theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filterStatus = value;
        });
      },
      backgroundColor: theme.colorScheme.surface,
      selectedColor: AppColors.kWhite,
      checkmarkColor: theme.colorScheme.onPrimary,
      labelStyle: TextStyle(
        color: isSelected
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildNoResultsState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No employees found',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try changing the filter',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeCard(
      AssignedEmployeeStatusModel model, ThemeData theme, int index) {
    final statusInfo = _getStatusInfo(model.status);
    final isDeleting = _deletingEmployeeId == model.employeeId.toString();

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: statusInfo.color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  statusInfo.color.withOpacity(0.05),
                  statusInfo.color.withOpacity(0.02),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    children: [
                      // Avatar
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: statusInfo.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            _getInitials(model.employeeName),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: statusInfo.color,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Employee Name & Status
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              model.employeeName,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusInfo.color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: statusInfo.color.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    statusInfo.icon,
                                    size: 14,
                                    color: statusInfo.color,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    statusInfo.label,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: statusInfo.color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Delete Button
                      IconButton(
                        onPressed: isDeleting
                            ? null
                            : () => _showDeleteConfirmation(model),
                        icon: isDeleting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(CupertinoIcons.delete),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.red.withOpacity(0.1),
                          foregroundColor: Colors.red,
                        ),
                        tooltip: 'Remove from task',
                      ),
                    ],
                  ),

                  const Divider(height: 24),

                  // Task Details
                  _buildDetailRow(
                    'Operation',
                    model.operationName,
                    Icons.task_alt,
                    theme,
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    'Schedule Type',
                    model.scheduleType.toUpperCase(),
                    _getScheduleIcon(model.scheduleType),
                    theme,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      String label, String value, IconData icon, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  IconData _getScheduleIcon(String scheduleType) {
    switch (scheduleType.toLowerCase()) {
      case 'once':
        return Icons.calendar_today;
      case 'daily':
        return Icons.repeat;
      default:
        return Icons.schedule;
    }
  }

  StatusInfo _getStatusInfo(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return StatusInfo(
          label: 'Completed',
          icon: Icons.check_circle,
          color: Colors.green,
        );
      case 'pending':
        return StatusInfo(
          label: 'Pending',
          icon: Icons.pending,
          color: Colors.orange,
        );
      // case 'expired':
      //   return StatusInfo(
      //     label: 'Expired',
      //     icon: Icons.exit_to_app,
      //     color: Colors.red,
      //   );
      default:
        return StatusInfo(
          label: 'Unknown',
          icon: Icons.help,
          color: Colors.grey,
        );
    }
  }

  void _showDeleteConfirmation(AssignedEmployeeStatusModel model) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('Remove Employee'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Are you sure you want to remove this employee from the task?'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.person, size: 16, color: Colors.red),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          model.employeeName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.task, size: 16, color: Colors.red),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          model.operationName,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
               style: AppStyle.smallStyle(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteEmployee(model);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteEmployee(AssignedEmployeeStatusModel model) async {
    setState(() {
      _deletingEmployeeId = model.employeeId.toString();
    });

    try {
      // // Call your delete API here
      await ref
          .read(operationControllerProvider.notifier)
          .removeEmployeeFromTask(
              model.assignedId, widget.operationId.toString());

      // Simulate API call
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Failed to remove: ${e.toString()}')),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _deletingEmployeeId = null;
        });
      }
    }
  }
}

class StatusInfo {
  final String label;
  final IconData icon;
  final Color color;

  StatusInfo({
    required this.label,
    required this.icon,
    required this.color,
  });
}
