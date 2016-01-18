require 'spec_helper'


describe Agnet do
  it 'has a version number' do
    expect(Agnet::VERSION).not_to be nil
  end

  describe "public instance methods" do
    subject { Agnet.new }


    let(:input) { [input_activation,weights_hidden,weights_output,input_nodes,hidden_nodes,output_nodes] }
    let(:output) { subject.process(input) }
    context "responds to its methods" do

      it { expect(subject).to respond_to(:feed_forward) }
      it { expect(subject).to respond_to(:set_initial_weights) }

    end

    context "executes methods correctly" do
      context "#feed_forward" do
        it "calcs weighted sum for each node in hidden layer with hidden weights" do

	       end

        it "activates each node in hidden layer" do

	       end

	      it "cals weighted sum for each node in output layer with output weights" do

	      end

	      it "activates each node in output layer" do

	      end

      end
      context "#set_initial_weights" do
        it "calcs initial factor for hidden weight matrix" do
        end
        it "calcs initial factor for output weight matrix" do
        end
        it "sets initial hidden layer weight matrix" do
        end
        it "sets initial output layer weight matrix" do
        end
        it "sets initial hidden weight matrix values between 0.5 and -0.5" do
        end
        it "sets initial output weight matrix values between 0.5 and -0.5" do
        end
        it "mulitplys hidden initial factor to hidden weight matrix cales" do
        end
        it "mulitplys output initial factor to hidden weight matrix cales" do
        end
      end

    end
  end
end
