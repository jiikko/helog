require "spec_helper"

RSpec.describe Helog::Fetcher do
  let(:logs) do
    <<~LOGS
2018-04-13T13:52:55.116206+00:00 app[web.6]: [6f26797e-49d7-497e-908a-dad1ee3c97c8] Started GET "/t=true&verbose=true" for 111.1073 at 2018-04-13 13:52:55 +0000
2018-04-13T13:52:55.118953+00:00 app[web.6]: [6f26797e-49d7-497e-908a-dad1ee3c97c8] Processing by HogeController#indexas */*
2018-04-13T13:52:55.119033+00:00 app[web.6]: [6f26797e-49d7-497e-908a-dad1ee3c97c8]   Parameters: {"group"=>"true", "limit"=>"400", "since"=>"2017-04-07T13:42:01Z", "total_count"=>"true", "verbose"=>"true"}
2018-04-13T13:52:55.129041+00:00 app[web.6]: [6f26797e-49d7-497e-908a-dad1ee3c97c8] [account_id:1111111111]
2018-04-13T13:52:55.148496+00:00 app[web.6]: [6f26797e-49d7-497e-908a-dad1ee3c97c8] Completed 304 Not Modified in 29ms (ActiveRecord: 6.2ms)
2018-04-13T13:52:55.155468+00:00 heroku[router]: at=info method=GET path="/e" host=uuuuu.com request_id=6f26797e-49d7-497e-908a-dad1ee3c97c8 fwd="" dyno=web.6 connect=1ms service=44ms status=304 bytes=300 protocol=https
2018-04-13T13:54:26.015521+00:00 app[web.4]: [9ac8af54-a305-4a83-953d-2f3e3162068e] Started GET "/=true" for 43444444 at 2018-04-13 13:54:26 +0000
2018-04-13T13:54:26.017980+00:00 app[web.4]: [9ac8af54-a305-4a83-953d-2f3e3162068e] Processing by PooController#i33as */*
2018-04-13T13:54:26.018018+00:00 app[web.4]: [9ac8af54-a305-4a83-953d-2f3e3162068e]   Parameters: {"group"=>"true", "limit"=>"200", "since"=>"2016-07-11T04:56:41Z", "total_count"=>"true", "verbose"=>"true"}
2018-04-13T13:54:26.027151+00:00 app[web.4]: [9ac8af54-a305-4a83-953d-2f3e3162068e] [account_id:33333333333333333]
2018-04-13T13:54:26.040667+00:00 app[web.4]: [9ac8af54-a305-4a83-953d-2f3e3162068e] Completed 304 Not Modified in 22ms (ActiveRecord: 5.1ms)
    LOGS
  end

  it 'be success' do
    'TODO'
  end
end
