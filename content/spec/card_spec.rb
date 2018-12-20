module Content
  RSpec.describe 'Card value object' do
    let(:front) { 'look forward to' }
    let(:other_front) { 'look into' }
    let(:back) { 'to be pleased about sth that is going to happen' }
    let(:other_back) { 'to investigate, to research' }

    it { expect { Content::Card.new(front, nil).to raise_error(Content::Card::InvalidFormat) } }
    it { expect { Content::Card.new(nil, back).to raise_error(Content::Card::InvalidFormat) } }

    it { expect { Content::Card.new(front, back).front.to eq front } }
    it { expect { Content::Card.new(front, back).back.to eq back } }

    it { expect { Content::Card.new(front, back).to eq Content::Card.new(front, back) } }
    it { expect { Content::Card.new(front, back).not_to eq Content::Card.new(front, other_back) } }
    it { expect { Content::Card.new(front, back).not_to eq Content::Card.new(other_front, back) } }
    it { expect { Content::Card.new(front, back).not_to eq Content::Card.new(other_front, other_back) } }
  end
end
