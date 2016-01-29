require 'agnet/version'
require 'csv'
require 'matrix'
require 'pry'

class Agnet
  def initialize(input_nodes, hidden_nodes, output_nodes, function,
                 input_activation, input_bias, hidden_bias, bits)
    @in_nodes = input_nodes
    @hdn_nodes = hidden_nodes
    @out_nodes = output_nodes
    @function = function
    @input_activation = input_activation
    @label = 3
    @input_bias = input_bias
    @hidden_bias = hidden_bias
    @bits = bits
  end

  def feed_forward
  end

  def scale_initial_weights
    set_initial_factors.map.with_index { |a, i| a * @initial_weights[i] }
  end

  def set_initial_factors
    hdn_init_factor = 1 / (@in_nodes**0.5)
    [hdn_init_factor] << 1 / (@hdn_nodes**0.5)
  end

  def set_initial_weights
    h_w = []
    o_w = []
    @hdn_nodes.times do |i|
      if i == 0
        h_w = Vector.elements(Array.new(@in_nodes + 1) { (rand(0.1) - 0.5) })
                    .covector
      else
        n_w = Vector.elements(Array.new(@in_nodes + 1) { (rand(0.1) - 0.5) })
                    .covector
        h_w = h_w.vstack(n_w)
      end
    end
    @out_nodes.times do |i|
      if i == 0
        o_w = Vector.elements(Array.new(@hdn_nodes + 1) { (rand(0.1) - 0.5) })
                    .covector
      else
        l_w = Vector.elements(Array.new(@hdn_nodes + 1) { (rand(0.1) - 0.5) })
                    .covector
        o_w = o_w.vstack(l_w)
      end
    end
    @initial_weights = [h_w]
    @initial_weights << o_w
  end

  def normalize_input_activation
    array = Array.new(@in_nodes + 1)
    array = @input_activation
    array[@in_nodes] = @input_bias
    Vector.elements(array) / @bits
  end

  def hidden_layer_weighted_sum
    z_v_h = []
    @hdn_nodes.times do |i|
      z_v_h << scale_initial_weights[0].row(i).inner_product(normalize_input_activation)
    end
    return z_v_h
  end

  def hidden_layer_activation
    activation_function(hidden_layer_weighted_sum)
  end

  def activation_function(z)
    fin = Array.new(z.size)
    if @function == 'sigmax'

      res = Array.new(z.size)
      z.each_with_index do |val, i|
        res[i] = Math.exp(val)
      end


      sum = res.inject(:+)
      res.each_with_index do |val, i|


        fin[i] = val / sum
      end
    end

    return fin
  end

  def vectorize_hidden_layer
    array = Array.new(@hdn_nodes + 1)
    array = hidden_layer_activation
    array[@hdn_nodes] = @hidden_bias
    Vector.elements(array)
  end

  def output_layer_weighted_sum
    z_v_o = []
    @out_nodes.times do |i|
      z_v_o << scale_initial_weights[1].row(i).inner_product(vectorize_hidden_layer)
    end
    return z_v_o
  end

  def output_layer_activation
    activation_function(output_layer_weighted_sum)
  end

  def guess(outputs)
    outputs.find_index(outputs.max(1)[0])
  end

  def vectorize_output_layer
    Vector.elements(output_layer_activation)
  end

  def label_array
    y = Array.new(10) { 0 }
    y[@label] = 1
    y
  end

  def output_error
    vectorize_output_layer - Vector.elements(label_array)
  end

  def back_prop_output
    h_e = []
    @out_nodes.times do |w|
      h_e << (scale_initial_weights[1].column(w).inner_product(output_error) * hidden_layer_activation[w])
    end
    h_e
  end
end
