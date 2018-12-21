RSpec.describe CardsController, type: :request do
  specify 'empty deck' do
    get "/decks/#{phrasal_verbs[:deck_uuid]}/cards",
        params: { deck_uuid: phrasal_verbs[:deck_uuid] },
        headers: { accept: 'application/json' }
    expect(response).to have_http_status(200)
    expect(JSON.parse(response.body)).to eq([])
  end

  specify 'add card to deck' do
    post "/decks/#{phrasal_verbs[:deck_uuid]}/cards",
         params: { deck_uuid: phrasal_verbs[:deck_uuid], front: look_forward_to[:front], back: look_forward_to[:back] },
         headers: { accept: 'application/json' }
    expect(response).to have_http_status(204)
    expect(response.body).to eq('')

    get "/decks/#{phrasal_verbs[:deck_uuid]}/cards",
        params: { deck_uuid: phrasal_verbs[:deck_uuid] },
        headers: { accept: 'application/json' }
    expect(response).to have_http_status(200)
    expect(JSON.parse(response.body)).to eq([look_forward_to.as_json])
  end

  def phrasal_verbs
    {
      deck_uuid: '856a739c-e18c-4831-8958-695feccd2d73'
    }
  end

  def look_forward_to
    {
      front: 'Look forward to',
      back: 'To be pleased about sth that is going to happen'
    }
  end
end
