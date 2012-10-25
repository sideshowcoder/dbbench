class ThingRouter < DBbench::Router::Base

  match "^uuid$" => :fake_uuid
  match "^varchar\\((.+)\\)$" => :varchar

end
