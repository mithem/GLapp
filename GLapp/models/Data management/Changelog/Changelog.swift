//
//  Changelog.swift
//  GLapp
//
//  Created by Miguel Themann on 03.02.22.
//

import SwiftUI
import Semver

struct Changelog {
    /// All version updates from day 1 (or so) to this current version. But **reversed** (from current to old).
    static let versionUpdates: [VersionUpdate] = [
        .init(version: "1.4.0", new: [
            "e_changelog",
            "version_update_promos",
            "button_for_rating_in_app_store",
            "automatic_rating_requests"
        ], improved: [], fixed: [
            "re-add_keyboard_shortcut_for_navigating_to_timetable_p_as_that_was_lost_for_some_reason_p"
        ], promos: [
            .init(titleKey: "changelog", descriptionKey: "detailed_changelog_over_all_versions", symbol: {
                Image(systemName: "text.badge.plus")
            }),
            .init(titleKey: "version_update_promos", descriptionKey: "showing_on_each_relevant_app_update", symbol: {
                Image(systemName: "square.and.arrow.down")
            }),
            .init(titleKey: "automatic_rating_requests", descriptionKey: "making_sure_not_to_bug_you", symbol: {
                Image(systemName: "text.badge.star")
            })
        ], note: "functionality_check_still_available_manually")!,
        
        .init(version: "1.3.1", new: [], improved: [
            "e_support_for_up_to_19_lessons_a_day",
            "even_more_resilience_when_parsing_timetable",
            "optimizations_for_binary_size"
        ], fixed: [
            "e_typos"
        ], promos: [], note: nil)!,
        
        .init(version: "1.3.0", new: [
            "support_for_user_authentication_passcode_touchid_faceid",
            "auto_settings_repair_mechanism"
        ], improved: [
            "better_notifications_of_repr_plan",
            "discard_invalid_repr_lessons_in_notifications",
            "e_support_for_up_to_12_lessons_a_day",
            "more_resilience_when_parsing_data",
            "show_data_for_invalid_repr_lessons"
        ], fixed: [
            "some_settings_not_reloading",
            "additional_information_on_repr_plan_being_parsed"
        ], promos: [
            .init(titleKey: "feature_authentication_title", descriptionKey: "feature_authentication_description", symbol: {
                Image(systemName: "faceid")
            })
        ], note: nil)!,
        
        .init(version: "1.2.3", new: [
            "option_for_choosing_minimal_time_interval_between_repr_plan_checks"
        ], improved: [], fixed: [
            "recreate_demo_events",
            "delete_demo_events_when_deactivating_demo_mode",
            "no_demo_event_duplication"
        ], promos: [], note: nil)!,
        
        .init(version: "1.2.2", new: [
            "option_to_always_deliver_class_test_reminders_at_a_fixed_manually_configurable_time",
            "button_to_reset_preferences"
        ], improved: [
            "separate_views_for_general_and_class_test_reminder_related_settings",
            "more_resilience_when_parsing_timetable"
        ], fixed: [], promos: [], note: nil)!,
        
        .init(version: "1.2.1", new: [
            "haptic_feedback_when_changing_stepper_values"
        ], improved: [
            "show_functionality_check_on_appropriate_app_update",
            "reset_app_data_when_downgrading_as_a_precaution",
            "increase_relative_precision_when_showing_time_interval_until_class_test_thats_not_far_away"
        ], fixed: [
            "dont_trigger_haptic_feedback_when_launching_app",
            "bug_fixes",
            "grey_out_passed_class_tests",
            "more_precise_countdown_for_upcoming_class_tests"
        ], promos: [], note: nil)!,
        
        .init(version: "1.2.0", new: [
            "option_for_adjusting_the_time_interval_required_for_a_repr_lesson_to_be_of_high_relevance",
            "support_for_shortcuts_app",
            "integrate_user_activity_into_system",
            "option_to_disable_saving_last_repr_plan_update_timestamp",
            "log_in_button_in_settings_when_not_logged_in",
            "support_for_spotlight_optional",
            "button_to_regenerate_colors"
        ], improved: [
            "add_explainer_for_notification_relevance_system",
            "only_repr_plan_updates_sent_via_notifications",
            "support_for_provisional_or_ephemeral_notifications_requested_on_first_launch",
            "show_changelog_when_updating_versions_feature_updates_only",
            "force_ask_for_notification_permissions_when_enabling_features_requiring_notifications_and_provisional_ones_are_enabled",
            "more_robust_data_saving",
            "detect_semi_enabled_functionalities",
            "add_more_context_menu_to_repr_lessons"
        ], fixed: [
            "notifications_being_scheduled_without_time_sensitivity_regardless_of_relevance",
            "ui_irregularities_esp_for_secondary_stage_I",
            "sync_class_test_subjects_with_timetable",
            "bug_fixes",
            "crashes"
        ], promos: [
            .init(titleKey: "support_for_shortcuts_app", descriptionKey: "shortcuts_for_repr_plan_timetable_and_class_test_plan", symbol: {
                Image(systemName: "hourglass")
            }),
            .init(titleKey: "support_for_spotlight", descriptionKey: "feature_spotlight_integration_description", symbol: {
                Image(systemName: "magnifyingglass")
            })
        ], note: "this_update_removes_support_for_iPadOS_multiple_windows")!,
        
        .init(version: "1.1.1", new: [], improved: [], fixed: [
            "automatic_reloading_of_data_changed_in_background",
            "disorganized_colors_of_timetable_on_first_launch",
            "handling_of_server_errors"
        ], promos: [], note: nil)!,
        
        .init(version: "1.1.0", new: [
            "keyboard_shortcuts_for_navigating_in_ipad_os",
            "indication_in_tab_bar_icon_when_repr_plan_has_items",
            "option_to_automatically_add_class_tests_to_calendar",
            "option_for_class_tests_and_repr_lessons_to_use_subject_color"
        ], improved: [
            "optimizations_for_secondary_stage_I",
            "tweak_colors_for_better_readability_for_all_appearances",
            "show_notifications_even_when_app_is_in_foreground",
            "give_feedback_when_certain_functionality_cant_be_enabled",
            "remove_delivered_class_test_reminders_only_after_class_test_is_over"
        ], fixed: [
            "repr_plan_updates_being_sent_out_constantly",
            "not_localized_repr_plan_update_title",
            "no_color_for_rewrite_class_tests",
            "navigation_not_working_on_ipad_os_in_split_screen",
            "class_test_reminders"
        ], promos: [
            .init(titleKey: "navigation_keyboard_shortcuts", descriptionKey: "for_navigating_in_app", symbol: {
                Image(systemName: "keyboard")
            }),
            .init(titleKey: "indication_in_tab_bar_icon", descriptionKey: "only_shows_when_repr_plan_has_items", symbol: {
                Image(systemName: "clock.badge.exclamationmark")
            }),
            .init(titleKey: "feature_class_test_calendar_events_title", descriptionKey: "feature_class_test_calendar_events_description", symbol: {
                Image(systemName: "calendar")
            }),
            .init(titleKey: "color_subjects", descriptionKey: "color_text_in_subject_color", symbol: {
                Image(systemName: "arrow.left.arrow.right")
            })
        ], note: nil)!,
        
        .init(version: "1.0.1", new: [], improved: [], fixed: [
            "ui_for_large_dynamic_type_sizes_with_little_screen_real_estate"
        ], promos: [], note: nil)!,
        
        .init(version: "1.0.0", new: [], improved: [], fixed: [], promos: [], note: "initial_release_e!_thanks_for_downloading!")!
    ]
    
