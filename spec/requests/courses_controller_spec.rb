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
    expect(JSON.parse(response.body)).to eq(english_grammar)
  end

  def english_grammar
    {
      uuid: 'e319e624-4449-4c90-9283-02300dcdd293'
    }
  end
end
