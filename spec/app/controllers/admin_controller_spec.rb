require 'spec_helper'

describe "standard messages" do

  it 'passes just because' do
    get "/admin"
    expect(last_response.body).not_to be_empty

  end

end