    enum GetVersionUpdateError: Error {
        case versionNotFound
    }
    
    /// Compose a version update till the newest (now running) version with all ChangelogItems & promotions from the updates between `lastVersion` & the current one.
    static func getVersionUpdate(since lastVersion: Semver) throws -> VersionUpdate? {
        if lastVersion == Changelog.currentVersion {
            return nil
        }
        
        var new = [ChangelogItem]()
        var improved = [ChangelogItem]()
        var fixed = [ChangelogItem]()
        var promos = [FeaturePromo]()
        var notes = [String]()
        
        guard let lastVersionIndex = versionUpdates.firstIndex(where: {$0.version == lastVersion}) else { throw GetVersionUpdateError.versionNotFound }
        
        for idx in 0..<lastVersionIndex {
            new.append(contentsOf: versionUpdates[idx].new)
            improved.append(contentsOf: versionUpdates[idx].improved)
            fixed.append(contentsOf: versionUpdates[idx].fixed)
            promos.append(contentsOf: versionUpdates[idx].promos)
            if let note = versionUpdates[idx].note {
                notes.append(note)
            }
        }
        
        return .init(version: Changelog.currentVersion, new: new, improved: improved, fixed: fixed, promos: promos, note: notes.joined(separator: "\n"))
    }
    
    static let currentVersion: Semver = versionUpdates.first!.version
}
