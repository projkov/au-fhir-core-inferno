# frozen_string_literal: true

require_relative 'search_test_properties'
require_relative 'search_test'

module AUCoreTestKit
  module ChainedSearchTest
    extend Forwardable
    include SearchTest

    def_delegators 'self.class', :metadata, :provenance_metadata, :properties
    def_delegators 'properties',
                   :resource_type,
                   :search_param_names,
                   :attr_paths,
                   :target_identifier

    def extract_target_resource_from_chained_search_parameter(search_param)
      search_param.split(':').second.split('.').first
    end

    def get_resources_identifier(resources, target_identifier)
      if !target_identifier
        resources.map(&:identifier).flatten
      else
        resources.map do |r|
          r.identifier.filter { |idnt| idnt.system == target_identifier[:url] }
        end.flatten
      end
    end

    def all_chain_identifier_values(patient_id_list, all_resources, chain_target, target_identifier)
      patient_id_list.map do |patient_id|
        next unless !all_resources.nil? && all_resources.include?(patient_id)

        resource_identifiers = get_resources_identifier(
          all_resources[patient_id].filter { |r| r.resourceType == chain_target },
          target_identifier
        )
        resource_identifiers.map do |identifier|
          { patient_id:, identifier: }
        end
      end.flatten
    end

    def run_chain_search_test
      run_chain_search_test_clean(
        search_param_names[0],
        patient_id_list,
        scratch[:patient_resources],
        attr_paths,
        target_identifier
      )
    end

    def pick_identifier_to_test(patient_id_list, all_patients_resources, search_param, target_identifier)
      all_chain_identifier_values(
        patient_id_list,
        all_patients_resources,
        extract_target_resource_from_chained_search_parameter(search_param),
        target_identifier
      ).sample
    end

    def assert_returned_resources_valid(resources_returned, identifier_to_test, attr_paths)
      existing_values = resources_returned.map do |rr|
        attr_paths.map do |attr_path|
          resolve_path(rr, attr_path).first.reference.split('/').second
        end
      end.flatten.compact.uniq

      assert (existing_values.include? identifier_to_test[:patient_id]),
             'There is no reference to the target resource in the returned results.'
    end

    def run_chain_search_test_clean(search_param, patient_id_list, all_patients_resources, attr_paths, target_identifier)
      identifier_to_test = pick_identifier_to_test(patient_id_list, all_patients_resources, search_param, target_identifier)
      skip_if identifier_to_test.nil?, "I don't have values to perform search"

      values_to_test = [
        "#{identifier_to_test[:identifier].system}|#{identifier_to_test[:identifier].value}"
      ]

      values_to_test.each do |idnt_value|
        search_and_check_response({ search_param => idnt_value })
      end

      assert_returned_resources_valid(fetch_all_bundled_resources.select { |resource| resource.resourceType == resource_type }, identifier_to_test, attr_paths)
    end
  end
end
