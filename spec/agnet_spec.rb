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
      @input_activation = [24, 155, 255, 0]
      @input_bias = 1.0
      @hidden_bias = 1.0
      @bits = 255
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
          init_weights = subject.set_initial_weights
          init_factors = subject.set_initial_factors

          expect(subject.scale_initial_weights[0][0, 0])
            .to eq(init_weights[0][0, 0] * init_factors[0])
        end
        it 'mulitplys output initial factor to ouput weight matrix calcs' do
          init_weights = subject.set_initial_weights
          init_factors = subject.set_initial_factors

          expect(subject.scale_initial_weights[1][0, 0])
            .to eq(init_weights[1][0, 0] * init_factors[1])
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
          subject.normalize_input_activation

          expect(subject.hidden_layer_weighted_sum[0])
            .to eq(subject.scale_initial_weights[0]
            .row(0).inner_product(@input_activation.map{ |r| r / 255}))
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
          subject.normalize_input_activation

          expect(subject.vectorize_hidden_layer).to be_a(Vector)
        end
        it 'the initial values do not change from array to vector ' do
          subject.set_initial_weights
          subject.normalize_input_activation

          expect(subject.vectorize_hidden_layer[0])
            .to eq(subject.hidden_layer_activation[0])
        end
        it 'adds bias to end of vector' do
          subject.set_initial_weights
          subject.normalize_input_activation

          expect(subject.vectorize_hidden_layer.size)
            .to eq(subject.hidden_layer_activation.size + 1)
        end
      end
      context '#output_layer_weighted_sum' do
        it 'calcs weight sum vector for nodes in hdn layer with hdn weights' do
          subject.set_initial_weights
          subject.normalize_input_activation

          expect(subject.output_layer_weighted_sum[0])
            .to eq(subject.scale_initial_weights[1]
            .row(0).inner_product(subject.vectorize_hidden_layer))
        end
        it 'returns array of size output nodes' do
          subject.set_initial_weights
          subject.normalize_input_activation

          expect(subject.output_layer_weighted_sum.size)
            .to eq(@output_nodes)
        end
      end
      context '#output_layer_activation' do
        it 'applys activation function to each output node value' do

          subject.set_initial_weights
          subject.normalize_input_activation

          subject.set_initial_weights
          subject.normalize_input_activation

          expect(subject.output_layer_activation)
            .to eq(subject.activation_function(subject.output_layer_weighted_sum))
        end
      end
      context '#feed_forward' do
        it 'activates each node in hidden layer' do
        end
        it 'cals weighted sum for each node in outpt layer with otpt weights' do
        end
        it 'activates each node in output layer' do
        end
      end
    end
  end
end
