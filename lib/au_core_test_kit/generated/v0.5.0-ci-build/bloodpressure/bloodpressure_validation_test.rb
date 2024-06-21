# frozen_string_literal: true

require_relative '../../../validation_test'

module AUCoreTestKit
  module AUCoreV050_CI_BUILD
    class BloodpressureValidationTest < Inferno::Test
      include AUCoreTestKit::ValidationTest

      id :au_core_v050_ci_build_bloodpressure_validation_test
      title 'Observation resources returned during previous tests conform to the AU Core Blood Pressure'
      description %(
This test verifies resources returned from the first search conform to
the [AU Core Blood Pressure](http://hl7.org.au/fhir/core/StructureDefinition/au-core-bloodpressure).
If at least one resource from the first search is invalid, the test will fail.

It verifies the presence of mandatory elements and that elements with
required bindings contain appropriate values. CodeableConcept element
bindings will fail if none of their codings have a code/system belonging
to the bound ValueSet. Quantity, Coding, and code element bindings will
fail if their code/system are not found in the valueset.

      )
      output :dar_code_found, :dar_extension_found

      def resource_type
        'Observation'
      end

      def scratch_resources
        scratch[:bloodpressure_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org.au/fhir/core/StructureDefinition/au-core-bloodpressure',
                                '0.5.0-ci-build',
                                skip_if_empty: true)
      end
    end
  end
end
