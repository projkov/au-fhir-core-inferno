# frozen_string_literal: true

require_relative '../../../chained_search_test'
require_relative '../../../generator/group_metadata'

module AUCoreTestKit
  module AUCoreV040_CI_BUILD
    class DiagnosticresultPathPatientChainSearchTest < Inferno::Test
      include AUCoreTestKit::ChainedSearchTest

      title '(SHOULD) Server returns valid results for Observation search by patient (chained parameters)'
      description %(A server SHOULD support searching by
patient:Patient.identifier on the Observation resource. This test
will pass if the server returns a success response to the request.

[AU Core Server CapabilityStatement](http://hl7.org.au/fhir/core//CapabilityStatement-au-core-server.html)
)

      id :au_core_v040_ci_build_diagnosticresult_path_patient_chain_search_test

      optional

      input :patient_ids,
            title: 'Patient IDs',
            description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements',
            default: 'bennelong-anne, smith-emma, baby-smith-john, dan-harry, italia-sofia, wang-li'

      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'Observation',
          search_param_names: ['patient:Patient.identifier'],
          attr_paths: ['subject']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:diagnosticresult_path_resources] ||= {}
      end

      run do
        run_chain_search_test
      end
    end
  end
end
