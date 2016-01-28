require 'spec_helper'

describe Agnet do
  it 'has a version number' do
    expect(Agnet::VERSION).not_to be nil
  end

  describe 'public instance methods' do
    subject { Agnet.new(4, 16, 10) }

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
        it 'has array of initial factors for hidden and output weight matrix' do
          expects(subject.set_initial_factors.size).to eq(2)
        end
        it 'has array values according to function  1 / inputsize^0.5' do
          expects(subject.set_initial_factors[0]).to eq(0.5)
          expects(subject.set_initial_factors[1]).to eq(0.25)
        end
      end
      context '#set_initial_weights' do
        it 'calcs initial factor for hidden weight matrix' do
        end
        it 'calcs initial factor for output weight matrix' do
        end
        it 'sets initial hidden layer weight matrix' do
        end
        it 'sets initial output layer weight matrix' do
        end
        it 'sets initial hidden weight matrix values between 0.5 and -0.5' do
        end
        it 'sets initial output weight matrix values between 0.5 and -0.5' do
        end
        it 'mulitplys hidden initial factor to hidden weight matrix cales' do
        end
        it 'mulitplys output initial factor to hidden weight matrix cales' do
        end
      end
      context '#feed_forward' do
        it 'calcs weighted sum for each node in hdn layer with hdn weights' do
        end

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
