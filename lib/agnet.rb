require 'agnet/version'
require 'csv'
require 'matrix'
require 'pry'

class Agnet
  def initialize(input_nodes, hidden_nodes, output_nodes, function,
                 input_activation, input_bias, hidden_bias, bits, training_size, learning_rate)
    @in_nodes = input_nodes
    @hdn_nodes = hidden_nodes
    @out_nodes = output_nodes
    @function = function
    @input_bias = input_bias
    @hidden_bias = hidden_bias
    @bits = bits
    @lr = learning_rate
    @weights = Array.new(2)
    @training_data = []
    @testing_data = []
    @training_size = training_size
    @input_activation = input_activation
    @label = 3
  end

  def train
    load_data
    set_initial_weights
    scale_initial_weights
    @training_data.each_with_index do |row, i|
      @iteration = (i + 1)
      @input_activation = row[1..@in_nodes]
      @label = row[0]
      output_error
      back_prop_output
      hidden_weights_change
      output_weights_change
      weights_change
      puts @weights[0][0, 0]
      puts @weights[1][0, 0]
    end
  end

  def classify
    @testing_data.each_with_index do |row|
      @input_activation = row[1..@in_nodes]
      @label = row[0]
      normalize_input_activation
      hidden_layer_activation
      output_layer_activation
      training_score
      puts 'Guess: ', guess(output_layer_activation)
      puts 'Label: ', @label
    end
  end

  def iteration
    @iteration
  end

  def training_score
    @it_score = (@label == guess(output_layer_activation))
    @training_score_log << correct
    @total_running_average = @training_score_log.count(true).to_f
  end
  def load_data
    CSV.foreach('train.csv') do |row|
      if @training_data.size <= @training_size
        @training_data << row.map(&:to_i)
        puts 'Row: ', @training_data.size
      else
        @testing_data << row.map(&:to_i)
        puts 'Row: ', (@training_data.size + @testing_data.size)
      end

      break if @training_data.size + @testing_data.size == @training_size +
               (@training_size / 5.0).to_i
    end
    @training_data[1]
  end

  def scale_initial_weights
    @weights = set_initial_factors
               .map.with_index { |a, i| a * initial_weights[i] }
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

  def initial_weights
    @initial_weights
  end

  def normalize_input_activation
    array = Array.new(@in_nodes + 1)
    array = @input_activation
    array[@in_nodes] = @input_bias
    @normalize_input_activation = Vector.elements(array) / @bits
  end

  def hidden_layer_weighted_sum
    z_v_h = []
    @hdn_nodes.times do |i|
      z_v_h << scale_initial_weights[0].row(i).inner_product(normalize_input_activation)
    end
    z_v_h
  end

  def hidden_layer_activation
    @hidden_layer_activation = activation_function(hidden_layer_weighted_sum)
  end

  def activation_function(z)
    fin = Array.new(z.size)
    if @function == 'sigmoid'
      sigmoid(z)
    elsif @function == 'sigmax'
      res = Array.new(z.size)
      z.each_with_index do |val, i|
        res[i] = Math.exp(val)
      end
      sum = res.inject(:+)
      res.each_with_index do |val, i|
        fin[i] = val / sum
      end
    end
    fin
  end
  def sigmoid(z)
    res = Array.new(z.size)
    z.each_with_index do |zee, i|
      res[i] = (1.0 / (1.0 + Math.exp(-zee)))
    end
    res
  end

  def sigmoid_prime(z)
    res = Array.new(z.size)
    z.each_with_index do |zee, i|
      res[i] = ((1.0 / (1.0 + Math.exp(-zee))) *
      (1 - (1.0 / (1.0 + Math.exp(-zee)))))
    end
    res
  end

  def vectorize_hidden_layer
    array = Array.new(@hdn_nodes + 1)
    array = hidden_layer_activation
    array[@hdn_nodes] = @hidden_bias
    @vectorize_hidden_layer = Vector.elements(array)
  end

  def output_layer_weighted_sum
    z_v_o = []
    @out_nodes.times do |i|
      z_v_o << scale_initial_weights[1].row(i)
               .inner_product(vectorize_hidden_layer)
    end
    z_v_o
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
    @output_error = vectorize_output_layer - Vector.elements(label_array)
  end

  def back_prop_output
    h_e = []
    @hdn_nodes.times do |w|
      h_e << (scale_initial_weights[1].column(w).inner_product(@output_error) *
      hidden_layer_activation[w])
    end
    @back_prop_output = h_e
  end

  def output_weights_change
    dwo = []
    @out_nodes.times do |l|
      if l == 0
        r = []
        (@hdn_nodes + 1).times do |o|
          r << @output_error[l] * @vectorize_hidden_layer[o]
        end
        dwo = Vector.elements(r).covector
      else
        r = []
        (@hdn_nodes + 1).times do |o|
          r << @output_error[l] * @vectorize_hidden_layer[o]
        end
        dwv = Vector.elements(r).covector
        dwo = dWo.vstack(dwv)
      end
    end
    @output_weights_change = dwo
  end

  def hidden_weights_change
    dwo = []
    @hdn_nodes.times do |l|
      if l == 0
        r = []
        (@in_nodes + 1).times do |o|
          r << @back_prop_output[l] * @normalize_input_activation[o]
        end
        dwo = Vector.elements(r).covector
      else
        r = []
        (@in_nodes + 1).times do |o|
          r << @back_prop_output[l] * @normalize_input_activation[o]
        end
        dwv = Vector.elements(r).covector
        dwo = dWo.vstack(dwv)
      end
    end
    @hidden_weights_change = dwo
  end

  def weights_change
    @weights[0] = (@weights[0] - @hidden_weights_change * @lr * 0.1)
    @weights[1] = (@weights[1] - @output_weights_change * @lr)
    @weights
  end

  def weights
    @weights
  end
end
