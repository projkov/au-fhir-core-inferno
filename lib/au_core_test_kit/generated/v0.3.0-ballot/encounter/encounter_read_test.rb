require_relative '../../../read_test'

module AUCoreTestKit
  module AUCoreV030_BALLOT
    class EncounterReadTest < Inferno::Test
      include AUCoreTestKit::ReadTest

      title 'Server returns correct Encounter resource from Encounter read interaction'
      description 'A server SHALL support the Encounter read interaction.'

      id :au_core_v030_ballot_encounter_read_test

      def resource_type
        'Encounter'
      end

      def scratch_resources
        scratch[:encounter_resources] ||= {}
      end

      run do
        perform_read_test(all_scratch_resources)
      end
    end
  end
end