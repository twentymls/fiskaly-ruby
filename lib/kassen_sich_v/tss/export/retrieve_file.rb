module FiskalyService
  module KassenSichV
    module TSS
      module Export
        # This endpoint returns the TAR file generated by the export operation.
        class RetrieveFile < Base
          attr_reader :tss_id, :export_id

          # @param token [String] JWT token
          # @param tss_id [String] TSS UUID
          # @param export_id [String] Identifies an Export
          # @return [FiskalyService::KassenSichV::TSS::Export::Retrieve] The Retrieved object
          def initialize(token:, tss_id:, export_id:)
            super(token: token)

            @tss_id = tss_id
            @export_id = export_id
          end

          # Retrive a specific export file
          #
          # @return [Hash] Formatted response informations
          def call
            request = self.class.get("/tss/#{tss_id}/export/#{export_id}/file", headers: headers)

            handle_request(request)
          end

          private

          def handle_request(request)
            if request.success?
              {
                status: :ok,
                body: request.response.body
              }
            else
              {
                status: :error,
                message: request.response.message,
                body: JSON.parse(request.response.body)
              }
            end
          end
        end
      end
    end
  end
end