RSpec.describe DecksController, type: :request do
  specify 'empty list of course decks' do
    post '/courses', params: english_grammar, headers: { accept: 'application/json' }
    get "/courses/#{english_grammar[:course_uuid]}/decks",
        params: { course_uuid: english_grammar[:course_uuid] },
        headers: { accept: 'application/json' }

    expect(response).to have_http_status(200)
    expect(JSON.parse(response.body)).to eq([])
  end

  specify 'add a deck' do
    post '/courses', params: english_grammar, headers: { accept: 'application/json' }
    post "/courses/#{english_grammar[:course_uuid]}/decks",
         params: { course_uuid: english_grammar[:course_uuid], deck_uuid: phrasal_verbs[:deck_uuid] },
         headers: { accept: 'application/json' }

    expect(response).to have_http_status(204)
    expect(response.body).to eq('')

    get "/courses/#{english_grammar[:course_uuid]}/decks",
        params: { course_uuid: english_grammar[:course_uuid] },
        headers: { accept: 'application/json' }

    expect(response).to have_http_status(200)
    expect(JSON.parse(response.body)).to eq([phrasal_verbs.as_json])
  end

  specify 'remove a deck' do
    post '/courses', params: english_grammar, headers: { accept: 'application/json' }
    post "/courses/#{english_grammar[:course_uuid]}/decks",
         params: { course_uuid: english_grammar[:course_uuid], deck_uuid: phrasal_verbs[:deck_uuid] },
         headers: { accept: 'application/json' }
    delete "/courses/#{english_grammar[:course_uuid]}/decks/#{phrasal_verbs[:deck_uuid]}",
           params: { course_uuid: english_grammar[:course_uuid], deck_uuid: phrasal_verbs[:deck_uuid] },
           headers: { accept: 'application/json' }

    expect(response).to have_http_status(204)
    expect(response.body).to eq('')

    get "/courses/#{english_grammar[:course_uuid]}/decks",
        params: { course_uuid: english_grammar[:course_uuid] },
        headers: { accept: 'application/json' }

    expect(response).to have_http_status(200)
    expect(JSON.parse(response.body)).to eq([])
  end

  specify 'show empty deck' do
    get "/decks/#{phrasal_verbs[:deck_uuid]}/cards",
        params: { deck_uuid: phrasal_verbs[:deck_uuid] },
        headers: { accept: 'application/json' }
    expect(response).to have_http_status(200)
    expect(JSON.parse(response.body)).to eq([])
  end

  specify 'add card to deck' do
    post '/courses', params: english_grammar, headers: { accept: 'application/json' }
    post "/courses/#{english_grammar[:course_uuid]}/decks",
         params: { course_uuid: english_grammar[:course_uuid], deck_uuid: phrasal_verbs[:deck_uuid] },
         headers: { accept: 'application/json' }
    post "/decks/#{phrasal_verbs[:deck_uuid]}/add_card",
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

  specify 'remove card from deck' do
    post '/courses', params: english_grammar, headers: { accept: 'application/json' }
    post "/courses/#{english_grammar[:course_uuid]}/decks",
         params: { course_uuid: english_grammar[:course_uuid], deck_uuid: phrasal_verbs[:deck_uuid] },
         headers: { accept: 'application/json' }
    post "/decks/#{phrasal_verbs[:deck_uuid]}/add_card",
         params: { deck_uuid: phrasal_verbs[:deck_uuid], front: look_forward_to[:front], back: look_forward_to[:back] },
         headers: { accept: 'application/json' }
    expect(response).to have_http_status(204)
    expect(response.body).to eq('')

    delete "/decks/#{phrasal_verbs[:deck_uuid]}/remove_card", params: {
      deck_uuid: phrasal_verbs[:deck_uuid], front: look_forward_to[:front], back: look_forward_to[:back]
    }, headers: { accept: 'application/json' }
    expect(response).to have_http_status(204)
    expect(response.body).to eq('')

    get "/decks/#{phrasal_verbs[:deck_uuid]}/cards",
        params: { deck_uuid: phrasal_verbs[:deck_uuid] },
        headers: { accept: 'application/json' }
    expect(response).to have_http_status(200)
    expect(JSON.parse(response.body)).to eq([])
  end

  def english_grammar
    {
      course_uuid: 'e319e624-4449-4c90-9283-02300dcdd293',
      title: 'English Grammar'
    }
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
