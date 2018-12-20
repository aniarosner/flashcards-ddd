RSpec.describe CardsController, type: :request do
  specify 'empty deck' do
    get "/decks/#{phrasal_verbs[:deck_uuid]}/cards",
        params: { deck_uuid: phrasal_verbs[:deck_uuid] },
        headers: { accept: 'application/json' }
    expect(response).to have_http_status(200)
    expect(JSON.parse(response.body)).to eq([])
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
