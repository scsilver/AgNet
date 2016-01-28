require 'agnet/version'

class Agnet
  def initialize(input_nodes, hidden_nodes, output_nodes)
    @in_nodes = input_nodes
    @hdn_nodes = hidden_nodes
    @out_nodes = output_nodes
  end

  def feed_forward

  end

  def set_initial_factors
    hdn_init_factor = 1 / ((@in_nodes)**(0.5))
    [hdn_init_factor] << 1 / (@hdn_nodes**(0.5))
  end

  def set_initial_weights
  end
end
