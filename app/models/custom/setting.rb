require_dependency Rails.root.join("app", "models", "setting").to_s

class Setting
  class << self
    alias_method :consul_defaults, :defaults

    def defaults
      consul_defaults.merge({
        "contact.address": "Pazo de Raxoi. Praza do Obradoiro",
        "contact.email": "datosabertos@santiagodecompostela.gal",
        "contact.phone_1": "+34981542300",
        "contact.phone_2": "+34981542357",
        "facebook_handle": "concellosantiago",
        "feature.facebook_login": false,
        "feature.google_login": false,
        "feature.twitter_login": false,
        "org_name": "Portal de participación ciudadana - Concello de Santiago de Compostela",
        "remote_census.general.endpoint": Rails.application.secrets.census_api_end_point,
        "remote_census.request.method_name": "confirma_padron",
        "remote_census.request.structure": %Q({ "confirma_padron_entrada":
          {
            "dni": "null",
            "tns:data_nac": "null",
            "appkey": "#{Rails.application.secrets.census_api_institution_code}"
          }
        }),
        "remote_census.request.document_type": nil,
        "remote_census.request.document_number": "confirma_padron_entrada.dni",
        "remote_census.request.date_of_birth": "confirma_padron_entrada.tns:data_nac",
        "remote_census.request.postal_code": nil,
        "remote_census.response.date_of_birth": nil,
        "remote_census.response.postal_code": nil,
        "remote_census.response.district": "confirma_padron_response.return.distrito",
        "remote_census.response.gender": nil,
        "remote_census.response.name": nil,
        "remote_census.response.surname": nil,
        "remote_census.response.valid": "confirma_padron_response.return.distrito",
        "twitter_handle": "pazoderaxoi",
        "youtube_handle": "channel/UCSrcC2UgDHIb80vVVRtvoDw"
      })
    end
  end
end
