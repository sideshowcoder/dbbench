class SomethingRouter < DBbench::Router::Base

  match "^int\\((.+)\\)$" => :int
  match "^varchar\\((.+)\\)$" => :varchar

end
