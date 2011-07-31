config['mongo'] = {
  :database => "wonkavision-sample"
}

environment(:development) do
  config['mongo'][:database] << "_dev"
end

environment(:test) do
  config['mongo'][:database] << "_test"
end

