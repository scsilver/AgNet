require 'agnet/version'
require 'csv'
require 'matrix'
require 'pry'

class Agnet
  def initialize(input_nodes, hidden_nodes, output_nodes)
    @in_nodes = input_nodes
    @hdn_nodes = hidden_nodes
    @out_nodes = output_nodes
  end

  def feed_forward

  end
  def scale_initial_weights()
    set_initial_factors.map.with_index{ | a, i | a * @initial_weights[i] }
  end
  def set_initial_factors
    hdn_init_factor = 1 / ((@in_nodes)**(0.5))
    [hdn_init_factor] << 1 / (@hdn_nodes**(0.5))
  end
  def set_initial_weights
    h_w = []
    o_w = []
    @hdn_nodes.times do |i|
      if i == 0
        h_w = (Vector.elements(Array.new(@in_nodes+1) { (rand(0.1) - 0.5) }))
              .covector
      else
        n_w = (Vector.elements(Array.new(@in_nodes+1) { (rand(0.1) - 0.5) }))
              .covector
        h_w = h_w.vstack(n_w)
      end
    end
    @out_nodes.times do |i|
        if i == 0
          o_w = (Vector.elements(Array.new(@hdn_nodes+1) { (rand(0.1) - 0.5) }))
                .covector
        else
          l_w = (Vector.elements(Array.new(@hdn_nodes+1) { (rand(0.1) - 0.5) }))
                .covector
          o_w = o_w.vstack(l_w)
        end
      end
    @initial_weights = [h_w]
    @initial_weights << o_w
  end
end
