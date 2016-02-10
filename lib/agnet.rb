require 'agnet/version'
require 'csv'
require 'matrix'
require 'pry'

class Agnet
  def initialize(opt = {})
    # (input_nodes, hidden_nodes, output_nodes, function,
    #             input_activation, input_bias, hidden_bias, bits, training_size, learning_rate)
    @function = Array.new(2)
    opt[:input_nodes] ? @in_nodes = opt[:input_nodes] : @in_nodes = 784
    opt[:bits] ? @bits = opt[:bits].to_f : @bits = 255.0
    opt[:hidden_nodes] ? @hdn_nodes = opt[:hidden_nodes] : @hdn_nodes = 15
    opt[:output_nodes] ? @out_nodes = opt[:output_nodes] : @out_nodes = 10
    opt[:hidden_layer_function] ? @function[0] = opt[:hidden_layer_function] : @function[0] = 'sigmoid'
    opt[:output_layer_function] ? @function[1] = opt[:output_layer_function] : @function[1] = 'soft_max'
    opt[:input_bias] ? @input_bias = opt[:input_bias] : @input_bias = 1.0
    opt[:hidden_bias] ? @hidden_bias = opt[:hidden_bias] : @hidden_bias = 1.0
    opt[:learning_rate] ? @learning_rate = opt[:learning_rate] : @learning_rate = 0.05
    @input_activation = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    @label = 1
    @weights = Array.new(2)
    @training_score_log  = []
    @testing_score_log  = []
    @out_z = []
    @hdn_z = []
    @error = nil
    @training_data = []
    @testing_data = []
    @iteration = 0
  end

  def train(path, opt = {})
    @training_data = []
    @testing_data = []
    @training_score_log = []
    opt[:training_size] ? @training_size = opt[:training_size] : @training_size = 3000
    opt[:testing_size] ? @testing_size = opt[:testing_size] : @testing_size = (@training_size / 5.0).ceil
    @iteration = 0

    load_data(path, @training_size, @testing_size)
    set_initial_weights
    scale_initial_weights

    @training_data.each_with_index do |row, i|
      @iteration = (i + 1)
      @input_activation = row[1..@in_nodes]
      @label = row[0]

      classify(@input_activation)

      training_score
      output_error
      back_prop_output
      hidden_weights_change
      output_weights_change
      weights_change
      puts @weights[0][0, 0]
      puts @weights[1][0, 0]
    end
    @label = nil
    @running_average_100
  end

  def classify(sample)
    @input_activation = sample
    normalize_input_activation
    hidden_layer_weighted_sum
    hidden_layer_activation
    output_layer_weighted_sum
    @output_layer_activation = output_layer_activation
    puts 'Activation: ', @output_layer_activation
    gs = guess(@output_layer_activation)
    puts 'Guess: ', gs
    puts 'Label: ', @label
    @output_layer_activation
  end

  def test(opt = {})
    @testing_score_log = []
    opt[:test_first] ? test_first = opt[:test_first] : test_first = @testing_size
    @iteration = 0
    test_chunk = @testing_data.first(test_first)
    test_chunk.each_with_index do |row, i|
      @iteration = (i + 1)
      @input_activation = row[1..@in_nodes]
      @label = row[0]
      classify(@input_activation)
      testing_score
    end
    @label = nil
    @total_running_average
  end

  def it_score
    @it_score
  end


  def iteration
    @iteration
  end

  def training_score
    @it_score = @label == guess(@output_layer_activation)
    @training_score_log << @it_score
    count_true = @training_score_log.count(true)
    puts 'Iteration: ', @iteration
    puts '# Correct : ', count_true
    puts 'Total Acuracy: ', @total_running_average = count_true.to_f / @iteration.to_f
    puts 'Last 100 Acuracy: ', @running_average_100 = @training_score_log.last(100).count(true).to_f / @testing_score_log.last(100).count.to_f
    puts 'Last 1000 Acuracy: ', @running_average_1000 = @training_score_log.last(1000).count(true).to_f / @training_score_log.last(1000).count.to_f
    puts 'Last 5000 Acuracy: ', @running_average_5000 = @training_score_log.last(5000).count(true).to_f / @training_score_log.last(5000).count.to_f
    @it_score = nil
    [@iteration,@training_score_log,@total_running_average,@running_average_100,@running_average_1000,@running_average_5000]

  end

  def testing_score
    @it_score = @label == guess(@output_layer_activation)
    @testing_score_log << @it_score
    count_true = @testing_score_log.count(true)
    puts 'Iteration: ', @iteration
    puts '# Correct : ', count_true
    puts 'Total Acuracy: ', @total_running_average = count_true.to_f / @iteration.to_f
    puts 'Last 100 Acuracy: ', @running_average_100 = @testing_score_log.last(100).count(true).to_f / @testing_score_log.last(100).count.to_f
    puts 'Last 1000 Acuracy: ', @running_average_1000 = @testing_score_log.last(1000).count(true).to_f / @testing_score_log.last(1000).count.to_f
    puts 'Last 5000 Acuracy: ', @running_average_5000 = @testing_score_log.last(5000).count(true).to_f / @testing_score_log.last(5000).count.to_f
    @it_score = nil
    [@iteration,@testing_score_log,@total_running_average,@running_average_100,@running_average_1000,@running_average_5000]
  end

  def load_data(path, training_size, testing_size)
    CSV.foreach(path) do |row|
        if @training_data.size < training_size
          @training_data << row.map(&:to_i)
          puts 'Row: ', @training_data.size
        else
          @testing_data << row.map(&:to_i)
          puts 'Row: ', (@training_data.size + @testing_data.size)
        end
        break if @training_data.size + @testing_data.size == training_size + testing_size
      end
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
    array = Array.new(@in_nodes + 1) { 0 }
    array = @input_activation
    array[@in_nodes] = @input_bias * @bits
    @normalize_input_activation = Vector.elements(array) / @bits
  end

  def hidden_layer_weighted_sum
    @hdn_z = []
    @hdn_nodes.times do |i|
      @hdn_z << @weights[0].row(i).inner_product(@normalize_input_activation)
    end
    back_prop_derivation
    @hdn_z
  end

  def hidden_layer_activation
    @hidden_layer_activation = activation_function(@hdn_z, 0)
  end

  def back_prop_derivation
    @back_prop_derivation = sigmoid_prime(@hdn_z)
  end

  def activation_function(z, layer)
    fin = Array.new(z.size)
    if @function[layer] == 'sigmoid'
      fin = sigmoid(z)
    elsif @function[layer] == 'soft_max'
      fin = soft_max(z)
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

  def soft_max(z)
    res = Array.new(z.size)
    z.each_with_index do |z, i|
      res[i] = Math.exp(z)
    end
    sum = res.inject(:+)
    res.each_with_index do |l, i|
      res[i] = l / sum
    end
    res
  end

  def vectorize_hidden_layer
    array = Array.new(@hdn_nodes + 1)
    array = @hidden_layer_activation
    array[@hdn_nodes] = @hidden_bias
    @vectorize_hidden_layer = Vector.elements(array)
  end

  def output_layer_weighted_sum
    @out_z = []
    @out_nodes.times do |i|
      @out_z << @weights[1].row(i)
               .inner_product(vectorize_hidden_layer)
    end
    @out_z
  end

  def output_layer_activation
    @output_layer_activation = activation_function(@out_z, 1)
  end

  def guess(outputs)
    outputs.find_index(outputs.max(1)[0])
  end

  def vectorize_output_layer

    Vector.elements(@output_layer_activation)
  end

  def label_array
    y = Array.new(10) { 0 }
    y[@label] = 1
    y
  end

  def output_error
    @output_error = vectorize_output_layer - Vector.elements(label_array)
    puts 'Error: ', @output_error.collect(&:abs).inject(:+)
    @output_error
  end

  def back_prop_output


    h_e = []
    @hdn_nodes.times do |w|
      h_e << (@weights[1].column(w).inner_product(@output_error) *
      @back_prop_derivation[w])
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
        r=[]
      else
        r = []
        (@hdn_nodes + 1).times do |o|
          r << @output_error[l] * @vectorize_hidden_layer[o]
        end
        dwv = Vector.elements(r).covector
        dwo = dwo.vstack(dwv)
        r=[]
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
        r = []
      else
        r = []
        (@in_nodes + 1).times do |o|
          r << @back_prop_output[l] * @normalize_input_activation[o]
        end
        dwv = Vector.elements(r).covector
        dwo = dwo.vstack(dwv)
        r= []
      end
    end
    @hidden_weights_change = dwo
  end

  def weights_change
    @weights[0] = (@weights[0] - @hidden_weights_change * @learning_rate * 10)
    @weights[1] = (@weights[1] - @output_weights_change * @learning_rate)
    @weights
  end

  def weights
    @weights
  end
end
