RSpec.describe 'Courses', type: :request do
  specify 'empty list of courses' do
    get '/courses', headers: { accept: 'application/json' }
    expect(response).to have_http_status(200)
    expect(JSON.parse(response.body)).to eq([])
  end
end
