require 'spec_helper'

describe Agnet do
  it 'has a version number' do
    expect(Agnet::VERSION).not_to be nil
  end

  describe 'public instance methods' do
    before do
      @input_nodes = 4
      @hidden_nodes = 16
      @output_nodes = 10
      @input_activation = [25.0, 151.0, 253.0, 0.0]
      @input_bias = 1.0
      @hidden_bias = 1.0
      @bits = 255.0
      @function = 'sigmax'

    end
    subject { Agnet.new(@input_nodes, @hidden_nodes, @output_nodes, @function, @input_activation, @input_bias, @hidden_bias, @bits) }
    let(:input) do
      [input_activation, weights_hidden, weights_output,
       input_nodes, hidden_nodes, output_nodes]
    end

    let(:output) { subject.process(input) }
    context 'responds to its methods' do
      it { expect(subject).to respond_to(:feed_forward) }
      it { expect(subject).to respond_to(:set_initial_weights) }
      it { expect(subject).to respond_to(:set_initial_factors) }
    end

    context 'executes methods correctly' do
      context '#set_initial_factorss' do
        it 'sets array of initial factors for hdn and output weight matrix' do
          expect(subject.set_initial_factors.size).to eq(2)
        end
        it 'sets array values according to function  1 / inputsize^0.5' do
          expect(subject.set_initial_factors[0]).to eq(0.5)
          expect(subject.set_initial_factors[1]).to eq(0.25)
        end
      end
      context '#set_initial_weights' do
        it 'sets initial hidden layer weight matrix' do
          expect(subject.set_initial_weights[0].column_count)
            .to eq(@input_nodes + 1)
          expect(subject.set_initial_weights[0].row_count).to eq(@hidden_nodes)
        end
        it 'sets initial output layer weight matrix' do
          expect(subject.set_initial_weights[1].column_count)
            .to eq(@hidden_nodes + 1)
          expect(subject.set_initial_weights[1].row_count).to eq(@output_nodes)
        end
        it 'sets initial hidden weight matrix values between 0.5 and -0.5' do
          expect(subject.set_initial_weights[0][0, 0]).to be_within(0.5).of(0)
        end
        it 'sets initial output weight matrix values between 0.5 and -0.5' do
          expect(subject.set_initial_weights[1][0, 0]).to be_within(0.5).of(0)
        end
      end
      context '#scale_initial_weights' do
        it 'mulitplys hidden initial factor to hidden weight matrix calcs' do
          subject.set_initial_weights

          expect(subject.scale_initial_weights[0])
            .to eq( subject.initial_weights[0] *  subject.set_initial_factors[0])
        end
        it 'mulitplys output initial factor to ouput weight matrix calcs' do
          subject.set_initial_weights

          expect(subject.scale_initial_weights[1])
            .to eq(subject.initial_weights[1]* subject.set_initial_factors[1])
        end
      end
      context '#normalize_input_activation' do
        it 'returns a vector' do
          expect(subject.normalize_input_activation).to be_a(Vector)
        end
        it 'returns vector with values between 0 and 1' do
          expect(subject.normalize_input_activation[0])
            .to be_within(0.5).of(0.5)
        end
        it 'has a vector size of input_nodes + 1 for a bias value' do
          expect(subject.normalize_input_activation.size)
            .to eq(@input_nodes + 1)
        end
      end
      context '#hidden_layer_weighted_sum' do
        it 'calcs weight sum vector for nodes in hdn layer with hdn weights' do
          subject.set_initial_weights

          expect(subject.hidden_layer_weighted_sum[0])
            .to eq(subject.scale_initial_weights[0]
            .row(0).inner_product(subject.normalize_input_activation))
        end
        it 'returns array of size hidden nodes' do
          subject.set_initial_weights
          subject.normalize_input_activation

          expect(subject.hidden_layer_weighted_sum.size).to eq(@hidden_nodes)
        end
      end
      context '#hidden_layer_activation' do
        it 'applys activation function to each hidden node value' do
          subject.set_initial_weights
          subject.scale_initial_weights
          subject.normalize_input_activation

          expect(subject.hidden_layer_activation)
            .to eq(subject.activation_function(subject.hidden_layer_weighted_sum))
        end
      end
      context '#activation_function' do
        it 'returns select activation_function' do
          subject.set_initial_weights
          subject.normalize_input_activation

          #expect(subject.activation_function([.3,.6])).to eq(subject.hidden_layer_weighted_sum)
        end
      end

      context '#vectorize_hidden_layer' do
        it 'returns a vector' do
          subject.set_initial_weights
          subject.scale_initial_weights
          subject.normalize_input_activation

          expect(subject.vectorize_hidden_layer).to be_a(Vector)
        end
        it 'the initial values do not change from array to vector ' do
          subject.set_initial_weights
          subject.scale_initial_weights
          subject.normalize_input_activation

          expect(subject.vectorize_hidden_layer[0])
            .to eq(subject.hidden_layer_activation[0])
        end
        it 'adds bias to end of vector' do
          subject.set_initial_weights
          subject.scale_initial_weights
          subject.normalize_input_activation

          expect(subject.vectorize_hidden_layer.size)
            .to eq(subject.hidden_layer_activation.size + 1)
        end
      end
      context '#output_layer_weighted_sum' do
        it 'calcs weight sum vector for nodes in hdn layer with hdn weights' do
          subject.set_initial_weights
          subject.scale_initial_weights
          subject.normalize_input_activation

          expect(subject.output_layer_weighted_sum[0])
            .to eq(subject.scale_initial_weights[1]
            .row(0).inner_product(subject.vectorize_hidden_layer))
        end
        it 'returns array of size output nodes' do
          subject.set_initial_weights
          subject.scale_initial_weights
          subject.normalize_input_activation

          expect(subject.output_layer_weighted_sum.size)
            .to eq(@output_nodes)
        end
      end
      context '#output_layer_activation' do
        it 'applys activation function to each output node value' do
          subject.set_initial_weights
          subject.scale_initial_weights
          subject.normalize_input_activation

          expect(subject.output_layer_activation)
            .to eq(subject.activation_function(subject.output_layer_weighted_sum))
        end
      end
      context '#guess' do
        it 'returns the index of the max value in an array' do
          array = [2, 4.3, 6.32, 1]

          expect(subject.guess(array))
            .to eq(2)
        end
      end
      context '#vectorize_output_layer' do
        it 'returns a vector' do
          subject.set_initial_weights
          subject.normalize_input_activation

          expect(subject.vectorize_output_layer).to be_a(Vector)
        end
        it 'the initial values do not change from array to vector ' do
          subject.set_initial_weights
          subject.normalize_input_activation

          expect(subject.vectorize_output_layer[0])
            .to eq(subject.output_layer_activation[0])
        end
        it 'adds bias to end of vector' do
          subject.set_initial_weights
          subject.normalize_input_activation

          expect(subject.vectorize_output_layer.size)
            .to eq(subject.output_layer_activation.size)
        end
      end
      context '#label_array' do
        it 'returns an array' do
          expect(subject.label_array).to be_a(Array)
        end
        it 'has a size of output size' do
          expect(subject.label_array.size).to eq(@output_nodes)
        end
        it 'has 1 max that equals 1' do
          expect(subject.label_array.count(1)).to eq(1)
        end
        it 'has other values equal 0' do
          expect(subject.label_array.count(0)).to eq(9)
        end
      end
      context '#output_error' do
        it 'returns an array' do
          subject.set_initial_weights
          subject.normalize_input_activation

          expect(subject.output_error).to be_a(Vector)
        end
        it 'has a size of output size' do
          subject.set_initial_weights
          subject.normalize_input_activation

          expect(subject.output_error.size).to eq(@output_nodes)
        end
        it 'returns the difference between label and output as vector' do
          subject.set_initial_weights
          subject.normalize_input_activation

          expect(subject.output_error).to eq(subject.vectorize_output_layer - Vector.elements(subject.label_array))
        end
      end
      context '#back_prop_output' do
        it 'returns an array' do
          subject.set_initial_weights
          subject.normalize_input_activation

          expect(subject.back_prop_output).to be_a(Array)
        end
        it 'back propogates output error' do
          subject.set_initial_weights
          subject.normalize_input_activation

          expect(subject.back_prop_output[0])
            .to eq(subject.scale_initial_weights[1]
            .column(0).inner_product(subject.output_error) * subject.hidden_layer_activation[0])
        end
      end
      context '#hidden_weights_delta' do
        it 'returns a matrix' do
          subject.set_initial_weights
          subject.normalize_input_activation

          expect(subject.hidden_weights_change).to be_a(Matrix)
        end
        it 'matrix has hidden_nodes # of rows' do
          subject.set_initial_weights
          subject.normalize_input_activation

          expect(subject.hidden_weights_change.row_count).to eq(@hidden_nodes)
        end
        it 'matrix has input_nodes + 1  # of columns' do
          subject.set_initial_weights
          subject.normalize_input_activation

          expect(subject.hidden_weights_change.column_count).to eq(@input_nodes + 1)
        end
      end
      context '#output_weights_delta' do
        it 'returns a matrix' do
          subject.set_initial_weights
          subject.normalize_input_activation

          expect(subject.output_weights_change).to be_a(Matrix)
        end
        it 'matrix has output_nodes # of rows' do
          subject.set_initial_weights
          subject.normalize_input_activation

          expect(subject.output_weights_change.row_count).to eq(@output_nodes)
        end
        it 'matrix has hidden_nodes + 1  # of columns' do
          subject.set_initial_weights
          subject.normalize_input_activation

          expect(subject.output_weights_change.column_count).to eq(@hidden_nodes + 1)
        end
      end
      context '#weights_change' do
        it 'returns an array' do
          subject.set_initial_weights
          subject.scale_initial_weights
          subject.normalize_input_activation

          expect(subject.weights_change).to be_a(Array)
        end
        it 'has first value in array that is a matrix' do
          subject.set_initial_weights
          subject.scale_initial_weights
          subject.normalize_input_activation

          expect(subject.weights_change[0]).to be_a(Matrix)

        end
        it  'has first value in array that has output_nodes # of rows' do
          subject.set_initial_weights
          subject.scale_initial_weights
          subject.normalize_input_activation

          expect(subject.weights_change[0].row_count).to eq(@hidden_nodes)
        end
        it 'has first value in array that has hidden_nodes + 1  # of columns' do
          subject.set_initial_weights
          subject.scale_initial_weights
          subject.normalize_input_activation

          expect(subject.weights_change[0].column_count).to eq(@input_nodes + 1)
        end
        it 'has second value in array that is a matrix' do
          subject.set_initial_weights
          subject.scale_initial_weights
          subject.normalize_input_activation

          expect(subject.weights_change[1]).to be_a(Matrix)

        end
        it  'has second value in array that has output_nodes # of rows' do
          subject.set_initial_weights
          subject.scale_initial_weights
          subject.normalize_input_activation

          expect(subject.weights_change[1].row_count).to eq(@output_nodes)
        end
        it 'has second value in array that has hidden_nodes + 1  # of columns' do
          subject.set_initial_weights
          subject.scale_initial_weights
          subject.normalize_input_activation

          expect(subject.weights_change[1].column_count).to eq(@hidden_nodes + 1)
        end
      end
    end
  end
end
