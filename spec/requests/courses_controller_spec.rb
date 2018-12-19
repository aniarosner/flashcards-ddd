RSpec.describe 'Courses', type: :request do
  specify 'empty list of courses' do
    get '/courses', headers: { accept: 'application/json' }
    expect(response).to have_http_status(200)
    expect(JSON.parse(response.body)).to eq([])
  end

  specify 'add new course' do
    post '/courses', params: english_grammar, headers: { accept: 'application/json' }
    expect(response).to have_http_status(204)
    expect(response.body).to eq('')

    get '/courses', headers: { accept: 'application/json' }

    expect(JSON.parse(response.body)).to eq([english_grammar.as_json])
  end

  specify 'remove a course' do
    post '/courses', params: english_grammar, headers: { accept: 'application/json' }
    delete "/courses/#{english_grammar[:course_uuid]}",
           params: { course_uuid: english_grammar[:course_uuid] },
           headers: { accept: 'application/json' }
    expect(response).to have_http_status(204)
    expect(response.body).to eq('')

    get '/courses', headers: { accept: 'application/json' }
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
end
